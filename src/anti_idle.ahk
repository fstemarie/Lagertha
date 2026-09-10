#Requires AutoHotkey v2.0
#SingleInstance Force

#Include <toast>

;-----------------------------------------------------------------------------------------------------------------------------
; Anti-Idle
;-----------------------------------------------------------------------------------------------------------------------------

TimeInterval := 60000 ; 1 minute
MaxIdleTime := 299999 ; 5 minutes

SetTimer(DontSleep, TimeInterval)

DontSleep() {
    if (A_TimeIdlePhysical >= MaxIdleTime) {
        toast("Anti-Idle")
        MouseMove(1, 0, 0, "R")
        Sleep(50)
        MouseMove(-1, 0, 0, "R")
    }
}