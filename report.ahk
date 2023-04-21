#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

F12::
CoordMode, Mouse, Screen
BlockInput, On
WinGet, hwnd, ID, League of Legends
WinGetPos, , , , win_height, ahk_id %hwnd%
MouseGetPos, xpos, ypos
WinGetTitle, title, ahk_id %hwnd%
; MsgBox, The position of window "%title%" is (%xpos%, %ypos%), and its height is %win_height%.

Click, %xpos%, %ypos%
Loop, 6
{
    if (A_Index = 3)
        ypos += Floor(27 * (win_height / 720) )
    else
        ypos += Floor(45 * (win_height / 720) )
    Click, %xpos%, %ypos%
    ; Sleep, 500
}
BlockInput, Off
return
