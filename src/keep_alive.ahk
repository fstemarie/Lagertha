#Requires AutoHotkey v2.0
; #NoTrayIcon
#SingleInstance Force

#Include <toast>

;-----------------------------------------------------------------------------------------------------------------------------
; LMI Keep Alive
;-----------------------------------------------------------------------------------------------------------------------------

; --- Shell Hook Message Codes (wParam) ---
global SHELLHOOK                  := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
global HSHELL_WINDOWCREATED       := 1
global HSHELL_WINDOWDESTROYED     := 2
global HSHELL_ACTIVATESHELLWINDOW := 3
global HSHELL_WINDOWACTIVATED     := 4
global HSHELL_GETMINRECT          := 5
global HSHELL_REDRAW              := 6
global HSHELL_TASKMAN             := 7
global HSHELL_LANGUAGE            := 8
global HSHELL_SYSMENU             := 9
global HSHELL_ENDTASK             := 10
global HSHELL_ACCESSIBILITYSTATE  := 11
global HSHELL_APPCOMMAND          := 12
global HSHELL_WINDOWREPLACED      := 13
global HSHELL_WINDOWREPLACING     := 14
global HSHELL_MONITORCHANGED      := 16

; --- Configuration ---
global LMI_CLASS := "ahk_class LMITC_DialogStandaloneRescueFrame"
global WOOSH_SOUND := A_ScriptDir "\sounds\woosh.mp3"
global CheckInterval := 60000     ; Check every minute
global MaxElapsedTime := 599999
global lastActive := 0
global LMI_hWnd := 0
global was_lmi := 0


; Register the Hook
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(SHELLHOOK, App_OnShellMessage)

SetTimer(KeepAlive, CheckInterval)
LMI_hWnd := WinExist(LMI_CLASS)
if (LMI_hWnd) {
	if (WinActive("ahk_id " LMI_hWnd)) {
		LMI_OnActivated()
	} else {
		LMI_OnDeactivated()
	}
}

App_OnShellMessage(event, hWnd, *) {
    global was_lmi
    LMI_hWnd := WinExist(LMI_CLASS)
   
    if (event = HSHELL_WINDOWCREATED) and (hWnd = LMI_hWnd)
        LMI_OnCreate()
    else if (event = HSHELL_WINDOWDESTROYED) and (hWnd = LMI_hWnd)
        LMI_OnClose()
    ; Lorsque la fenetre active change
    else if (event = HSHELL_WINDOWACTIVATED) and (LMI_hWnd)
    {
        ; Si lmi devient active
        if (hWnd = LMI_hWnd)
        {
            LMI_OnActivated()
        }
        ; Si lmi etait la derniere active
        else if (was_lmi)
        {
            LMI_OnDeactivated()
        }
    }
}

LMI_OnCreate()
{
    ;toast("LMI Created")
}

LMI_OnClose()
{
    ;toast("LMI Destroyed")
    global lastActive := 0
}

LMI_OnActivated()
{
    ; toast("LMI Activated")
    global was_lmi := 1
    global lastActive := 0
}

LMI_OnDeactivated()
{
    ; toast("LMI Deactivated")
    global was_lmi := 0
    global lastActive := A_TickCount
}

KeepAlive()
{
    global lastActive
	
	LMI_hWnd := WinExist(LMI_CLASS)
	if !(LMI_hWnd) { ; Si il n'y a pas de fenetre LMI, on quitte
		return
	}
	if (WinActive(LMI_hWnd) and A_TimeIdle < 120000) { ; Si la fenetre LMI est active, pas besoin. On quitte
		return
	}

    elapsed := A_TickCount - lastActive
    if (elapsed >= MaxElapsedTime or A_TimeIdle >= MaxElapsedTime)
    {
		currentWin := WinExist("A")

		CoordMode("Mouse", "Window")
		SoundPlay(WOOSH_SOUND)
		sleep(2000)
		MouseGetPos(&x, &y)
		WinActivate(LMI_hWnd)
		WinWaitActive(LMI_hWnd)
		MouseClick("Left", 350, 210)
		currentWin := WinExist("A")
		Try WinActivate(currentWin)
		MouseMove(x, y)
    }
}
