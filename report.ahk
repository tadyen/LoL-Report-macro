#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ;  Ensures that only one instance of the script is running at a time.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ==============================================================================================
; === FrontEnd
; ==============================================================================================

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

selected_options := [1,1,1,1,1,1,1,1,1]
option_names := [ "NEGATIVE ATTITUDE", "VERBAL ABUSE", "LEAVING THE GAME / AFK", "DISRUPTIVE GAMEPLAY", "HATE SPEECH", "RANK MANIPULATION", "CHEATING", "OFFENSIVE OR INAPPROPRIATE NAME", "typed response: Give additional context..."]
my_text := "Report Options:"
Gui, Add, Text, xm yp+40 vTextReportOptions, %my_text%
iter := 1
Loop % selected_options.Length()
{   
    checkbox_vlabel := "checkbox_" iter
    checkbox_label := option_names[A_Index]
    checked_val := selected_options[A_Index]
    Gui, Add, CheckBox, Checked%checked_val% xm yp+25 v%checkbox_vlabel% gFuncCheckbox, %checkbox_label%
    iter += 1
}

meta_selected_options := [0, 0, 0, 0]
meta_option_names := ["Get Cursor Coords only", "Auto Submit", "x10 (including yourself ) and auto-submit", "Mock submit (clicks X instead)"]
GuiControlGet, TextReportOptions, Pos
x := TextReportOptionsX + floor(win_width / 2)
y := TextReportOptionsY
my_text := "Meta Options:"
Gui, Add, Text, x%x% y%y%, %my_text%
iter := 1
Loop % meta_selected_options.Length()
{   
    x := x
    y := y + 25
    checkbox_vlabel := "meta_checkbox_" iter
    checkbox_label := meta_option_names[A_Index]
    checked_val := meta_selected_options[A_Index]
    Gui, Add, CheckBox, Checked%checked_val% x%x% y%y% v%checkbox_vlabel% gFuncCheckbox, %checkbox_label%
    iter += 1
}

; typed response textbox
GuiControlGet, checkbox_9, Pos
x := checkbox_9X
y := checkbox_9Y + 30

my_text := "Additional typed report:"
Gui, Add, Text, x%x% y%y%, %my_text%
w := win_width - 180
Gui, Font, c000000,
Gui, Add, Edit, xp yp+30 w%w% r1 vEditBox 

Gui, Font, cFFFFFF,

my_text := "Close Script"
x := win_width -105
y := win_height -45
Gui, Add, Button, x%x% y%y%, %my_text%
return

; ==============================================================================================
; === Functions
; ==============================================================================================
report_x1(selected_options, meta_selected_options)
{
    CoordMode, Mouse, Screen
    IfWinNotExist, League of Legends
    {
        MsgBox, LoL not running
        return
    }
    WinGet, hwnd, ID, League of Legends
    WinGetPos, win_x, win_y, win_width, win_height, ahk_id %hwnd%
    ; rel coords for 1280x720 interface
    first_checkbox_x := win_x + floor( 440 * win_width / 1280 )
    first_checkbox_y := win_y + floor( 203 * win_height / 720 )
    report_submit_button_x := win_x + floor( 640 * win_width / 1280 )
    report_submit_button_y := win_y + floor( 650 * win_height / 720 )
    report_cancel_x := win_x + floor( 870 * win_width / 1280 )
    report_cancel_y := win_y + floor( 65 * win_height / 720 )
    checkbox_ycoords := [408, 452, 512, 559, 602, 648, 691, 736, 788] ; abs-y coords at each report checkbox + textbox at 720px interface
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
            diff := Floor(diff * (win_height / 720) )
        }
        click_ypos += diff
        if ( selected_options[A_Index] = 1 )
        {
            Click, %click_xpos%, %click_ypos%
        }
        ; Typed response option
        if ( A_Index = 9 )
        {
            GuiControlGet, EditBox
            typed_msg := EditBox
            Send % typed_msg
        }
    }
    ; auto submit / x10 option
    if ( meta_selected_options[2] = 1 || meta_selected_options[3] = 1)
    {
        Sleep, 250 ; allow time for clicks
        if( selected_options[8] = 1 && typed_msg != "" )
        {
            Sleep, 750 ; allow more time for typed msg
        }
        ; mock click option
        if ( meta_selected_options[4] = 1 )
        {
            MouseMove, report_submit_button_x, report_submit_button_y
            Click, %report_cancel_x%, %report_cancel_y%
        }
        else
        {
            Click, %report_submit_button_x%, %report_submit_button_y%
        }
    }
    return
}

report_x10(selected_options, meta_selected_options)
{
    if ( meta_selected_options[3] != 1 )
    {
        return
    }
    CoordMode, Mouse, Screen
    IfWinNotExist, League of Legends
    {
        MsgBox, LoL not running
        return
    }
    WinGet, hwnd, ID, League of Legends
    WinGetPos, win_x, win_y, win_width, win_height, ahk_id %hwnd%
    first_report_button_x := win_x + floor( 280 * win_width / 1280 )
    first_report_button_y := win_y + floor( 175 * win_height / 720 )
    report_button_ycoords := [510, 552, 593, 637, 675, 755, 795, 835, 875, 915]
    click_xpos := first_report_button_x
    click_ypos := first_report_button_y
    Loop % 10
    {
        if (A_Index = 1) {
            diff := 0 
        }
        else
        {
            diff := report_button_ycoords[A_Index] - report_button_ycoords[A_Index - 1]
            diff := Floor(diff * (win_height / 720) )
        }
        click_ypos += diff
        ; MouseMove, %click_xpos%, %click_ypos%
        Click, %click_xpos%, %click_ypos%
        Sleep, 250 ; Allow time for the popup to render before clicks occur
        report_x1(selected_options, meta_selected_options)
    }
    return
}
; ==============================================================================================
; === Subroutines / Callbacks
; ==============================================================================================

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
        MsgBox, LoL not in focus!
        return
    }
    ; Get cursor coords only mode
    if (meta_selected_options[1] = 1)
    {
        ToolTip, x: %xpos%`, y: %ypos% `| winx: %win_x%`, winy: %win_y%` `| winw: %win_width%`, winh: %win_height%
        return
    }
    ; x10 mode
    if ( meta_selected_options[3] = 1 )
    {
        report_x10(selected_options, meta_selected_options)
    }
    else
    {
        report_x1(selected_options, meta_selected_options)
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
    selected_options[9] := checkbox_9
    meta_selected_options[1] := meta_checkbox_1
    meta_selected_options[2] := meta_checkbox_2
    meta_selected_options[3] := meta_checkbox_3
    meta_selected_options[4] := meta_checkbox_4
    return
