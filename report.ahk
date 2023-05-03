#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ;  Ensures that only one instance of the script is running at a time.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MyHotkey_plain := "F12"
MyHotkey := "~" MyHotkey_plain
Hotkey, % MyHotkey, FuncHotkeyAction

bgcolour := "202020"
win_width := 640
win_height := 480

Gui, Show, w%win_width% h%win_height%
Gui, Color, c%bgcolour%
Gui, Font, cFFFFFF,

my_text := "LoL Report Macro by tadyen"
Gui, Font, s12
Gui, Add, Text, xm ym, %my_text%

Gui, Font, s10
Gui, Add, Link, xp yp+20, <a href="https://github.com/tadyen/LoL-Report-macro">https://github.com/tadyen/LoL-Report-macro</a>

my_text := "Selects all checkboxes in the report window and adds an additional report message."
Gui, Add, Text, xp yp+30, %my_text%

my_text := "Current macro Keybind: "
button_text := MyHotkey_plain
Gui, Add, Text, xp yp+40, %my_text%
Gui, Add, Button, xp+150 yp-8 w160 h30 vMacroDispButton gFuncMacroDispButton, %button_text%
Gui, Add, Hotkey, xp yp w160 h30 r1 vHotkeyBox, %button_text%
GuiControl, Disable, HotkeyBox
GuiControl, Hide, HotkeyBox
button_text := "Apply"
Gui, Add, Button, xp+200 yp h30 vHotkeyApplyButton gFuncHotkeyApplyButton, %button_text%
button_text := "Cancel"
Gui, Add, Button, xp+80 yp h30 vHotkeyCancelButton gFuncHotkeyCancelButton, %button_text%
GuiControl, Hide, HotkeyApplyButton
GuiControl, Hide, HotkeyCancelButton

selected_options := [1,1,1,1,1,1,1,0]
option_names := [ "NEGATIVE ATTITUDE", "VERBAL ABUSE", "LEAVING THE GAME / AFK", "INTENTIONAL FEEDING", "HATE SPEECH", "CHEATING", "OFFENSIVE OR INAPPROPRIATE NAME", "typed response: Give additional context on what happened in this game..."]
iter := 1
Loop % option_names.Length()
{   
    checkbox_vlabel := "checkbox_" iter
    checkbox_label := option_names[A_Index]
    checked_val := selected_options[A_Index]
    if (A_Index = 1)
    {
        Gui, Add, CheckBox, Checked%checked_val% xm yp+40 v%checkbox_vlabel% gFuncCheckbox, %checkbox_label%
    }
    else
    {
        Gui, Add, CheckBox, Checked%checked_val% xm yp+25 v%checkbox_vlabel% gFuncCheckbox, %checkbox_label%
    }
    iter += 1
}


my_text := "Close Script"
x := win_width -120
y := win_height -60
Gui, Add, Button, x%x% y%y%, %my_text%
return

ButtonCloseScript:
GuiClose:
    ExitApp

FuncMacroDispButton:
    GuiControl, Enable, HotkeyBox
    GuiControl, Show, HotkeyBox
    GuiControl, Show, HotkeyApplyButton
    GuiControl, Show, HotkeyCancelButton
    GuiControl, Hide, MacroDispButton
    return

FuncHotkeyApplyButton:
    GuiControlGet, HotkeyBox
    if( HotkeyBox != MyHotkey_plain && HotkeyBox != null ){
        Hotkey, %MyHotkey% , FuncHotkeyAction, Off ; Deactivate existing hotkey
        MyHotkey_plain := HotkeyBox
        MyHotkey := "~" MyHotkey_plain
		Hotkey, % MyHotkey, FuncHotkeyAction, On ; Apply new hotkey
	}
    StringUpper, button_text, MyHotkey_plain
    GuiControl, , MacroDispButton, %button_text%
    
    GuiControl, Disable, HotkeyBox
    GuiControl, Hide, HotkeyBox
    GuiControl, Hide, HotkeyApplyButton
    GuiControl, Hide, HotkeyCancelButton
    GuiControl, Show, MacroDispButton
    return

FuncHotkeyCancelButton:
    StringUpper, button_text, MyHotkey_plain
    GuiControl, , HotkeyBox, %button_text%
    GuiControl, Disable, HotkeyBox
    GuiControl, Hide, HotkeyBox
    GuiControl, Hide, HotkeyApplyButton
    GuiControl, Hide, HotkeyCancelButton
    GuiControl, Show, MacroDispButton
    return

FuncHotkeyAction:
    CoordMode, Mouse, Screen
    IfWinNotExist, League of Legends
    {
        MsgBox, "League of Legends" window not found.
        return
    }
    WinGet, hwnd, ID, League of Legends
    WinGetPos, win_x, win_y, win_width, win_height, ahk_id %hwnd%
    MouseGetPos, xpos, ypos 
    WinGetTitle, title, A ; Window over cursor
    if( title != "League of Legends" )
    {
        return
    }
    ; ToolTip, x: %xpos%`, y: %ypos%`, winx: %win_x%`, winy: %win_y%`, winheight: %win_height%
    first_checkbox_x := win_x + 440
    first_checkbox_y := win_y + 223
    checkbox_ycoords := [565, 609, 669, 714, 758, 804, 847, 897] ; collected from my screen at window height of 720px
    click_xpos := first_checkbox_x
    click_ypos := first_checkbox_y
    Loop % checkbox_ycoords.Length()
    {
        if (A_Index = 1) {
            diff := 0 
        }
        else
        {
            diff := checkbox_ycoords[A_Index] - checkbox_ycoords[A_Index - 1]
        }
        click_ypos += Floor(diff * (win_height / 720) )
        if ( selected_options[A_Index] = 1 )
        {
            Click, %click_xpos%, %click_ypos%
        }
    }
    return

FuncCheckbox:
    Gui, Submit, NoHide
    selected_options[1] := checkbox_1
    selected_options[2] := checkbox_2
    selected_options[3] := checkbox_3
    selected_options[4] := checkbox_4
    selected_options[5] := checkbox_5
    selected_options[6] := checkbox_6
    selected_options[7] := checkbox_7
    selected_options[8] := checkbox_8
    return