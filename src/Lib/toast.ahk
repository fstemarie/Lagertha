#Requires AutoHotkey v2.0

#Include <gdip>

/**
 * Display a dark, rounded toast notification in the bottom right corner.
 * @param {String} message - The text to display.
 * @param {Integer} duration - Time in milliseconds before the toast fades out.
 */
toast(message, duration := 2000) {
    ToastManager.Create(message, duration)
}

class ToastManager {
    static ActiveToasts := []
    
    ; --- STYLING CONFIGURATION ---
    static Opacity := 255       ; 0 (transparent) to 255 (opaque)
    static BGColor := "1A1A1A"  ; Dark rectangle hex
    static BorderColor := "FFFFFF" ; White bezel hex
    static TextColor := "FFFFFF"   ; White text hex
    static BorderThickness := 2
    static CornerRadius := 10
    static FontSize := 18
    static FontName := "Segoe UI"
    static Padding := 15
    static Margin := 10         ; Gap between screen edge and toasts, and between toasts
    ; ------------------------------

    static Create(message, duration) {
        ; Start Gdip if not already running
        if !DllCall("GetModuleHandle", "Str", "gdiplus", "Ptr")
            pToken := Gdip_Startup()
            
        inst := ToastInstance(message, duration, this)
        this.ActiveToasts.Push(inst)
        this.RepositionAll()
    }

    static Remove(inst) {
        for idx, activeInst in this.ActiveToasts {
            if (activeInst = inst) {
                this.ActiveToasts.RemoveAt(idx)
                break
            }
        }
        this.RepositionAll()
    }

    static RepositionAll() {
        ; Get primary monitor work area (avoids taskbar overlap)
        MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
        
        currentY := Bottom - this.Margin
        
        ; Loop backwards (newest toasts bubble up from the bottom right corner)
        for idx, inst in this.ActiveToasts {
            targetX := Right - inst.W - this.Margin
            targetY := currentY - inst.H
            
            inst.Move(targetX, targetY)
            currentY := targetY - this.Margin
        }
    }
}

class ToastInstance {
    __New(message, duration, config) {
        this.cfg := config
        this.message := message
        
        ; 1. Create a dummy GUI to calculate text bounds accurately
        static fontOptions := "s" config.FontSize " w500"
        tGui := Gui()
        tGui.SetFont(fontOptions, config.FontName)
        txtCtrl := tGui.AddText("", message)
        txtCtrl.GetPos(,, &tw, &th)
        tGui.Destroy()
        
        ; Account for padding and borders
        this.W := tw + (config.Padding * 2) + (config.BorderThickness * 2)
        this.H := th + (config.Padding * 2) + (config.BorderThickness * 2)
        
        ; 2. Setup Layered GUI
        this.hwnd := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x80000 +LastFound")
        this.hwnd.Show("NA x" A_ScreenWidth " y" A_ScreenHeight " w" this.W " h" this.H)
        
        ; 3. Draw GDI+ Graphic
        this.hdc := CreateCompatibleDC()
        this.hbm := CreateDIBSection(this.W, this.H)
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4) ; Antialiasing
        Gdip_SetTextRenderingHint(this.G, 4) ; Anti-aliased text
        
        this.Draw()
        
        ; 4. Set Initial Expiry Timer
        this.timerCB := ObjBindMethod(this, "Dismiss")
        SetTimer(this.timerCB, -duration)
    }
    
    Draw() {
        ; Clear canvas
        Gdip_GraphicsClear(this.G)
        
        ; Create Background Brush
        bgARGB := "0x" Format("{:02X}", this.cfg.Opacity) this.cfg.BGColor
        pBrush := Gdip_BrushCreateSolid(bgARGB)
        
        ; Create Border Pen
        borderARGB := "0x" Format("{:02X}", this.cfg.Opacity) this.cfg.BorderColor
        pPen := Gdip_CreatePen(borderARGB, this.cfg.BorderThickness)
        
        ; Adjust shapes slightly inward to avoid edge clipping
        half := this.cfg.BorderThickness / 2
        rectX := half
        rectY := half
        rectW := this.W - this.cfg.BorderThickness
        rectH := this.H - this.cfg.BorderThickness
        
        ; Draw Rounded Background and Bezel
        Gdip_FillRoundedRectangle(this.G, pBrush, rectX, rectY, rectW, rectH, this.cfg.CornerRadius)
        Gdip_DrawRoundedRectangle(this.G, pPen, rectX, rectY, rectW, rectH, this.cfg.CornerRadius)
        
        ; Draw Text
        textARGB := "0x" Format("{:02X}", this.cfg.Opacity) this.cfg.TextColor
        pTextBrush := Gdip_BrushCreateSolid(textARGB)
        
        ; Format string layout (Center Alignment inside our padded zone)
        options := "x" (this.cfg.Padding + this.cfg.BorderThickness)
                 . " y" (this.cfg.Padding + this.cfg.BorderThickness)
                 . " w" (this.W - (this.cfg.Padding * 2))
                 . " h" (this.H - (this.cfg.Padding * 2))
                 . " Center vCenter r4 Bold"
                 . " s" (this.cfg.FontSize)
                 
        Gdip_TextToGraphics(this.G, this.message, options " c" pTextBrush, this.cfg.FontName)
        
        ; Clean up GDI+ drawing resources
        Gdip_DeleteBrush(pBrush)
        Gdip_DeleteBrush(pTextBrush)
        Gdip_DeletePen(pPen)
    }
    
    Move(x, y) {
        ; Instantly update layered window position using UpdateLayeredWindow
        UpdateLayeredWindow(this.hwnd.Hwnd, this.hdc, x, y, this.W, this.H, this.cfg.Opacity)
    }
    
    Dismiss() {
        SetTimer(this.timerCB, 0)
        
        ; Cleanup Window Graphics
        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        DeleteDC(this.hdc)
        Gdip_DeleteGraphics(this.G)
        this.hwnd.Destroy()
        
        ; Notify manager to fill the gap
        ToastManager.Remove(this)
    }
}