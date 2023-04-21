#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

F12::
MouseGetPos, xpos, ypos
Click, %xpos%, %ypos%
Loop, 6
{
    if (A_Index = 3)
        ypos += 27
    else
        ypos += 45
    Click, %xpos%, %ypos%
}
return
