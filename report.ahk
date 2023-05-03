#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

F12::
CoordMode, Mouse, Screen
IfWinNotExist, League of Legends
{
    MsgBox, "League of Legends" window not found.
    return
}
BlockInput, On
WinGet, hwnd, ID, League of Legends
WinGetPos, win_x, win_y, win_width, win_height, ahk_id %hwnd%
MouseGetPos, xpos, ypos ; Stop mousemove
WinGetTitle, title, ahk_id %hwnd%
; ToolTip, x: %xpos%`, y: %ypos%`, winheight: %win_height%
checkbox_ycoords := [565, 609, 669, 714, 757, 804, 847] ; collected from my screen at window height of 720px
Click, %xpos%, %ypos%
Loop % checkbox_ycoords.Length()
{
    if (A_Index = 1) {
        continue 
    }
    diff := checkbox_ycoords[A_Index] - checkbox_ycoords[A_Index - 1]
    ypos += Floor(diff * (win_height / 720) )
    Click, %xpos%, %ypos%
}
BlockInput, Off ; Resume mousemove
return
