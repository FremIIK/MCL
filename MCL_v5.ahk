#SingleInstance, Force
#UseHook
#NoEnv
SetWorkingDir, %A_ScriptDir%
iniFile := A_ScriptDir . "\Settings.ini"
#MaxHotkeysPerInterval, 99000000
#HotkeyInterval, 99000000
#KeyHistory, 0
SendMode Input
SetKeyDelay, 50
CurrentMode := 1
global BindsEnabled := true
global LastSelectedZones := []

GuiVisible := true
ZoneTimerVisible := false
ZoneSettingsVisible := false
WarzoneSettingsVisible := false
WarzoneOverlayVisible := false
titlcolor = df005c
buildscr = 51
ZoneGUI_Created := false
ZoneSettingsGUI_Created := false
WarzoneSettingsGUI_Created := false
WarzoneOverlayGUI_Created := false

global hZoneGui := 0
global Zones_Pos := 1
global Zones_PosChoice := 1
global LastGameHwnd := 0
global BackBtn

global ZoneText1, ZoneText2, ZoneText3, ZoneText4, ZoneText5, ZoneText6, ZoneText7, ZoneText8, ZoneText9
global KeyText1, KeyText2, KeyText3, KeyText4, KeyText5, KeyText6, KeyText7, KeyText8, KeyText9
global ZoneNom := [], ZoneGen := [], ZoneAcc := [], ZoneHex := []

global ZoneMarkedForDeletion := []
global ZoneOriginalColors := []

global WZ_ID := []
global WZ_Enable := []
global WZ_BTN_MAP := {}
global WZ_Pos := 2
global WZ_PosChoice := 2

global WZ_En1 := 0
global WZ_En2 := 0
global WZ_En3 := 0
global WZ_En4 := 0
global WZ_En5 := 0
global WZ_En6 := 0
global WZ_ID1_1 := ""
global WZ_ID1_2 := ""
global WZ_ID1_3 := ""
global WZ_ID1_4 := ""
global WZ_ID2_1 := ""
global WZ_ID2_2 := ""
global WZ_ID2_3 := ""
global WZ_ID2_4 := ""
global WZ_ID3_1 := ""
global WZ_ID3_2 := ""
global WZ_ID3_3 := ""
global WZ_ID3_4 := ""
global WZ_ID4_1 := ""
global WZ_ID4_2 := ""
global WZ_ID4_3 := ""
global WZ_ID4_4 := ""
global WZ_ID5_1 := ""
global WZ_ID5_2 := ""
global WZ_ID5_3 := ""
global WZ_ID5_4 := ""
global WZ_ID6_1 := ""
global WZ_ID6_2 := ""
global WZ_ID6_3 := ""
global WZ_ID6_4 := ""

global CurrentMap := "Ghetto"
global CurrentZoneCount := 9
global ZoneGuiHeight := 290
global ZoneTitleH := 22

global EventType := 1
global SeniorMCL_time1 := ""
global SeniorMCL_time2 := ""
global SeniorMCL_zone1 := ""
global SeniorMCL_family1 := ""
global SeniorVZZ_time1 := ""
global SeniorVZZ_time2 := ""
global SeniorVZZ_time3 := ""
global SeniorVZZ_color1 := ""
global SeniorVZZ_color2 := ""
global SeniorVZZ_finalZone := ""
global SeniorVZZ_family1 := ""
global SeniorWZ_radius := ""
global SeniorWZ_time1 := ""
global SeniorWZ_time2 := ""
global SeniorWZ_map := "Ghetto"
global SeniorWZ_dimension := ""

global SeniorBackgroundImage
global Binds

global SeniorModeText, EventTypeChoice, EventTypeLabel
global BindsVilk, MCL_text1, MCL_text2, MCL_text3, MCL_text4
global MCL_copy1, MCL_copy2, MCL_copy3, MCL_copy4, BackBt
global VZZ_text1, VZZ_text2, VZZ_text3, VZZ_text4, VZZ_text5
global VZZ_copy1, VZZ_copy2, VZZ_copy3, VZZ_copy4, VZZ_copy5
global WZ_text1, WZ_text2, WZ_text3, WZ_text4, WZ_text5, WZ_text6, WZ_text7, WZ_text8, WZ_text9
global WZ_copy1, WZ_copy2, WZ_copy3, WZ_copy4, WZ_copy5, WZ_copy6, WZ_copy7, WZ_copy8, WZ_copy9

global VZZ_zonesLabel
global VZZ_zoneRed, VZZ_zoneTurquoise, VZZ_zonePink, VZZ_zoneGreen, VZZ_zoneBlue
global VZZ_zoneBrown, VZZ_zonePurple, VZZ_zoneYellow, VZZ_zoneOrange

global GlobalDeletedZonesBackup := {}
global GlobalOriginalZones := {}

SplashTextOff
ListLines, Off
Process, Priority, , A
SetMouseDelay, -1
SetDefaultMouseSpeed, 0

FixHotkey(key) {
    if (key = "")
        return key
    
    key := StrReplace(key, " ", "")
    key := StrReplace(key, "Ctrl", "^")
    key := StrReplace(key, "Alt", "!")
    key := StrReplace(key, "Shift", "+")
    key := StrReplace(key, "Win", "#")
    
    if (RegExMatch(key, "[\^\!\#]\+[a-zA-Zа-яА-ЯёЁ]$")) {
        key := RegExReplace(key, "\+([a-zA-Zа-яА-ЯёЁ])$", "$1")
    }
    
    return key
}

ReadableKey(key) {
    key := StrReplace(key, "^", "Ctrl + ")
    key := StrReplace(key, "!", "Alt + ")
    key := StrReplace(key, "#", "Win + ")
    return key
}

StripProgressEdges(hwnd) {
    if (!hwnd)
        return
    DllCall("uxtheme\SetWindowTheme", "ptr", hwnd, "wstr", "", "wstr", "")
    GetWL := (A_PtrSize = 8) ? "GetWindowLongPtr" : "GetWindowLong"
    SetWL := (A_PtrSize = 8) ? "SetWindowLongPtr" : "SetWindowLong"
    style := DllCall(GetWL, "ptr", hwnd, "int", -16, "ptr")
    ex    := DllCall(GetWL, "ptr", hwnd, "int", -20, "ptr")
    style := style & ~0x00800000
    ex    := ex    & ~0x00000200 & ~0x00020000
    DllCall(SetWL, "ptr", hwnd, "int", -16, "ptr", style, "ptr")
    DllCall(SetWL, "ptr", hwnd, "int", -20, "ptr", ex,    "ptr")
    DllCall("SetWindowPos", "ptr", hwnd, "ptr", 0, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x37)
}

ForceGuiRedraw(hwnd) {
    if (!hwnd)
        return
    DllCall("RedrawWindow", "ptr", hwnd, "ptr", 0, "ptr", 0, "uint", 0x85)
}

SetDarkTitleBar(hwnd) {
    if (A_OSVersion >= "10.0") {
        DWMWA_USE_IMMERSIVE_DARK_MODE := 19
        DWMWA_CAPTION_COLOR := 35
        DWMWA_TEXT_COLOR := 36
        
        value := 1
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_USE_IMMERSIVE_DARK_MODE, "int*", value, "int", 4)
        
        color := 0x1e1e1e
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_CAPTION_COLOR, "int*", color, "int", 4)
        
        textColor := 0xFFFFFF
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_TEXT_COLOR, "int*", textColor, "int", 4)
    }
}

icon_img = %A_ScriptDir%\img\icon.png
IfExist, %icon_img%
    Menu, Tray, Icon, %icon_img%

Menu, Tray, add, Показать, Show,
Menu, Tray, Default, Показать,
Menu, Tray, add, Перезагрузить, Reload,
Menu, Tray, add, Скрыть, Hide,
Menu, Tray, add, Закрыть, Close,
Menu, Tray, NoStandard

global ZoneTimeRemaining1 := 300
global ZoneTimeRemaining2 := 300
global ZoneTimeRemaining3 := 300
global ZoneTimeRemaining4 := 300
global ZoneTimeRemaining5 := 300
global ZoneTimeRemaining6 := 300
global ZoneTimeRemaining7 := 300
global ZoneTimeRemaining8 := 300
global ZoneTimeRemaining9 := 300
global dimension

global VZZ_undoBtn, VZZ_resetBtn
global GlobalDeletedZones := {}
global GlobalDeletedZonesBackup := {}

IniRead, Radio1, Settings.ini, Settings, /hidecheatinfo
IniRead, Radio2, Settings.ini, Settings, /waypoints_toggle
IniRead, Radio3, Settings.ini, Settings, /gm
IniRead, Radio4, Settings.ini, Settings, /esp 3
IniRead, Radio5, Settings.ini, Settings, /subs_to_map_sync 1
IniRead, Radio6, Settings.ini, Settings, /frange 2000 familyID
IniRead, Radio7, Settings.ini, Settings, /tempfamily
IniRead, Radio8, Settings.ini, Settings, /zzoff 

IniRead, BindsEnabledINI, Settings.ini, Settings, BindsEnabled, 1
BindsEnabled := (BindsEnabledINI = 1)

IniRead, Mode, Settings.ini, Zones, MODE, ERROR
if (Mode = "ERROR") {
    IniRead, __legacyModeVal, Settings.ini, radiusm, radius, 100
    Mode := (__legacyModeVal = 150) ? 2 : 1
    IniWrite, %Mode%, Settings.ini, Zones, MODE
}

IniRead, keyZoneReset, Settings.ini, KeySetup, KEY_ZONE_RESET, ^r
IniRead, Zones_X, Settings.ini, Windows, Zones_X, 200
IniRead, Zones_Y, Settings.ini, Windows, Zones_Y, 200
IniRead, Zones_Pos, Settings.ini, Windows, Zones_Pos, 1
if (Zones_Pos < 1 || Zones_Pos > 6)
    Zones_Pos := 1

LoadWarzoneSettings()

IniRead, CurrentMap, Settings.ini, Zones, Map, Ghetto
EnsureValidCurrentMapForMode()
IniWrite, %CurrentMap%, Settings.ini, Zones, Map

IniRead, keyTimingZone, Settings.ini, KeySetup, TIMINGZONE
keyTimingZone := FixHotkey(keyTimingZone)

IniRead, key1, Settings.ini, KeySetup, KEY1
IniRead, key2, Settings.ini, KeySetup, KEY2
IniRead, key3, Settings.ini, KeySetup, KEY3
IniRead, key4, Settings.ini, KeySetup, KEY4
IniRead, key5, Settings.ini, KeySetup, KEY5
IniRead, key6, Settings.ini, KeySetup, KEY6
IniRead, key7, Settings.ini, KeySetup, KEY7
IniRead, key8, Settings.ini, KeySetup, KEY8
IniRead, key9, Settings.ini, KeySetup, KEY9
IniRead, key10, Settings.ini, KeySetup, KEY10
IniRead, key11, Settings.ini, KeySetup, KEY11
IniRead, key12, Settings.ini, KeySetup, KEY12
IniRead, key14, Settings.ini, KeySetup, KEY14
IniRead, famid, Settings.ini, IDFamily, famid
IniRead, radius, Settings.ini, radiusm, radius
IniRead, qx2, Settings.ini, Coords, qx2
IniRead, qy2, Settings.ini, Coords, qy2
IniRead, dimension, Settings.ini, Coords, dimension
IniRead, dim4, Settings.ini, SeniorWZ, dimension

IniRead, ZoneKey1, Settings.ini, ZoneKeys, KEY_ZONE1, ^1
IniRead, ZoneKey2, Settings.ini, ZoneKeys, KEY_ZONE2, ^2
IniRead, ZoneKey3, Settings.ini, ZoneKeys, KEY_ZONE3, ^3
IniRead, ZoneKey4, Settings.ini, ZoneKeys, KEY_ZONE4, ^4
IniRead, ZoneKey5, Settings.ini, ZoneKeys, KEY_ZONE5, ^5
IniRead, ZoneKey6, Settings.ini, ZoneKeys, KEY_ZONE6, ^6
IniRead, ZoneKey7, Settings.ini, ZoneKeys, KEY_ZONE7, ^7
IniRead, ZoneKey8, Settings.ini, ZoneKeys, KEY_ZONE8, ^8
IniRead, ZoneKey9, Settings.ini, ZoneKeys, KEY_ZONE9, ^9

ZoneKey1 := FixHotkey(ZoneKey1)
ZoneKey2 := FixHotkey(ZoneKey2)
ZoneKey3 := FixHotkey(ZoneKey3)
ZoneKey4 := FixHotkey(ZoneKey4)
ZoneKey5 := FixHotkey(ZoneKey5)
ZoneKey6 := FixHotkey(ZoneKey6)
ZoneKey7 := FixHotkey(ZoneKey7)
ZoneKey8 := FixHotkey(ZoneKey8)
ZoneKey9 := FixHotkey(ZoneKey9)

Hotkey, %keyZoneReset%, Off, UseErrorLevel
Hotkey, %keyZoneReset%, ResetAllZones, On, UseErrorLevel

Hotkey, %KEY1%, Off, UseErrorLevel
Hotkey, %KEY1%, startfamtimer, On, UseErrorLevel
Hotkey, %KEY2%, Off, UseErrorLevel
Hotkey, %KEY2%, listfamtimers, On, UseErrorLevel
Hotkey, %KEY3%, Off, UseErrorLevel
Hotkey, %KEY3%, stopfamtimer, On, UseErrorLevel
Hotkey, %KEY4%, Off, UseErrorLevel
Hotkey, %KEY4%, continuefamtimer, On, UseErrorLevel
Hotkey, %KEY5%, Off, UseErrorLevel
Hotkey, %KEY5%, deletefamtimer, On, UseErrorLevel
Hotkey, %KEY6%, Off, UseErrorLevel
Hotkey, %KEY6%, feventon, On, UseErrorLevel
Hotkey, %KEY7%, Off, UseErrorLevel
Hotkey, %KEY7%, setdim, On, UseErrorLevel
Hotkey, %KEY8%, Off, UseErrorLevel
Hotkey, %KEY8%, rsetdim, On, UseErrorLevel
Hotkey, %KEY9%, Off, UseErrorLevel
Hotkey, %KEY9%, zonastart, On, UseErrorLevel
Hotkey, %KEY10%, Off, UseErrorLevel
Hotkey, %KEY10%, zonaend, On, UseErrorLevel
Hotkey, %KEY11%, Off, UseErrorLevel
Hotkey, %KEY11%, ZoneSettings, On, UseErrorLevel
Hotkey, %KEY14%, Off, UseErrorLevel
Hotkey, %KEY14%, vhod, On, UseErrorLevel

Hotkey, %keyTimingZone%, Off, UseErrorLevel
Hotkey, %keyTimingZone%, TimingZoneSend, On, UseErrorLevel

SetupZoneHotkeys()
LoadSeniorSettings()

Gui, 2: Font, s9 cWhite Norm, Segoe UI Variable
Gui, 2: Add, Picture, x0 y0 w495 h400 BackgroundTrans vBackgroundImage, %A_ScriptDir%\img\background.png

Gui, 2: -MaximizeBox
Gui, 2: Color, +1e1e1e
Gui, 2: Font, s9, Segoe UI Variable
Gui, 2: Font, cWhite

Gui, 2: Add, Picture, x7 y9 w80 h41 BackgroundTrans gTeleports, %A_ScriptDir%\img\tp.png
Gui, 2: Add, Picture, x7 y60 w80 h41 BackgroundTrans gInfo, %A_ScriptDir%\img\bind.png
Gui, 2: Add, Picture, x7 y363 w80 h30 gSaveID, %A_ScriptDir%\img\save.png
Gui, 2: Add, Picture, x339 y352 w150 h41 gSaveOption, %A_ScriptDir%\img\saveglobal.png

Gui, 2: Add, Edit, x7 y339 w80 h21 +Number vfamid cblack, %famid%
Gui, 2: Add, Text, x7 y320 +0x200 BackgroundTrans, ID семьи:

Gui, 2: Add, Picture, x100 y9 w184 h27 BackgroundTrans, %A_ScriptDir%\img\bindinfo.png
Gui, 2: Add, Picture, x305 y9 w184 h27 BackgroundTrans, %A_ScriptDir%\img\auto.png 

Gui, 2: Add, DropDownList, x235 y50 w45 h100 vMode gUpdateMode AltSubmit cblack, ВЗЗ|MCL
if (Mode = 1)
    GuiControl, 2: Choose, Mode, 1
else
    GuiControl, 2: Choose, Mode, 2

Gui, 2: Add, Hotkey, x110 y50 w48 h21 vHot1, %KEY1%
Gui, 2: Add, Hotkey, x110 y76 w48 h21 vHot2, %KEY2%
Gui, 2: Add, Hotkey, x110 y102 w48 h21 vHot3, %KEY3%
Gui, 2: Add, Hotkey, x110 y128 w48 h21 vHot4, %KEY4%
Gui, 2: Add, Hotkey, x110 y154 w48 h21 vHot5, %KEY5%
Gui, 2: Add, Hotkey, x110 y180 w48 h21 vHot6, %KEY6%
Gui, 2: Add, Hotkey, x110 y206 w48 h21 vHot7, %KEY7% 
Gui, 2: Add, Hotkey, x110 y232 w48 h21 vHot8, %KEY8% 
Gui, 2: Add, Hotkey, x354 y258 w45 h21 vHot14, %KEY14%
Gui, 2: Add, Hotkey, x110 y284 w48 h21 vTimingZone, %keyTimingZone%
Gui, 2: Add, Hotkey, x110 y258 w48 h21 vHotZoneReset, %keyZoneReset%

Gui, 2: Add, Text, x163 y53 w60 h14 +0x200 BackgroundTrans, /startfamtimer
Gui, 2: Add, Text, x163 y79 w120 h14 +0x200 BackgroundTrans, /listfamtimers
Gui, 2: Add, Text, x163 y105 w120 h14 +0x200 BackgroundTrans, /stopfamtimer
Gui, 2: Add, Text, x163 y131 w120 h14 +0x200 BackgroundTrans, /continuefamtimer
Gui, 2: Add, Text, x163 y157 w120 h14 +0x200 BackgroundTrans, /deletefamtimer
Gui, 2: Add, Text, x163 y183 w120 h14 +0x200 BackgroundTrans, /clearallfamtimer 
Gui, 2: Add, Text, x163 y209 w120 h14 +0x200 BackgroundTrans, /setdim
Gui, 2: Add, Text, x163 y235 w120 h14 +0x200 BackgroundTrans, /rsetdim 10
Gui, 2: Add, Text, x402 y263 w140 h14 +0x200 BackgroundTrans, Вход
Gui, 2: Add, Text, x163 y262 w120 h14 +0x200 BackgroundTrans, Сброс всех зон
Gui, 2: Add, Text, x163 y287 w180 h14 +0x200 BackgroundTrans, Тайминг зон / Удалённые зоны

Gui, 2: Add, CheckBox, x354 y50 w13 h13 vRadio1 Checked%Radio1% 
Gui, 2: Add, CheckBox, x354 y76 w13 h13 vRadio2 Checked%Radio2% 
Gui, 2: Add, CheckBox, x354 y102 w13 h13 vRadio3 Checked%Radio3% 
Gui, 2: Add, CheckBox, x354 y128 w13 h13 vRadio4 Checked%Radio4% 
Gui, 2: Add, CheckBox, x354 y154 w13 h13 vRadio5 Checked%Radio5% 
Gui, 2: Add, CheckBox, x354 y180 w13 h13 vRadio6 Checked%Radio6% 
Gui, 2: Add, CheckBox, x354 y206 w13 h13 vRadio7 Checked%Radio7% 
Gui, 2: Add, CheckBox, x354 y232 w13 h13 vRadio8 Checked%Radio8% 

Gui, 2: Add, Text, x370 y51 w120 h14 BackgroundTrans, Читы
Gui, 2: Add, Text, x370 y77 w120 h14 BackgroundTrans, Метраж(метка)
Gui, 2: Add, Text, x370 y103 w120 h14 BackgroundTrans, /gm
Gui, 2: Add, Text, x370 y129 w120 h14 BackgroundTrans, /esp 3
Gui, 2: Add, Text, x370 y155 w135 h14 BackgroundTrans, Метки
Gui, 2: Add, Text, x370 y181 w140 h14 BackgroundTrans, /frange
Gui, 2: Add, Text, x370 y207 w140 h14 BackgroundTrans, /tempfamily 
Gui, 2: Add, Text, x370 y233 w140 h14 BackgroundTrans, /zzoff

Gui, 2: Add, Picture, x110 y311 w115 h25 BackgroundTrans gZoneSettings vBtnZoneSettings, %A_ScriptDir%\img\settings_zone.png
Gui, 2: Add, Picture, x228 y311 w57 h25 BackgroundTrans gZone vBtnZone, %A_ScriptDir%\img\zons.png
Gui, 2: Add, Picture, x110 y339 w115 h25 BackgroundTrans gWarzoneSettings vBtnWarzoneSettings, %A_ScriptDir%\img\settings_warzone.png
Gui, 2: Add, Picture, x228 y339 w57 h25 BackgroundTrans gWarzone vBtnWarzone, %A_ScriptDir%\img\warzone.png
Gui, 2: Add, Picture, x110 y367 w175 h25 BackgroundTrans gSwitchMode vBtnSwitchMode, %A_ScriptDir%\img\senior_organizer.png

CreateSeniorElements()
HideAllSeniorElements()
Gui, 2: Show, w495 h400, MCL Binder
Gui, 2: Font, s9 cWhite Norm, Segoe UI Variable

WinGet, hMainWnd, ID, MCL Binder
SetDarkTitleBar(hMainWnd)

ToggleAllHotkeys(BindsEnabled)
return

LoadSeniorSettings() {
    global EventType, SeniorMCL_time1, SeniorMCL_time2, SeniorMCL_zone1, SeniorMCL_family1
    global SeniorVZZ_time1, SeniorVZZ_time2, SeniorVZZ_time3, SeniorVZZ_color1, SeniorVZZ_color2
    global SeniorVZZ_finalZone, SeniorVZZ_family1
    global SeniorWZ_radius, SeniorWZ_time1, SeniorWZ_time2, SeniorWZ_map, SeniorWZ_dimension
    
    IniRead, EventType, Settings.ini, SeniorMode, EventType, 1
    
    IniRead, SeniorMCL_time1, Settings.ini, SeniorMCL, time1, 19.00
    IniRead, SeniorMCL_time2, Settings.ini, SeniorMCL, time2, 19.00
    IniRead, SeniorMCL_zone1, Settings.ini, SeniorMCL, zone1, Розовая
    IniRead, SeniorMCL_family1, Settings.ini, SeniorMCL, family1, Cursed
    
    IniRead, SeniorVZZ_time1, Settings.ini, SeniorVZZ, time1, 19.00
    IniRead, SeniorVZZ_time2, Settings.ini, SeniorVZZ, time2, 19.00
    IniRead, SeniorVZZ_time3, Settings.ini, SeniorVZZ, time3, 19.00
    IniRead, SeniorVZZ_color1, Settings.ini, SeniorVZZ, color1, Розовая
    IniRead, SeniorVZZ_color2, Settings.ini, SeniorVZZ, color2, 
    IniRead, SeniorVZZ_finalZone, Settings.ini, SeniorVZZ, finalZone, Розовая
    IniRead, SeniorVZZ_family1, Settings.ini, SeniorVZZ, family1, Cursed
    
    IniRead, SeniorWZ_radius, Settings.ini, SeniorWZ, radius, 100
    IniRead, SeniorWZ_time1, Settings.ini, SeniorWZ, time1, 19.00
    IniRead, SeniorWZ_time2, Settings.ini, SeniorWZ, time2, 19.00
    IniRead, SeniorWZ_map, Settings.ini, SeniorWZ, map, Ghetto
    IniRead, SeniorWZ_dimension, Settings.ini, SeniorWZ, dimension, 100
    
    if (!IsObject(GlobalDeletedZones)) {
        GlobalDeletedZones := {}
    }
    if (!IsObject(GlobalDeletedZonesBackup)) {
        GlobalDeletedZonesBackup := {}
    }
    if (!IsObject(GlobalOriginalZones)) {
        GlobalOriginalZones := {}
    }
}

SaveOriginalZonesState() {
    global GlobalOriginalZones, SeniorVZZ_color1, SeniorVZZ_color2, SeniorVZZ_finalZone
    
    Gui, 2: Submit, NoHide
    
    GlobalOriginalZones := {}
    GlobalOriginalZones.color1 := SeniorVZZ_color1
    GlobalOriginalZones.color2 := SeniorVZZ_color2
    GlobalOriginalZones.finalZone := SeniorVZZ_finalZone
}

VZZUndoDeletion:
    global GlobalDeletedZones, GlobalDeletedZonesBackup
    
    if (IsObject(GlobalDeletedZonesBackup)) {
        GlobalDeletedZones := CloneObject(GlobalDeletedZonesBackup)
        AutoCheckZoneBoxes(GlobalDeletedZones)
        UpdateZoneDropdowns()
    }
return

VZZResetZones:
    global GlobalDeletedZones, GlobalDeletedZonesBackup, GlobalOriginalZones
    
    if (IsObject(GlobalDeletedZones)) {
        GlobalDeletedZonesBackup := CloneObject(GlobalDeletedZones)
    }
    
    GlobalDeletedZones := {}
    
    if (IsObject(GlobalOriginalZones) && GlobalOriginalZones.Count() > 0) {
        GuiControl, 2: ChooseString, SeniorVZZ_color1, % GlobalOriginalZones.color1
        GuiControl, 2: ChooseString, SeniorVZZ_color2, % GlobalOriginalZones.color2
        GuiControl, 2: ChooseString, SeniorVZZ_finalZone, % GlobalOriginalZones.finalZone
    } else {
        GuiControl, 2: Choose, SeniorVZZ_color1, 1
        GuiControl, 2: Choose, SeniorVZZ_color2, 1
        GuiControl, 2: Choose, SeniorVZZ_finalZone, 1
    }
    
    AutoCheckZoneBoxes(GlobalDeletedZones)
    UpdateZoneDropdowns()
return

CloneObject(obj) {
    newObj := {}
    for key, value in obj {
        newObj[key] := value
    }
    return newObj
}

SaveSeniorSettings() {
    global EventType, SeniorMCL_time1, SeniorMCL_time2, SeniorMCL_zone1, SeniorMCL_family1
    global SeniorVZZ_time1, SeniorVZZ_time2, SeniorVZZ_time3, SeniorVZZ_color1, SeniorVZZ_color2
    global SeniorVZZ_finalZone, SeniorVZZ_family1
    global SeniorWZ_radius, SeniorWZ_time1, SeniorWZ_time2, SeniorWZ_map, SeniorWZ_dimension
    
    Gui, 2: Submit, NoHide
    
    IniWrite, %EventType%, Settings.ini, SeniorMode, EventType
    
    IniWrite, %SeniorMCL_time1%, Settings.ini, SeniorMCL, time1
    IniWrite, %SeniorMCL_time2%, Settings.ini, SeniorMCL, time2
    IniWrite, %SeniorMCL_zone1%, Settings.ini, SeniorMCL, zone1
    IniWrite, %SeniorMCL_family1%, Settings.ini, SeniorMCL, family1
    
    IniWrite, %SeniorVZZ_time1%, Settings.ini, SeniorVZZ, time1
    IniWrite, %SeniorVZZ_time2%, Settings.ini, SeniorVZZ, time2
    IniWrite, %SeniorVZZ_time3%, Settings.ini, SeniorVZZ, time3
    IniWrite, %SeniorVZZ_color1%, Settings.ini, SeniorVZZ, color1
    IniWrite, %SeniorVZZ_color2%, Settings.ini, SeniorVZZ, color2
    IniWrite, %SeniorVZZ_finalZone%, Settings.ini, SeniorVZZ, finalZone
    IniWrite, %SeniorVZZ_family1%, Settings.ini, SeniorVZZ, family1
    
    IniWrite, %SeniorWZ_radius%, Settings.ini, SeniorWZ, radius
    IniWrite, %SeniorWZ_time1%, Settings.ini, SeniorWZ, time1
    IniWrite, %SeniorWZ_time2%, Settings.ini, SeniorWZ, time2
    IniWrite, %SeniorWZ_map%, Settings.ini, SeniorWZ, map
    IniWrite, %SeniorWZ_dimension%, Settings.ini, SeniorWZ, dimension
}

CreateSeniorElements() {
    initialCheckState := BindsEnabled ? 0 : 1
	Gui, 2: Add, Picture, x0 y0 w495 h400 vSeniorBackgroundImage Hidden 0x4, %A_ScriptDir%\img\background2.png
	Gui, 2: Add, Picture, x70 y10 w100 h20 vBinds Hidden +BackgroundTrans, %A_ScriptDir%\img\binds.png
    Gui, 2: Add, Text, x20 y50 w400 h20 vMCL_text1 Hidden +BackgroundTrans, [MCL] Перенос начала на 5 минут. Старт в time.
    Gui, 2: Add, Edit, x260 y47 w50 h20 vSeniorMCL_time1 cBlack gSaveSeniorSettings Hidden, %SeniorMCL_time1%
    Gui, 2: Add, Picture, x315 y47 w50 h20 vMCL_copy1 gCopyMCL1 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, CheckBox, x55 y14 w13 h13 vDisableBindsCheckbox +BackgroundTrans Hidden gToggleBinds AltSubmit Checked%initialCheckState%
    
    Gui, 2: Font, s10 +c008dac Bold, Segoe UI Variable
    Gui, 2: Add, Text, x175 y11 w200 h20 +BackgroundTrans vSeniorModeText Hidden, Senior Organizer
    Gui, 2: Font, s9 cWhite Norm, Segoe UI Variable
    Gui, 2: Add, Text, x310 y13 w75 h20 +BackgroundTrans vEventTypeLabel Hidden, Мероприятие:
    Gui, 2: Add, DropDownList, x385 y9 w70 BackgroundTrans vEventTypeChoice Hidden gEventTypeChanged AltSubmit cBlack, MCL|ВЗЗ|Warzone
    Gui, 2: Add, Picture, x10 y10 w40 h20 vBackBtn gBackToMain Hidden BackgroundTrans, %A_ScriptDir%\img\backspace.png
    
    Gui, 2: Add, Text, x15 y80 w388 h60 vMCL_text2 Hidden Center +BackgroundTrans, [MCL] Уважаемые игроки, Majestic Cyber League для семей начался. Можете заходить на территорию проведения мероприятия. Желаем удачи всем участникам!
    Gui, 2: Add, Picture, x400 y91 w50 h20 vMCL_copy2 gCopyMCL2 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y140 w372 h80 vMCL_text3 Hidden Center +BackgroundTrans, [MCL] Участники мероприятия должны до time занять зону, отмеченную на карте color цветом и удерживать ее. Последняя семья, которая останется в ней, станет победителем. В случае отсутствия семьи в зоне в указанное время она дисквалифицируется.
    Gui, 2: Add, Edit, x400 y135 w50 h20 vSeniorMCL_time2 cBlack gSaveSeniorSettings Hidden, %SeniorMCL_time2%
    Gui, 2: Add, DropDownList, x400 y160 w90 h180 vSeniorMCL_zone1 cBlack gSaveSeniorSettings Hidden, Красная|Бирюзовая|Розовая|Зеленая|Синяя|Коричневая|Фиолетовая|Желтая|Оранжевая
    GuiControl, 2: ChooseString, SeniorMCL_zone1, %SeniorMCL_zone1%
    Gui, 2: Add, Picture, x400 y188 w50 h20 vMCL_copy3 gCopyMCL3 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y230 w372 h40 vMCL_text4 Hidden Center +BackgroundTrans, [MCL] Победителем семейного турнира Majestic Cyber League становится семья family! Они получают 1.000.000$. Спасибо всех за участие.
    Gui, 2: Add, Edit, x400 y229 w50 h20 vSeniorMCL_family1 cBlack gSaveSeniorSettings Hidden, %SeniorMCL_family1%
    Gui, 2: Add, Picture, x400 y254 w50 h20 vMCL_copy4 gCopyMCL4 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y50 w400 h20 vVZZ_text1 Hidden +BackgroundTrans, [ВЗЗ] Перенос начала на 5 минут. Старт в time.
    Gui, 2: Add, Edit, x260 y47 w50 h20 vSeniorVZZ_time1 cBlack gSaveSeniorSettings Hidden, %SeniorVZZ_time1%
    Gui, 2: Add, Picture, x315 y47 w50 h20 vVZZ_copy1 gCopyVZZ1 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y80 w372 h60 vVZZ_text2 Hidden Center +BackgroundTrans, [ВЗЗ] - Телепорт на мероприятие "Война за зоны" окончен. У семей есть 5 минут для захода в зону проведения мероприятия, иначе они будут дисквалифицированы.
    Gui, 2: Add, Picture, x385 y90 w50 h20 vVZZ_copy2 gCopyVZZ2 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y140 w411 h40 vVZZ_text3 Hidden Center +BackgroundTrans, [ВЗЗ] - color1 и color2 зоны будут удалены. Семьи должны покинуть удаленную зону до time. Удаленные зоны - colors.
    Gui, 2: Add, DropDownList, x70 y170 w90 h180 vSeniorVZZ_color1 cBlack gSaveSeniorSettings Hidden, Красная|Бирюзовая|Розовая|Зеленая|Синяя|Коричневая|Фиолетовая|Желтая|Оранжевая
    GuiControl, 2: ChooseString, SeniorVZZ_color1, %SeniorVZZ_color1%
    Gui, 2: Add, DropDownList, x170 y170 w90 h180 vSeniorVZZ_color2 cBlack gSaveSeniorSettings Hidden, |Красная|Бирюзовая|Розовая|Зеленая|Синяя|Коричневая|Фиолетовая|Желтая|Оранжевая
    GuiControl, 2: ChooseString, SeniorVZZ_color2, %SeniorVZZ_color2%
    Gui, 2: Add, Edit, x270 y170 w50 h21 vSeniorVZZ_time2 cBlack gSaveSeniorSettings Hidden, %SeniorVZZ_time2%
    Gui, 2: Add, Picture, x330 y170 w50 h21 vVZZ_copy3 gCopyVZZ3 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Button, x390 y170 w15 h15 vVZZ_undoBtn gVZZUndoDeletion Hidden, ↶
    Gui, 2: Add, Button, x410 y170 w15 h15 vVZZ_resetBtn gVZZResetZones Hidden, ↻
    
    Gui, 2: Add, Text, x20 y200 w120 h20 vVZZ_zonesLabel Hidden +BackgroundTrans, Удаленные зоны:
    Gui, 2: Font, cFF0000
    Gui, 2: Add, Text, x120 y200 w65 h20 vVZZ_zoneRed Hidden +BackgroundTrans, Красная
    Gui, 2: Font, c00CCCC
    Gui, 2: Add, Text, x190 y200 w79 h20 vVZZ_zoneTurquoise Hidden +BackgroundTrans, Бирюзовая
    Gui, 2: Font, cFF66CC
    Gui, 2: Add, Text, x274 y200 w65 h20 vVZZ_zonePink Hidden +BackgroundTrans, Розовая
    Gui, 2: Font, c00CC00
    Gui, 2: Add, Text, x344 y200 w65 h20 vVZZ_zoneGreen Hidden +BackgroundTrans, Зеленая
    Gui, 2: Font, c2929FF
    Gui, 2: Add, Text, x414 y200 w65 h20 vVZZ_zoneBlue Hidden +BackgroundTrans, Синяя
    Gui, 2: Font, c996633
    Gui, 2: Add, Text, x130 y220 w83 h20 vVZZ_zoneBrown Hidden +BackgroundTrans, Коричневая
    Gui, 2: Font, c9900FF
    Gui, 2: Add, Text, x218 y220 w85 h20 vVZZ_zonePurple Hidden +BackgroundTrans, Фиолетовая
    Gui, 2: Font, cFFFF00
    Gui, 2: Add, Text, x308 y220 w65 h20 vVZZ_zoneYellow Hidden +BackgroundTrans, Желтая
    Gui, 2: Font, cFF9900
    Gui, 2: Add, Text, x375 y220 w78 h20 vVZZ_zoneOrange Hidden +BackgroundTrans, Оранжевая
    Gui, 2: Font, cFFFFFF
    
    Gui, 2: Add, Text, x20 y255 w395 h60 vVZZ_text4 Hidden Center +BackgroundTrans, [ВЗЗ] Финальная зона - color. Семьи должны занять ее до time и удерживать ее. Последняя семья, которая останется в ней, станет победителем. В случае отсутствия семьи в зоне в указанное время она дисквалифицируется.
    Gui, 2: Add, DropDownList, x100 y310 w90 h180 vSeniorVZZ_finalZone cBlack gSaveSeniorSettings Hidden, Красная|Бирюзовая|Розовая|Зеленая|Синяя|Коричневая|Фиолетовая|Желтая|Оранжевая
    GuiControl, 2: ChooseString, SeniorVZZ_finalZone, %SeniorVZZ_finalZone%
    Gui, 2: Add, Edit, x200 y310 w50 h21 vSeniorVZZ_time3 cBlack gSaveSeniorSettings Hidden, %SeniorVZZ_time3%
    Gui, 2: Add, Picture, x260 y310 w50 h21 vVZZ_copy4 gCopyVZZ4 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x15 y351 w400 h40 vVZZ_text5 Hidden Center +BackgroundTrans, [ВЗЗ] Победителем семейного турнира Война за Зоны становится семья family! Они получают 1.000.000$. Спасибо всем за участие.
    Gui, 2: Add, Edit, x410 y341 w50 h20 vSeniorVZZ_family1 cBlack gSaveSeniorSettings Hidden, %SeniorVZZ_family1%
    Gui, 2: Add, Picture, x410 y366 w50 h20 vVZZ_copy5 gCopyVZZ5 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y50 w100 h20 vWZ_text1 Hidden +BackgroundTrans, Платформа
    Gui, 2: Add, Picture, x80 y48 w50 h20 vWZ_copy1 gCopyWZ1 Hidden BackgroundTrans +BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x150 y50 w100 h20 vWZ_text2 Hidden +BackgroundTrans, Парашюты
    Gui, 2: Add, Picture, x206 y48 w50 h20 vWZ_copy2 gCopyWZ2 Hidden BackgroundTrans +BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x280 y50 w80 h20 vWZ_text3 Hidden +BackgroundTrans, Дименшен
    Gui, 2: Add, Edit, x336 y48 w30 h20 vSeniorWZ_dimension cBlack gSaveSeniorSettings Hidden +BackgroundTrans, %SeniorWZ_dimension%
    
    Gui, 2: Add, Text, x20 y80 w80 h20 vWZ_text4 Hidden +BackgroundTrans, Карта Warzone
    Gui, 2: Add, DropDownList, x100 y76 w85 h200 vSeniorWZ_map cBlack gSaveSeniorSettings Hidden, Ghetto|Mirror|City|Vinewood 1|Vinewood 2|Industrial|RedWood|WindMill|Vespucci
    GuiControl, 2: ChooseString, SeniorWZ_map, %SeniorWZ_map%
    Gui, 2: Add, Picture, x190 y78 w50 h19 vWZ_copy4 gCopyWZ4 Hidden BackgroundTrans BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x280 y80 w26 h20 vWZ_text5 Hidden +BackgroundTrans, Zone
    Gui, 2: Add, Edit, x310 y78 w30 h20 vSeniorWZ_radius cBlack gSaveSeniorSettings Hidden, %SeniorWZ_radius%
    Gui, 2: Add, Picture, x345 y78 w50 h20 vWZ_copy5 gCopyWZ5 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y120 w400 h20 vWZ_text6 Hidden +BackgroundTrans, [Majestic Warzone] Перенос начала на 5 минут. Старт в time.
    Gui, 2: Add, Edit, x330 y117 w50 h20 vSeniorWZ_time1 cBlack gSaveSeniorSettings Hidden, %SeniorWZ_time1%
    Gui, 2: Add, Picture, x385 y117 w50 h20 vWZ_copy6 gCopyWZ6 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y160 w400 h20 vWZ_text7 Hidden +BackgroundTrans, [Majestic Warzone] Мероприятие началось. Желаем всем удачи!
    Gui, 2: Add, Picture, x350 y157 w50 h20 vWZ_copy7 gCopyWZ7 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x15 y200 w395 h40 vWZ_text8 Hidden Center +BackgroundTrans, [Majestic Warzone] Зона уменьшается. Команды должны покинуть внешний крут до time и занять новую зону.
    Gui, 2: Add, Edit, x410 y185 w50 h20 vSeniorWZ_time2 cBlack gSaveSeniorSettings Hidden, %SeniorWZ_time2%
    Gui, 2: Add, Picture, x410 y209 w50 h20 vWZ_copy8 gCopyWZ8 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
    
    Gui, 2: Add, Text, x20 y255 w400 h40 vWZ_text9 Hidden +BackgroundTrans, [Majestic Warzone] Мероприятие закончилось, итоги можете узнать в официальном дискорде Majestic Cyber League. Спасибо всем за участие!
    Gui, 2: Add, Picture, x395 y261 w50 h20 vWZ_copy9 gCopyWZ9 Hidden BackgroundTrans, %A_ScriptDir%\img\Copy.png
}

HideAllSeniorElements() {
    GuiControl, 2: Hide, SeniorModeText
    GuiControl, 2: Hide, EventTypeLabel
    GuiControl, 2: Hide, EventTypeChoice
    
    Loop, 4 {
        GuiControl, 2: Hide, MCL_text%A_Index%
        GuiControl, 2: Hide, MCL_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorMCL_time1
    GuiControl, 2: Hide, SeniorMCL_time2
    GuiControl, 2: Hide, SeniorMCL_zone1
    GuiControl, 2: Hide, SeniorMCL_family1
	GuiControl, 2: Hide, BindsVilk
    
    Loop, 5 {
        GuiControl, 2: Hide, VZZ_text%A_Index%
        GuiControl, 2: Hide, VZZ_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorVZZ_time1
    GuiControl, 2: Hide, SeniorVZZ_time2
    GuiControl, 2: Hide, SeniorVZZ_time3
    GuiControl, 2: Hide, SeniorVZZ_color1
    GuiControl, 2: Hide, SeniorVZZ_color2
    GuiControl, 2: Hide, SeniorVZZ_finalZone
    GuiControl, 2: Hide, SeniorVZZ_family1
    GuiControl, 2: Hide, VZZ_zonesLabel
    GuiControl, 2: Hide, VZZ_zoneRed
    GuiControl, 2: Hide, VZZ_zoneTurquoise
    GuiControl, 2: Hide, VZZ_zonePink
    GuiControl, 2: Hide, VZZ_zoneGreen
    GuiControl, 2: Hide, VZZ_zoneBlue
    GuiControl, 2: Hide, VZZ_zoneBrown
    GuiControl, 2: Hide, VZZ_zonePurple
    GuiControl, 2: Hide, VZZ_zoneYellow
    GuiControl, 2: Hide, VZZ_zoneOrange
    GuiControl, 2: Hide, VZZ_undoBtn
    GuiControl, 2: Hide, VZZ_resetBtn
    
    Loop, 9 {
        GuiControl, 2: Hide, WZ_text%A_Index%
        GuiControl, 2: Hide, WZ_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorWZ_radius
    GuiControl, 2: Hide, SeniorWZ_time1
    GuiControl, 2: Hide, SeniorWZ_time2
    GuiControl, 2: Hide, SeniorWZ_map
    GuiControl, 2: Hide, SeniorWZ_dimension
}
    
ShowSeniorElements() {
    GuiControl, 2: Choose, EventTypeChoice, %EventType%
    Gosub, EventTypeChanged
}

EventTypeChanged:
    Gui, 2: Submit, NoHide
    EventType := EventTypeChoice
    SaveSeniorSettings()
    
    Loop, 4 {
        GuiControl, 2: Hide, MCL_text%A_Index%
        GuiControl, 2: Hide, MCL_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorMCL_time1
    GuiControl, 2: Hide, SeniorMCL_time2
    GuiControl, 2: Hide, SeniorMCL_zone1
    GuiControl, 2: Hide, SeniorMCL_family1
    
    Loop, 5 {
        GuiControl, 2: Hide, VZZ_text%A_Index%
        GuiControl, 2: Hide, VZZ_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorVZZ_time1
    GuiControl, 2: Hide, SeniorVZZ_time2
    GuiControl, 2: Hide, SeniorVZZ_time3
    GuiControl, 2: Hide, SeniorVZZ_color1
    GuiControl, 2: Hide, SeniorVZZ_color2
    GuiControl, 2: Hide, SeniorVZZ_finalZone
    GuiControl, 2: Hide, SeniorVZZ_family1
    GuiControl, 2: Hide, VZZ_zonesLabel
    GuiControl, 2: Hide, VZZ_zoneRed
    GuiControl, 2: Hide, VZZ_zoneTurquoise
    GuiControl, 2: Hide, VZZ_zonePink
    GuiControl, 2: Hide, VZZ_zoneGreen
    GuiControl, 2: Hide, VZZ_zoneBlue
    GuiControl, 2: Hide, VZZ_zoneBrown
    GuiControl, 2: Hide, VZZ_zonePurple
    GuiControl, 2: Hide, VZZ_zoneYellow
    GuiControl, 2: Hide, VZZ_zoneOrange
    GuiControl, 2: Hide, VZZ_undoBtn
    GuiControl, 2: Hide, VZZ_resetBtn
    
    Loop, 9 {
        GuiControl, 2: Hide, WZ_text%A_Index%
        GuiControl, 2: Hide, WZ_copy%A_Index%
    }
    GuiControl, 2: Hide, SeniorWZ_radius
    GuiControl, 2: Hide, SeniorWZ_time1
    GuiControl, 2: Hide, SeniorWZ_time2
    GuiControl, 2: Hide, SeniorWZ_map
    GuiControl, 2: Hide, SeniorWZ_dimension
    
    if (EventType = 1) {
        Loop, 4 {
            GuiControl, 2: Show, MCL_text%A_Index%
            GuiControl, 2: Show, MCL_copy%A_Index%
        }
        GuiControl, 2: Show, SeniorMCL_time1
        GuiControl, 2: Show, SeniorMCL_time2
        GuiControl, 2: Show, SeniorMCL_zone1
        GuiControl, 2: Show, SeniorMCL_family1
    }
    else if (EventType = 2) {
        Loop, 5 {
            GuiControl, 2: Show, VZZ_text%A_Index%
            GuiControl, 2: Show, VZZ_copy%A_Index%
        }
        GuiControl, 2: Show, SeniorVZZ_time1
        GuiControl, 2: Show, SeniorVZZ_time2
        GuiControl, 2: Show, SeniorVZZ_time3
        GuiControl, 2: Show, SeniorVZZ_color1
        GuiControl, 2: Show, SeniorVZZ_color2
        GuiControl, 2: Show, SeniorVZZ_finalZone
        GuiControl, 2: Show, SeniorVZZ_family1
        GuiControl, 2: Show, VZZ_zonesLabel
        GuiControl, 2: Show, VZZ_zoneRed
        GuiControl, 2: Show, VZZ_zoneTurquoise
        GuiControl, 2: Show, VZZ_zonePink
        GuiControl, 2: Show, VZZ_zoneGreen
        GuiControl, 2: Show, VZZ_zoneBlue
        GuiControl, 2: Show, VZZ_zoneBrown
        GuiControl, 2: Show, VZZ_zonePurple
        GuiControl, 2: Show, VZZ_zoneYellow
        GuiControl, 2: Show, VZZ_zoneOrange
        GuiControl, 2: Show, VZZ_undoBtn
        GuiControl, 2: Show, VZZ_resetBtn
        
        UpdateZoneDropdowns()
        
        if (!IsObject(GlobalOriginalZones) || GlobalOriginalZones.Count() = 0) {
            SaveOriginalZonesState()
        }
    }
    else if (EventType = 3) {
        Loop, 9 {
            GuiControl, 2: Show, WZ_text%A_Index%
            GuiControl, 2: Show, WZ_copy%A_Index%
        }
        GuiControl, 2: Show, SeniorWZ_radius
        GuiControl, 2: Show, SeniorWZ_time1
        GuiControl, 2: Show, SeniorWZ_time2
        GuiControl, 2: Show, SeniorWZ_map
        GuiControl, 2: Show, SeniorWZ_dimension
    }
return

CopyMCL1:
    Gui, 2: Submit, NoHide
    text := "[MCL] Перенос начала на 5 минут. Старт в " . SeniorMCL_time1 . "."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyMCL2:
    text := "[MCL] Уважаемые игроки, Majestic Cyber League для семей начался. Можете заходить на территорию проведения мероприятия. Желаем удачи всем участникам!"
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyMCL3:
    Gui, 2: Submit, NoHide
    zoneInstrumental := GetZoneInstrumental(SeniorMCL_zone1)
    text := "[MCL] Участники мероприятия должны до " . SeniorMCL_time2 . " занять зону, отмеченную на карте " . zoneInstrumental . " цветом и удерживать ее. Последняя семья, которая останется в ней, станет победителем. В случае отсутствия семьи в зоне в указанное время она дисквалифицируется."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyMCL4:
    Gui, 2: Submit, NoHide
    text := "[MCL] Победителем семейного турнира Majestic Cyber League становится семья " . SeniorMCL_family1 . "! Они получают 1.000.000$. Спасибо всех за участие."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyVZZ1:
    Gui, 2: Submit, NoHide
    text := "[ВЗЗ] Перенос начала на 5 минут. Старт в " . SeniorVZZ_time1 . "."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyVZZ2:
    text := "[ВЗЗ] - Телепорт на мероприятие ""Война за зоны"" окончен. У семей есть 5 минут для захода в зону проведения мероприятия, иначе они будут дисквалифицированы."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyVZZ3:
    Gui, 2: Submit, NoHide
    
    global GlobalDeletedZones, GlobalDeletedZonesBackup, LastSelectedZones
    
    if (IsObject(GlobalDeletedZones)) {
        GlobalDeletedZonesBackup := CloneObject(GlobalDeletedZones)
    }
    
    selectedNowZones := []
    
    if (SeniorVZZ_color1 != "") {
        selectedNowZones.Push(SeniorVZZ_color1)
    }
    
    if (SeniorVZZ_color2 != "" && SeniorVZZ_color2 != SeniorVZZ_color1) {
        selectedNowZones.Push(SeniorVZZ_color2)
    }
    
    allDeletedZonesForText := {}
    
    if (IsObject(GlobalDeletedZones)) {
        for zone, _ in GlobalDeletedZones {
            allDeletedZonesForText[zone] := 1
        }
    }
    
    allZonesList := ""
    for zone, _ in allDeletedZonesForText {
        if (allZonesList = "") {
            allZonesList := zone
        } else {
            allZonesList := allZonesList . ", " . zone
        }
    }
    
    text := ""
    
    selectedCount := selectedNowZones.Length()
    
    if (selectedCount = 2) {
        text := "[ВЗЗ] - " . SeniorVZZ_color1 . " и " . SeniorVZZ_color2 . " зоны будут удалены. Семьи должны покинуть удалённые зоны до " . SeniorVZZ_time2 . "."
    }
    else if (selectedCount = 1) {
        if (SeniorVZZ_color1 != "") {
            text := "[ВЗЗ] - " . SeniorVZZ_color1 . " зона будет удалена. Семьи должны покинуть удалённую зону до " . SeniorVZZ_time2 . "."
        } else if (SeniorVZZ_color2 != "") {
            text := "[ВЗЗ] - " . SeniorVZZ_color2 . " зона будет удалена. Семьи должны покинуть удалённую зону до " . SeniorVZZ_time2 . "."
        }
    }
    else {
        text := "[ВЗЗ] Нет зон для удаления."
    }
    
    if (IsObject(GlobalDeletedZones) && GlobalDeletedZones.Count() > 0) {
        prevZonesList := ""
        zoneCount := 0
        
        for zone, _ in GlobalDeletedZones {
            zoneCount++
            if (prevZonesList = "") {
                prevZonesList := zone
            } else {
                prevZonesList := prevZonesList . ", " . zone
            }
        }
        
        if (zoneCount >= 2) {
            text := text . " Удалённые зоны - " . prevZonesList . "."
        } else if (zoneCount = 1) {
            text := text . " Удалённая зона - " . prevZonesList . "."
        }
    }
    
    clipboard := "/o " . text
    
    if (!IsObject(GlobalDeletedZones)) {
        GlobalDeletedZones := {}
    }
    
    for _, zone in selectedNowZones {
        GlobalDeletedZones[zone] := 1
    }
    
    AutoCheckZoneBoxes(GlobalDeletedZones)
    UpdateZoneDropdowns()
    
    SetTimer, RemoveToolTip2, -1500
return

AutoCheckZoneBoxes(deletedZones) {
    zoneControls := {}
    zoneControls["Красная"] := "VZZ_zoneRed"
    zoneControls["Бирюзовая"] := "VZZ_zoneTurquoise"
    zoneControls["Розовая"] := "VZZ_zonePink"
    zoneControls["Зеленая"] := "VZZ_zoneGreen"
    zoneControls["Синяя"] := "VZZ_zoneBlue"
    zoneControls["Коричневая"] := "VZZ_zoneBrown"
    zoneControls["Фиолетовая"] := "VZZ_zonePurple"
    zoneControls["Желтая"] := "VZZ_zoneYellow"
    zoneControls["Оранжевая"] := "VZZ_zoneOrange"
    
    zoneColors := {}
    zoneColors["Красная"] := "FF0000"
    zoneColors["Бирюзовая"] := "00CCCC"
    zoneColors["Розовая"] := "FF66CC"
    zoneColors["Зеленая"] := "00CC00"
    zoneColors["Синяя"] := "2929FF"
    zoneColors["Коричневая"] := "996633"
    zoneColors["Фиолетовая"] := "9900FF"
    zoneColors["Желтая"] := "FFFF00"
    zoneColors["Оранжевая"] := "FF9900"
    
    for zoneName, controlName in zoneControls {
        if (deletedZones.HasKey(zoneName)) {
            GuiControl, 2: +cAAAAAA, %controlName%
            GuiControl, 2:, %controlName%, ✗ %zoneName%
        } else {
            originalColor := zoneColors[zoneName]
            GuiControl, 2: +c%originalColor%, %controlName%
            GuiControl, 2:, %controlName%, %zoneName%
        }
    }
}

UpdateZoneDropdowns() {
    global GlobalDeletedZones, SeniorVZZ_color1, SeniorVZZ_color2, SeniorVZZ_finalZone
    
    if (!IsObject(GlobalDeletedZones)) {
        GlobalDeletedZones := {}
    }
    
    allZones := ["Красная", "Бирюзовая", "Розовая", "Зеленая", "Синяя", "Коричневая", "Фиолетовая", "Желтая", "Оранжевая"]
    
    filteredZones := ""
    for index, zone in allZones {
        if (!GlobalDeletedZones.HasKey(zone)) {
            filteredZones .= "|" . zone
        }
    }
    
    filteredZones1 := filteredZones
    filteredZones2 := "||" . filteredZones
    filteredZonesFinal := filteredZones
    
    GuiControl, 2:, SeniorVZZ_color1, %filteredZones1%
    GuiControl, 2:, SeniorVZZ_color2, %filteredZones2%
    GuiControl, 2:, SeniorVZZ_finalZone, %filteredZonesFinal%
    
    currentColor1 := SeniorVZZ_color1
    currentColor2 := SeniorVZZ_color2
    currentFinalZone := SeniorVZZ_finalZone
    
    if (currentColor1 != "" && !GlobalDeletedZones.HasKey(currentColor1)) {
        GuiControl, 2: ChooseString, SeniorVZZ_color1, %currentColor1%
    }
    
    if (currentColor2 != "" && !GlobalDeletedZones.HasKey(currentColor2)) {
        GuiControl, 2: ChooseString, SeniorVZZ_color2, %currentColor2%
    }
    
    if (currentFinalZone != "" && !GlobalDeletedZones.HasKey(currentFinalZone)) {
        GuiControl, 2: ChooseString, SeniorVZZ_finalZone, %currentFinalZone%
    }
}

CopyVZZ4:
    Gui, 2: Submit, NoHide
    text := "[ВЗЗ] Финальная зона - " . SeniorVZZ_finalZone . ". Семьи должны занять ее до " . SeniorVZZ_time3 . " и удерживать ее. Последняя семья, которая останется в ней, станет победителем. В случае отсутствия семьи в зоне в указанное время она дисквалифицируется."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyVZZ5:
    Gui, 2: Submit, NoHide
    text := "[ВЗЗ] Победителем семейного турнира Война за Зоны становится семья " . SeniorVZZ_family1 . "! Они получают 1.000.000$. Спасибо всем за участие."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ1:
    clipboard := "/spstatic stt_prop_track_start_02"
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ2:
    clipboard := "/rgw 100 gadget_parachute"
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ4:
    Gui, 2: Submit, NoHide
    if (SeniorWZ_map = "Ghetto")
        text := "/ctp -170.9670 -1599.9692 747.3179"
    else if (SeniorWZ_map = "Mirror")
        text := "/ctp 756.8967 -563.1296 977.4021"
    else if (SeniorWZ_map = "City")
        text := "/ctp -1295.8813 -502.9978 849.1414"
    else if (SeniorWZ_map = "Vinewood 1")
        text := "/ctp -183.2044 285.2044 650.1956"
    else if (SeniorWZ_map = "Vinewood 2")
        text := "/ctp -666.1846 282.7780 702.9861"
    else if (SeniorWZ_map = "Industrial")
        text := "/ctp 1214.7164 -2161.0022 830.0674"
    else if (SeniorWZ_map = "RedWood")
        text := "/ctp 967.4110 2185.3186 1099.4961"
    else if (SeniorWZ_map = "WindMill")
        text := "/ctp 2625.9956 2043.9956 835.4932"
    else if (SeniorWZ_map = "Vespucci")
        text := "/ctp -1125.7847 -1263.6659 955.0593"
    clipboard := text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ5:
    Gui, 2: Submit, NoHide
    text := "/zone " . SeniorWZ_dimension . " " . SeniorWZ_radius
    clipboard := text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ6:
    Gui, 2: Submit, NoHide
    text := "[Majestic Warzone] Перенос начала на 5 минут. Старт в " . SeniorWZ_time1 . "."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ7:
    text := "[Majestic Warzone] Мероприятие началось. Желаем всем удачи!"
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ8:
    Gui, 2: Submit, NoHide
    text := "[Majestic Warzone] Зона уменьшается. Команды должны покинуть внешний круг до " . SeniorWZ_time2 . " и занять новую зону."
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

CopyWZ9:
    text := "[Majestic Warzone] Мероприятие закончилось, итоги можете узнать в официальном дискорде Majestic Cyber League. Спасибо всем за участие!"
    clipboard := "/o " . text
    SetTimer, RemoveToolTip2, -1500
return

RemoveToolTip2:
    ToolTip, , , , 2
return

SwitchMode:
    if (CurrentMode = 1) {
        SaveOriginalZonesState()
		
		GuiControl, 2: Show, EventTypeChoice
		GuiControl, 2: Hide, BackgroundImage
		GuiControl, 2: Show, SeniorBackgroundImage
		GuiControl, 2: Show, Binds
        
        GuiControl, 2: Hide, Static1
        GuiControl, 2: Hide, Static2
        GuiControl, 2: Hide, Static3
        GuiControl, 2: Hide, Static4
        GuiControl, 2: Hide, Static5
        GuiControl, 2: Hide, Static6
        GuiControl, 2: Hide, Static7
        GuiControl, 2: Hide, Static8
        GuiControl, 2: Hide, Static9
        GuiControl, 2: Hide, Static10
        GuiControl, 2: Hide, Static11
        GuiControl, 2: Hide, Static12
        GuiControl, 2: Hide, Static13
        GuiControl, 2: Hide, Static14
        GuiControl, 2: Hide, Static15
        GuiControl, 2: Hide, Static16
        GuiControl, 2: Hide, Static17
        GuiControl, 2: Hide, Static18
		GuiControl, 2: Hide, Static19
		GuiControl, 2: Hide, Static20
		GuiControl, 2: Hide, Static21
		GuiControl, 2: Hide, Static22
		GuiControl, 2: Hide, Static23
		GuiControl, 2: Hide, Static24
		GuiControl, 2: Hide, Static25
		GuiControl, 2: Hide, Static26
		GuiControl, 2: Hide, Static27
        
        GuiControl, 2: Hide, Mode
        GuiControl, 2: Hide, Hot1
        GuiControl, 2: Hide, Hot2
        GuiControl, 2: Hide, Hot3
        GuiControl, 2: Hide, Hot4
        GuiControl, 2: Hide, Hot5
        GuiControl, 2: Hide, Hot6
        GuiControl, 2: Hide, Hot7
        GuiControl, 2: Hide, Hot8
        GuiControl, 2: Hide, Hot14
        
        GuiControl, 2: Hide, Radio1
        GuiControl, 2: Hide, Radio2
        GuiControl, 2: Hide, Radio3
        GuiControl, 2: Hide, Radio4
        GuiControl, 2: Hide, Radio5
        GuiControl, 2: Hide, Radio6
        GuiControl, 2: Hide, Radio7
        GuiControl, 2: Hide, Radio8
        
        GuiControl, 2: Hide, BtnZoneSettings
        GuiControl, 2: Hide, BtnZone
        GuiControl, 2: Hide, BtnWarzoneSettings
        GuiControl, 2: Hide, BtnWarzone
        GuiControl, 2: Hide, BtnSwitchMode
        GuiControl, 2: Hide, HotZoneReset
        GuiControl, 2: Hide, TimingZone
        GuiControl, 2: Hide, famid
		GuiControl, 2: Show, BindsVilk
       
        GuiControl, 2: Show, BackBtn
        GuiControl, 2: Show, SeniorModeText
        GuiControl, 2: Show, EventTypeLabel
        GuiControl, 2: Show, DisableBindsCheckbox
      
        ShowSeniorElements()
        
        CurrentMode := 2
    } else {
        HideAllSeniorElements()
		
		GuiControl, 2: Hide, SeniorBackgroundImage
		GuiControl, 2: Hide, Binds
		GuiControl, 2: Show, BackgroundImage		
		
        GuiControl, 2: Hide, BackBtn
        GuiControl, 2: Hide, DisableBindsCheckbox
        
        GuiControl, 2: Show, Static1
        GuiControl, 2: Show, Static2
        GuiControl, 2: Show, Static3
        GuiControl, 2: Show, Static4
        GuiControl, 2: Show, Static5
        GuiControl, 2: Show, Static6
        GuiControl, 2: Show, Static7
        GuiControl, 2: Show, Static8
        GuiControl, 2: Show, Static9
        GuiControl, 2: Show, Static10
        GuiControl, 2: Show, Static11
        GuiControl, 2: Show, Static12
        GuiControl, 2: Show, Static13
        GuiControl, 2: Show, Static14
        GuiControl, 2: Show, Static15
        GuiControl, 2: Show, Static16
        GuiControl, 2: Show, Static17
        GuiControl, 2: Show, Static18
		GuiControl, 2: Show, Static19
		GuiControl, 2: Show, Static20
		GuiControl, 2: Show, Static21
		GuiControl, 2: Show, Static22
		GuiControl, 2: Show, Static23
		GuiControl, 2: Show, Static24
		GuiControl, 2: Show, Static25
		GuiControl, 2: Show, Static26
		GuiControl, 2: Show, Static27
        
        GuiControl, 2: Show, Mode
        GuiControl, 2: Show, Hot1
        GuiControl, 2: Show, Hot2
        GuiControl, 2: Show, Hot3
        GuiControl, 2: Show, Hot4
        GuiControl, 2: Show, Hot5
        GuiControl, 2: Show, Hot6
        GuiControl, 2: Show, Hot7
        GuiControl, 2: Show, Hot8
        GuiControl, 2: Show, Hot14
        
        GuiControl, 2: Show, Radio1
        GuiControl, 2: Show, Radio2
        GuiControl, 2: Show, Radio3
        GuiControl, 2: Show, Radio4
        GuiControl, 2: Show, Radio5
        GuiControl, 2: Show, Radio6
        GuiControl, 2: Show, Radio7
        GuiControl, 2: Show, Radio8
        
        GuiControl, 2: Show, BtnZoneSettings
        GuiControl, 2: Show, BtnZone
        GuiControl, 2: Show, BtnWarzoneSettings
        GuiControl, 2: Show, BtnWarzone
        GuiControl, 2: Show, HotZoneReset
        GuiControl, 2: Show, TimingZone
        GuiControl, 2: Show, BtnSwitchMode
        GuiControl, 2: Show, famid
		GuiControl, 2: Hide, EventTypeChoice
       
        CurrentMode := 1
    }
Return

BackToMain:
    Gosub, SwitchMode
Return

ToggleBinds:
    Gui, 2: Submit, NoHide
    
    currentState := DisableBindsCheckbox
    
    if (currentState = 1) {
        BindsEnabled := false
        GuiControl, 2:, BindsVilk, Бинды выключены
        IniWrite, 0, Settings.ini, Settings, BindsEnabled
    } else {
        BindsEnabled := true
        GuiControl, 2:, BindsVilk, Бинды включены
        IniWrite, 1, Settings.ini, Settings, BindsEnabled
    }
    
    ToggleAllHotkeys(BindsEnabled)
Return

RemoveToolTip:
    ToolTip, , , , 1
Return

ToggleAllHotkeys(state) {
    local action := state ? "On" : "Off"
    
    Hotkey, %KEY1%, %action%, UseErrorLevel
    Hotkey, %KEY2%, %action%, UseErrorLevel
    Hotkey, %KEY3%, %action%, UseErrorLevel
    Hotkey, %KEY4%, %action%, UseErrorLevel
    Hotkey, %KEY5%, %action%, UseErrorLevel
    Hotkey, %KEY6%, %action%, UseErrorLevel
    Hotkey, %KEY7%, %action%, UseErrorLevel
    Hotkey, %KEY8%, %action%, UseErrorLevel
    Hotkey, %KEY14%, %action%, UseErrorLevel
    Hotkey, %keyZoneReset%, %action%, UseErrorLevel
    
    SetupZoneHotkeysState(state)
}

SetupZoneHotkeysState(state) {
    global ZoneKey1, ZoneKey2, ZoneKey3, ZoneKey4, ZoneKey5, ZoneKey6, ZoneKey7, ZoneKey8, ZoneKey9
    
    ZoneKey1 := ConvertHotkeyToAHKFormat(ZoneKey1)
    ZoneKey2 := ConvertHotkeyToAHKFormat(ZoneKey2)
    ZoneKey3 := ConvertHotkeyToAHKFormat(ZoneKey3)
    ZoneKey4 := ConvertHotkeyToAHKFormat(ZoneKey4)
    ZoneKey5 := ConvertHotkeyToAHKFormat(ZoneKey5)
    ZoneKey6 := ConvertHotkeyToAHKFormat(ZoneKey6)
    ZoneKey7 := ConvertHotkeyToAHKFormat(ZoneKey7)
    ZoneKey8 := ConvertHotkeyToAHKFormat(ZoneKey8)
    ZoneKey9 := ConvertHotkeyToAHKFormat(ZoneKey9)
    
    Hotkey, %ZoneKey1%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey2%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey3%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey4%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey5%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey6%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey7%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey8%, % state ? "On" : "Off", UseErrorLevel
    Hotkey, %ZoneKey9%, % state ? "On" : "Off", UseErrorLevel
}

Warzone:
    if (WarzoneOverlayVisible) {
        Gui, 5: Hide
        WarzoneOverlayVisible := false
    } else {
        ShowWarzoneOverlay()
        WarzoneOverlayVisible := true
    }
return

WarzoneSettings:
    if (WarzoneSettingsVisible) {
        Gui, 4: Hide
        WarzoneSettingsVisible := false
    } else {
        if (!WarzoneSettingsGUI_Created) {
            CreateWarzoneSettingsGUI()
            WarzoneSettingsGUI_Created := true
        }
        Gui, 4: Show, x1400 y500 w470 h360, Настройки Warzone
		WinGet, hWarzoneSettingsWnd, ID, Настройки Warzone
		SetDarkTitleBar(hWarzoneSettingsWnd)
        WarzoneSettingsVisible := true
    }
return

SetupZoneHotkeys() {
    global ZoneKey1, ZoneKey2, ZoneKey3, ZoneKey4, ZoneKey5, ZoneKey6, ZoneKey7, ZoneKey8, ZoneKey9

    ZoneKey1 := ConvertHotkeyToAHKFormat(ZoneKey1)
    ZoneKey2 := ConvertHotkeyToAHKFormat(ZoneKey2)
    ZoneKey3 := ConvertHotkeyToAHKFormat(ZoneKey3)
    ZoneKey4 := ConvertHotkeyToAHKFormat(ZoneKey4)
    ZoneKey5 := ConvertHotkeyToAHKFormat(ZoneKey5)
    ZoneKey6 := ConvertHotkeyToAHKFormat(ZoneKey6)
    ZoneKey7 := ConvertHotkeyToAHKFormat(ZoneKey7)
    ZoneKey8 := ConvertHotkeyToAHKFormat(ZoneKey8)
    ZoneKey9 := ConvertHotkeyToAHKFormat(ZoneKey9)
    
    Hotkey, %ZoneKey1%, Off, UseErrorLevel
    Hotkey, %ZoneKey1%, ToggleZone1, On, UseErrorLevel
    
    Hotkey, %ZoneKey2%, Off, UseErrorLevel
    Hotkey, %ZoneKey2%, ToggleZone2, On, UseErrorLevel
    
    Hotkey, %ZoneKey3%, Off, UseErrorLevel
    Hotkey, %ZoneKey3%, ToggleZone3, On, UseErrorLevel
    
    Hotkey, %ZoneKey4%, Off, UseErrorLevel
    Hotkey, %ZoneKey4%, ToggleZone4, On, UseErrorLevel
    
    Hotkey, %ZoneKey5%, Off, UseErrorLevel
    Hotkey, %ZoneKey5%, ToggleZone5, On, UseErrorLevel
    
    Hotkey, %ZoneKey6%, Off, UseErrorLevel
    Hotkey, %ZoneKey6%, ToggleZone6, On, UseErrorLevel
    
    Hotkey, %ZoneKey7%, Off, UseErrorLevel
    Hotkey, %ZoneKey7%, ToggleZone7, On, UseErrorLevel
    
    Hotkey, %ZoneKey8%, Off, UseErrorLevel
    Hotkey, %ZoneKey8%, ToggleZone8, On, UseErrorLevel
    
    Hotkey, %ZoneKey9%, Off, UseErrorLevel
    Hotkey, %ZoneKey9%, ToggleZone9, On, UseErrorLevel    
}

SaveID:
    Gui, 2: Submit, NoHide
    IniWrite, %famid%, Settings.ini, IDFamily, famid
return

SaveOption:
    Gui, 2: Submit, NoHide
    IniWrite, %Radio1%, Settings.ini, Settings, /hidecheatinfo
    IniWrite, %Radio2%, Settings.ini, Settings, /waypoints_toggle
    IniWrite, %Radio3%, Settings.ini, Settings, /gm
    IniWrite, %Radio4%, Settings.ini, Settings, /esp 3
    IniWrite, %Radio5%, Settings.ini, Settings, /subs_to_map_sync 1
    IniWrite, %Radio6%, Settings.ini, Settings, /frange 2000 familyID
    IniWrite, %Radio7%, Settings.ini, Settings, /tempfamily
    IniWrite, %Radio8%, Settings.ini, Settings, /zzoff
    IniWrite, %Hot1%, Settings.ini, KeySetup, KEY1
    IniWrite, %Hot2%, Settings.ini, KeySetup, KEY2
    IniWrite, %Hot3%, Settings.ini, KeySetup, KEY3
    IniWrite, %Hot4%, Settings.ini, KeySetup, KEY4
    IniWrite, %Hot5%, Settings.ini, KeySetup, KEY5
    IniWrite, %Hot6%, Settings.ini, KeySetup, KEY6
    IniWrite, %Hot7%, Settings.ini, KeySetup, KEY7
    IniWrite, %Hot8%, Settings.ini, KeySetup, KEY8
    IniWrite, %Hot14%, Settings.ini, KeySetup, KEY14
    IniWrite, %radius%, Settings.ini, radiusm, radius
    IniWrite, %TimingZone%, Settings.ini, KeySetup, TIMINGZONE
    HotZoneReset := FixHotkey(HotZoneReset)
    IniWrite, %HotZoneReset%, Settings.ini, KeySetup, KEY_ZONE_RESET
    IniWrite, % (BindsEnabled ? 1 : 0), Settings.ini, Settings, BindsEnabled
    
    if (radius = "ERROR")
    {
        IniWrite, 0, Settings.ini, IDFamily, famid
        IniWrite, 150, Settings.ini, radiusm, radius
        IniWrite, 10, Settings.ini, Coords, qx2
        IniWrite, 500, Settings.ini, Coords, qy2
        reload
    }

    Hotkey, %keyZoneReset%, Off, UseErrorLevel
    keyZoneReset := HotZoneReset
    Hotkey, %keyZoneReset%, ResetAllZones, On, UseErrorLevel
    
    Reload
return

TimingZoneSend:
    SendInput, {t}
    Sleep, 150
    
    global Mode, ZoneNom, ZoneMarkedForDeletion, ZoneTimeRemaining1, ZoneTimeRemaining2, ZoneTimeRemaining3
    global ZoneTimeRemaining4, ZoneTimeRemaining5, ZoneTimeRemaining6, ZoneTimeRemaining7, ZoneTimeRemaining8, ZoneTimeRemaining9
    global ZoneTimerRunning1, ZoneTimerRunning2, ZoneTimerRunning3, ZoneTimerRunning4, ZoneTimeRemaining5
    global ZoneTimerRunning6, ZoneTimerRunning7, ZoneTimerRunning8, ZoneTimerRunning9, CurrentZoneCount, CurrentMap
    
    if (Mode = 1) {
        originalZones := []
        
        if (CurrentMap = "Windmill") {
            originalZones := ["Красная","Желтая","Зеленая","Розовая","Синяя","Оранжевая","Фиолетовая","Бирюзовая"]
        } else {
            originalZones := ["Красная","Коричневая","Желтая","Фиолетовая","Синяя","Бирюзовая","Розовая","Зеленая","Оранжевая"]
        }
        
        remainingZones := []
        Loop, %CurrentZoneCount% {
            if (ZoneNom.HasKey(A_Index) && ZoneNom[A_Index] != "") {
                remainingZones.Push(ZoneNom[A_Index])
            }
        }
        
        deletedZones := ""
        for index, originalZone in originalZones {
            found := false
            for idx, remZone in remainingZones {
                if (remZone = originalZone) {
                    found := true
                    break
                }
            }
            if (!found) {
                if (deletedZones != "")
                    deletedZones .= ", "
                deletedZones .= originalZone
            }
        }
        
        markedZones := ""
        Loop, %CurrentZoneCount% {
            idx := A_Index
            if (ZoneNom.HasKey(idx) && ZoneNom[idx] != "" && ZoneMarkedForDeletion.HasKey(idx) && ZoneMarkedForDeletion[idx]) {
                if (markedZones != "")
                    markedZones .= ", "
                markedZones .= ZoneNom[idx]
            }
        }
        
        message := ""
        
        if (deletedZones != "") {
            message .= "Удалённые зоны: " . deletedZones
        }
        
        if (markedZones != "") {
            if (message != "")
                message .= ". "
            message .= "Удаляется: " . markedZones
        }
        
        if (message = "") {
            message := "Все зоны активны"
        }
        
        SendInput, /cb %message%{Enter}
        
    } else {
        zonesInfo := ""
        
        Loop, %CurrentZoneCount% {
            idx := A_Index
            if (ZoneNom.HasKey(idx) && ZoneNom[idx] != "") {
                remaining := ZoneTimeRemaining%idx%
                minutes := Floor(remaining / 60)
                seconds := Mod(remaining, 60)
                timeFormatted := Format("{:01}:{:02}", minutes, seconds)
                
                status := "⏸"
                if (ZoneTimerRunning%idx%)
                    status := "▶"
                
                if (zonesInfo != "")
                    zonesInfo .= ", "
                
                zonesInfo .= ZoneNom[idx] . " " . status . " " . timeFormatted
            }
        }
        
        if (zonesInfo != "") {
            SendInput, /cb %zonesInfo%{Enter}
        } else {
            SendInput, /cb Нет активных зон{Enter}
        }
    }
    
    Sleep, 300
return

Info:
    Gui, Info: Color, 1e1e1e
    Gui, Info: Font, s12,Segoe UI Variable
    Gui, Info: Font, cwhite
    
    Gui, Info: Add, Text, cee5180 x8 y8 h23 +0x200, Данный Binder создан для команды организаторов MCL.
    Gui, Info: Font, s11
    Gui, Info: Add, Text, x8 y40 +0x200, Все команды можно вводить транслитом.
    Gui, Info: Add, Text, x8 y60 h23 +0x200, В окно "ID семьи" вводите ID семьи, за которой следите, и нажимайте "Сохранить".
    Gui, Info: Add, Text, x8 y90 h23 +0x200, Команды, для которых назначаются горячие клавиши, используют эту информацию,
    Gui, Info: Add, Text, x8 y110 h23 +0x200, позволяя облегчить Вашу работу <3
    Gui, Info: Add, Text, cYellow x8 y150 h23 +0x200, Ctrl + F8 - Перезапустить.
    Gui, Info: Add, Text, cYellow x8 y170 h23 +0x200, Ctrl + F9 - Скрыть.
    Gui, Info: Add, Text, cYellow x8 y190 h23 +0x200, Ctrl + F10 - Закрыть.
    Gui, Info: Font, s14
    Gui, Info: Add, Text, x8 y245 h22 +0x200, Автор биндера - dizzing
    Gui, Info: Font, s11
    Gui, Info: Add, Text, x8 y270 h22 +0x200, Помощь в создании - neukor, gokushima
    
    Gui, Info: Show, h300 w600, Информация о биндере
	WinGet, hInfoWnd, ID, Информация о биндере
	SetDarkTitleBar(hInfoWnd)
Return

Teleports:
    Gui, Teleports: Color, 1e1e1e
    Gui, Teleports: Font, s10, Segoe UI Variable
    Gui, Teleports: Font, cwhite

    Gui, Teleports: Add, Text, cee5180 x8 y8 h20 +0x200, Телепорты по цветам
    Gui, Teleports: Add, Text, x8 y24 h20 +0x200, .фиол (.фиолетовый) - /ctp -481 -261 36
    Gui, Teleports: Add, Text, x8 y40 h20 +0x200, .бел (.белый) - /ctp -1652 88 64
    Gui, Teleports: Add, Text, x8 y56 h20 +0x200, .оранж (.оранжевый) - /ctp -2996 131 15
    Gui, Teleports: Add, Text, x8 y72 h20 +0x200, .сер (.серый) - /ctp 697 640 129
    Gui, Teleports: Add, Text, x8 y88 h20 +0x200, .жел (.желтый) - /ctp -2589 2290 30
    Gui, Teleports: Add, Text, x8 y104 w250 h20 +0x200, .кор (.коричневый) - /ctp 325 39 90
    Gui, Teleports: Add, Text, x8 y120 w250 h20 +0x200, .син (.синий) - /ctp 1300 1160 107
    Gui, Teleports: Add, Text, x8 y136 w250 h20 +0x200, .чер (.черный) - /ctp -1457 865 183
    Gui, Teleports: Add, Text, x8 y152 w250 h20 +0x200, .гол (.голубой) - /ctp -411 1195 325
    Gui, Teleports: Add, Text, x8 y168 w250 h20 +0x200, .беж (.бежевый) - /ctp -1272 278 65
    Gui, Teleports: Add, Text, x8 y184 w250 h20 +0x200, .зел (.зеленый) - /ctp 146 -336 45
    Gui, Teleports: Add, Text, x8 y200 w250 h20 +0x200, .крас (.красный) - /ctp -76 -1089 27
    Gui, Teleports: Add, Text, x8 y216 w250 h20 +0x200, .роз (.розовый) - /ctp -587 -1192 18
	Gui, Teleports: Add, Text, x8 y232 w250 h20 +0x200, .ргб (.rgb) - /ctp 970 139 81
    
    Gui, Teleports: Show, h255 w280, Телепорты
	WinGet, hTeleportsWnd, ID, Телепорты
	SetDarkTitleBar(hTeleportsWnd)
Return

Zone:
    if (ZoneGUI_Created) {
        Gui, 1: Destroy
        ZoneGUI_Created := false
        ZoneTimerVisible := false
        return
    }
    
    CreateZoneGUI()
    TotalZoneH := ZoneGuiHeight + ZoneTitleH
    GetAnchoredPos(Zones_Pos, 230, TotalZoneH, zx, zy)
    Gui, 1: Show, x%zx% y%zy% w230 h%TotalZoneH%, Зоны Таймер
    ZoneTimerVisible := true
return

ZoneSettings:
    if (ZoneSettingsVisible) {
        Gui, 3: Hide
        ZoneSettingsVisible := false
    } else {
        if (!ZoneSettingsGUI_Created) {
            CreateZoneSettingsGUI()
            ZoneSettingsGUI_Created := true
        }
		Gui, 3: Show, x500 y500 w320 h405, Настройки зон
        WinGet, hZoneSettingsWnd, ID, Настройки зон
		SetDarkTitleBar(hZoneSettingsWnd)
        ZoneSettingsVisible := true
    }
return

CreateZoneSettingsGUI() {
    global ZoneKey1, ZoneKey2, ZoneKey3, ZoneKey4, ZoneKey5, ZoneKey6, ZoneKey7, ZoneKey8, ZoneKey9, CurrentMap, Zones_Pos, Zones_PosChoice
    
    Gui, 3: -MaximizeBox
    Gui, 3: Color, +1e1e1e
    Gui, 3: Font, s9, Segoe UI Variable
    Gui, 3: Font, cWhite
    
    Gui, 3: Add, Picture, cee5180 x17 y8 w222 h25 BackgroundTrans, %A_ScriptDir%\img\settingszones.png
    
    Gui, 3: Add, Text, x20 y40 w100 h20 +0x200, Первая зона:
    Gui, 3: Add, Hotkey, x130 y40 w80 h21 vZoneHot1, %ZoneKey1%
    
    Gui, 3: Add, Text, x20 y70 w100 h20 +0x200, Вторая зона:
    Gui, 3: Add, Hotkey, x130 y70 w80 h21 vZoneHot2, %ZoneKey2%
    
    Gui, 3: Add, Text, x20 y100 w100 h20 +0x200, Третья зона:
    Gui, 3: Add, Hotkey, x130 y100 w80 h21 vZoneHot3, %ZoneKey3%
    
    Gui, 3: Add, Text, x20 y130 w100 h20 +0x200, Четвёртая зона:
    Gui, 3: Add, Hotkey, x130 y130 w80 h21 vZoneHot4, %ZoneKey4%
    
    Gui, 3: Add, Text, x20 y160 w100 h20 +0x200, Пятая зона:
    Gui, 3: Add, Hotkey, x130 y160 w80 h21 vZoneHot5, %ZoneKey5%
    
    Gui, 3: Add, Text, x20 y190 w100 h20 +0x200, Шестая зона:
    Gui, 3: Add, Hotkey, x130 y190 w80 h21 vZoneHot6, %ZoneKey6%
    
    Gui, 3: Add, Text, x20 y220 w100 h20 +0x200, Седьмая зона:
    Gui, 3: Add, Hotkey, x130 y220 w80 h21 vZoneHot7, %ZoneKey7%
    
    Gui, 3: Add, Text, x20 y250 w100 h20 +0x200, Восьмая зона:
    Gui, 3: Add, Hotkey, x130 y250 w80 h21 vZoneHot8, %ZoneKey8%
    
    Gui, 3: Add, Text, x20 y280 w100 h20 +0x200, Девятая зона:
    Gui, 3: Add, Hotkey, x130 y280 w80 h21 vZoneHot9, %ZoneKey9%
    
    Gui, 3: Add, Text, x20 y310 w110 h20 +0x200, Карта:
    mapItems := GetMapListForMode()
    Gui, 3: Add, DropDownList, x130 y308 w150 h120 vMapChoice3 gZoneMapChangedSettings cblack, %mapItems%
    GuiControl, 3: ChooseString, MapChoice3, %CurrentMap%

    Gui, 3: Add, Text, x20 y340 w110 h20 +0x200, Расположение:
    Gui, 3: Add, DropDownList, x130 y338 w150 h120 vZones_PosChoice AltSubmit cBlack, Левый верх|Правый верх|Левая середина|Правая середина|Левый низ|Правый низ
    GuiControl, 3: Choose, Zones_PosChoice, %Zones_Pos%

    Gui, 3: Add, Picture, x80 y370 w130 h25 gSaveZoneSettings, %A_ScriptDir%\img\save_settings.png
}

SaveZoneSettings:
    Gui, 3: Submit, NoHide

    Zones_Pos := Zones_PosChoice
    IniWrite, %Zones_Pos%, Settings.ini, Windows, Zones_Pos
    
    ZoneHot1 := ConvertHotkeyToAHKFormat(ZoneHot1)
    ZoneHot2 := ConvertHotkeyToAHKFormat(ZoneHot2)
    ZoneHot3 := ConvertHotkeyToAHKFormat(ZoneHot3)
    ZoneHot4 := ConvertHotkeyToAHKFormat(ZoneHot4)
    ZoneHot5 := ConvertHotkeyToAHKFormat(ZoneHot5)
    ZoneHot6 := ConvertHotkeyToAHKFormat(ZoneHot6)
    ZoneHot7 := ConvertHotkeyToAHKFormat(ZoneHot7)
    ZoneHot8 := ConvertHotkeyToAHKFormat(ZoneHot8)
    ZoneHot9 := ConvertHotkeyToAHKFormat(ZoneHot9)
    
    IniWrite, %ZoneHot1%, Settings.ini, ZoneKeys, KEY_ZONE1
    IniWrite, %ZoneHot2%, Settings.ini, ZoneKeys, KEY_ZONE2
    IniWrite, %ZoneHot3%, Settings.ini, ZoneKeys, KEY_ZONE3
    IniWrite, %ZoneHot4%, Settings.ini, ZoneKeys, KEY_ZONE4
    IniWrite, %ZoneHot5%, Settings.ini, ZoneKeys, KEY_ZONE5
    IniWrite, %ZoneHot6%, Settings.ini, ZoneKeys, KEY_ZONE6
    IniWrite, %ZoneHot7%, Settings.ini, ZoneKeys, KEY_ZONE7
    IniWrite, %ZoneHot8%, Settings.ini, ZoneKeys, KEY_ZONE8
    IniWrite, %ZoneHot9%, Settings.ini, ZoneKeys, KEY_ZONE9
    
    ZoneKey1 := ZoneHot1
    ZoneKey2 := ZoneHot2
    ZoneKey3 := ZoneHot3
    ZoneKey4 := ZoneHot4
    ZoneKey5 := ZoneHot5
    ZoneKey6 := ZoneHot6
    ZoneKey7 := ZoneHot7
    ZoneKey8 := ZoneHot8
    ZoneKey9 := ZoneHot9
    
    SetupZoneHotkeys()
    
    if (ZoneTimerVisible) {
        Gui, 1: Destroy
        ZoneGUI_Created := false
        ZoneTimerVisible := false
        
        CreateZoneGUI()
        TotalZoneH := ZoneGuiHeight + ZoneTitleH
        GetAnchoredPos(Zones_Pos, 230, TotalZoneH, zx, zy)
        Gui, 1: Show, x%zx% y%zy% w230 h%TotalZoneH%, Зоны Таймер
        ZoneTimerVisible := true
    }
    
return

ConvertHotkeyToAHKFormat(key) {
    key := StrReplace(key, " ", "")
    
    key := RegExReplace(key, "i)Ctrl", "^")
    key := RegExReplace(key, "i)Alt", "!")
    key := RegExReplace(key, "i)Win", "#")
    
    key := RegExReplace(key, "i)\+([1-9])", "$1")
    
    return key
}

LoadWarzoneSettings() {
    global WZ_ID, WZ_Enable, WZ_Pos

    IniRead, WZ_Pos, Settings.ini, Warzone, POSITION, 2
    if (WZ_Pos != 1 && WZ_Pos != 2)
        WZ_Pos := 2

    WZ_ID := []
    WZ_Enable := []

    Loop, 6 {
        team := A_Index
        IniRead, __en, Settings.ini, Warzone, ENABLE_%team%, 0
        WZ_Enable[team] := (__en = 1) ? 1 : 0

        WZ_ID[team] := []
        Loop, 4 {
            slot := A_Index
            IniRead, __id, Settings.ini, Warzone, TEAM%team%_ID%slot%, %A_Space%
            __id := Trim(__id)
            WZ_ID[team][slot] := __id
        }
    }
}

CreateWarzoneSettingsGUI() {
    global WZ_ID, WZ_Enable, WZ_Pos, WZ_PosChoice
    global WZ_En1, WZ_En2, WZ_En3, WZ_En4, WZ_En5, WZ_En6
    global WZ_ID1_1, WZ_ID1_2, WZ_ID1_3, WZ_ID1_4
    global WZ_ID2_1, WZ_ID2_2, WZ_ID2_3, WZ_ID2_4
    global WZ_ID3_1, WZ_ID3_2, WZ_ID3_3, WZ_ID3_4
    global WZ_ID4_1, WZ_ID4_2, WZ_ID4_3, WZ_ID4_4
    global WZ_ID5_1, WZ_ID5_2, WZ_ID5_3, WZ_ID5_4
    global WZ_ID6_1, WZ_ID6_2, WZ_ID6_3, WZ_ID6_4

    Loop, 6 {
        t := A_Index
        enVar := "WZ_En" . t
        %enVar% := WZ_Enable[t]
        Loop, 4 {
            s := A_Index
            idVar := "WZ_ID" . t . "_" . s
            %idVar% := WZ_ID[t][s]
        }
    }

    Gui, 4: -MaximizeBox
    Gui, 4: Color, +1e1e1e
    Gui, 4: Font, s9, Segoe UI Variable
    Gui, 4: Font, cWhite

    Gui, 4: Add, Picture, cee5180 x8 y10 h35 w174 BackgroundTrans, %A_ScriptDir%\img\settingsid.png

    Gui, 4: Add, Text, x180 y32 w50 h18 +0x200 Center BackgroundTrans, ID 1
    Gui, 4: Add, Text, x240 y32 w50 h18 +0x200 Center BackgroundTrans, ID 2
    Gui, 4: Add, Text, x300 y32 w50 h18 +0x200 Center BackgroundTrans, ID 3
    Gui, 4: Add, Text, x360 y32 w50 h18 +0x200 Center BackgroundTrans, ID 4

    y := 55
    Loop, 6 {
        t := A_Index
        en := WZ_Enable[t]

        Gui, 4: Add, CheckBox, x12 y%y% w16 h20 vWZ_En%t% Checked%en%
        Gui, 4: Add, Text, x35 y%y% w135 h20 +0x200, Команда %t%

        id1 := WZ_ID[t][1]
        id2 := WZ_ID[t][2]
        id3 := WZ_ID[t][3]
        id4 := WZ_ID[t][4]

        Gui, 4: Add, Edit, x175 y%y% w55 h20 vWZ_ID%t%_1 cBlack, %id1%
        Gui, 4: Add, Edit, x235 y%y% w55 h20 vWZ_ID%t%_2 cBlack, %id2%
        Gui, 4: Add, Edit, x295 y%y% w55 h20 vWZ_ID%t%_3 cBlack, %id3%
        Gui, 4: Add, Edit, x355 y%y% w55 h20 vWZ_ID%t%_4 cBlack, %id4%

        y += 35
    }

    Gui, 4: Add, Text, x12 y%y% w160 h20 +0x200, Расположение плашки:
    Gui, 4: Add, DropDownList, x180 y%y% w230 h90 vWZ_PosChoice AltSubmit cBlack, По центру сверху|По центру снизу
    if (WZ_Pos = 1)
        GuiControl, 4: Choose, WZ_PosChoice, 1
    else
        GuiControl, 4: Choose, WZ_PosChoice, 2

    y += 30
    Gui, 4: Add, Picture, x230 y%y% w180 h26 gSaveWarzoneSettings, %A_ScriptDir%\img\save_settingsw.png
    Gui, 4: Add, Picture, x12 y%y% w70 h26 gClearWarzoneIDs, %A_ScriptDir%\img\clear.png
}

SaveWarzoneSettings:
    global WZ_ID, WZ_Enable, WarzoneOverlayVisible, WZ_Pos
    Gui, 4: Submit, NoHide

    WZ_Pos := WZ_PosChoice
    IniWrite, %WZ_Pos%, Settings.ini, Warzone, POSITION

    Loop, 6 {
        t := A_Index
        enVarName := "WZ_En" . t
        enVal := %enVarName%
        IniWrite, %enVal%, Settings.ini, Warzone, ENABLE_%t%

        Loop, 4 {
            s := A_Index
            idVarName := "WZ_ID" . t . "_" . s
            idVal := %idVarName%
            idVal := Trim(idVal)
            IniWrite, %idVal%, Settings.ini, Warzone, TEAM%t%_ID%s%
        }
    }

    LoadWarzoneSettings()
    if (WarzoneOverlayVisible)
        ShowWarzoneOverlay()
return

ShowWarzoneOverlay() {
    global WZ_ID, WZ_Enable, WZ_Pos, WZ_BTN_MAP, WarzoneOverlayGUI_Created

    if (WarzoneOverlayGUI_Created) {
        Gui, 5: Destroy
        WarzoneOverlayGUI_Created := false
    }

    WZ_BTN_MAP := {}

    Gui, 5: +AlwaysOnTop -MaximizeBox -MinimizeBox -Caption +ToolWindow -Border
	Gui, 5: Color, 1e1e1e
    Gui, 5: Font, s8, Segoe UI Variable
    Gui, 5: Font, cWhite

    xPad := 10
    yPad := 10

    badgeW := 120
    badgeH := 22
    badgeY := 2

    btnW := 86
    btnH := 22
    btnGap := 6
    blockW := 110
    blockH := 0
    gapX := 12
    gapY := 12

    teams := []
    Loop, 6 {
        t := A_Index
        if (WZ_Enable[t])
            teams.Push(t)
    }

    maxBtns := 1
    for _, t in teams {
        c := 0
        Loop, 4 {
            if (Trim(WZ_ID[t][A_Index]) != "")
                c++
        }
        if (c > maxBtns)
            maxBtns := c
    }
    if (maxBtns < 1)
        maxBtns := 1

    blockH := 18 + 8 + (maxBtns*btnH) + ((maxBtns-1)*btnGap) + 12

    if (teams.Length() = 0) {
        totalW := 320
        totalH := 95
        
        xPos := Floor((A_ScreenWidth - totalW) / 2)
        if (WZ_Pos = 1)
            yPos := 0
        else
            yPos := A_ScreenHeight - totalH
        if (yPos < 0)
            yPos := 0

        frameC := "DF005C"
        yBottom := totalH - 2
        xRight  := totalW - 2
        
        Gui, 5: Add, Progress, x0 y0 w%totalW% h2 c%frameC% Background%frameC% hwndhF1
        Gui, 5: Add, Progress, x0 y%yBottom% w%totalW% h2 c%frameC% Background%frameC% hwndhF2
        Gui, 5: Add, Progress, x0 y0 w2 h%totalH% c%frameC% Background%frameC% hwndhF3
        Gui, 5: Add, Progress, x%xRight% y0 w2 h%totalH% c%frameC% Background%frameC% hwndhF4
        StripProgressEdges(hF1), StripProgressEdges(hF2), StripProgressEdges(hF3), StripProgressEdges(hF4)
        
        bx := Floor((totalW - 120) / 2)
        Gui, 5: Font, s9 cDF005C Bold, Segoe UI Variable
        Gui, 5: Add, Text, x%bx% y2 w120 h22 +0x200 Center BackgroundTrans, Warzone
        Gui, 5: Font, s8 cWhite Norm, Segoe UI Variable

        Gui, 5: Add, Text, x0 y35 w%totalW% h40 +0x200 Center BackgroundTrans, Кол-во команд не выбрано

        Gui, 5: Show, x%xPos% y%yPos% w%totalW% h%totalH% NoActivate
        WarzoneOverlayGUI_Created := true
        return
    }

    blocksPerRow := 6

    __len := teams.Length()
    rows := Ceil(__len / blocksPerRow)

    totalW := (__len * blockW) + ((__len-1) * gapX) + (xPad*2)
    if (__len = 1)
        totalW := blockW + (xPad*2)

    topGap := badgeH + 8
    totalH := yPad + topGap + (rows * blockH) + ((rows-1) * gapY) + yPad

    xPos := Floor((A_ScreenWidth - totalW) / 2)
    if (WZ_Pos = 1)
        yPos := 0
    else
        yPos := A_ScreenHeight - totalH
    if (yPos < 0)
        yPos := 0

    frameC := "DF005C"
    yBottom := totalH - 2
    xRight  := totalW - 2
    if (yBottom < 0)
        yBottom := 0
    if (xRight < 0)
        xRight := 0

    Gui, 5: Add, Progress, x0 y0 w%totalW% h2 c%frameC% Background%frameC% hwndhF1
    Gui, 5: Add, Progress, x0 y%yBottom% w%totalW% h2 c%frameC% Background%frameC% hwndhF2
    Gui, 5: Add, Progress, x0 y0 w2 h%totalH% c%frameC% Background%frameC% hwndhF3
    Gui, 5: Add, Progress, x%xRight% y0 w2 h%totalH% c%frameC% Background%frameC% hwndhF4
    StripProgressEdges(hF1), StripProgressEdges(hF2), StripProgressEdges(hF3), StripProgressEdges(hF4)

    bx := Floor((totalW - badgeW) / 2)
    Gui, 5: Add, Text, x%bx% y%badgeY% w%badgeW% h%badgeH% +Background282b31
    Gui, 5: Font, s9 cDF005C Bold, Segoe UI Variable
    Gui, 5: Add, Text, x%bx% y%badgeY%+2 w%badgeW% h%badgeH% +0x200 Center, Warzone
    Gui, 5: Font, s8 cWhite Norm, Segoe UI Variable

    startY := yPad + topGap
    idx := 0

    for _, t in teams {
        idx++
        col := idx - 1

        bx0 := xPad + (col * (blockW + gapX))
        by0 := startY

        Gui, 5: Add, Text, x%bx0% y%by0% w%blockW% h%blockH% 0x10
        Gui, 5: Font, s8 cWhite Norm, Segoe UI Variable
        Gui, 5: Add, Text, x%bx0% y%by0%+6 w%blockW% h16 +0x200 Center, Команда %t%

        innerX := bx0 + Floor((blockW - btnW) / 2)
        innerY := by0 + 24
        btnIdx := 0

        Loop, 4 {
            s := A_Index
            id := Trim(WZ_ID[t][s])
            if (id = "")
                continue

            btnIdx++
            py := innerY + ((btnIdx-1) * (btnH + btnGap))
            Gui, 5: Add, Button, x%innerX% y%py% w%btnW% h%btnH% gWZ_TP hwndhBtn, %id%
            WZ_BTN_MAP[hBtn] := id
        }
    }

    Gui, 5: Show, x%xPos% y%yPos% w%totalW% h%totalH% NoActivate
    WarzoneOverlayGUI_Created := true
}

ActivateGameWindow() {
    global LastGameHwnd
    
    LastGameHwnd := 0
    
    if (hwnd := WinExist("ahk_exe GTA5.exe")) {
        LastGameHwnd := hwnd
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%, , 0.5
        return true
    }
    
    if (hwnd := WinExist("Grand Theft Auto V")) {
        LastGameHwnd := hwnd
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%, , 0.5
        return true
    }
    
    if (hwnd := WinExist("ahk_exe ragemp_v.exe")) {
        LastGameHwnd := hwnd
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%, , 0.5
        return true
    }
    
    if (hwnd := WinExist("ahk_exe FiveM.exe")) {
        LastGameHwnd := hwnd
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%, , 0.5
        return true
    }
    
    if (hwnd := WinExist("ahk_class grcWindow")) {
        LastGameHwnd := hwnd
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%, , 0.5
        return true
    }
    
    WinGet, windows, List
    Loop, %windows% {
        hwnd := windows%A_Index%
        WinGetTitle, title, ahk_id %hwnd%
        if (InStr(title, "Grand Theft Auto") || InStr(title, "GTA")) {
            LastGameHwnd := hwnd
            WinActivate, ahk_id %hwnd%
            WinWaitActive, ahk_id %hwnd%, , 0.5
            return true
        }
    }
    
    return false
}

GetAnchoredPos(pos, w, h, ByRef outX, ByRef outY) {
    margin := 0
    
    if (w > A_ScreenWidth)
        w := A_ScreenWidth
    if (h > A_ScreenHeight)
        h := A_ScreenHeight

    if (pos = 1) {
        outX := margin
        outY := margin
        return
    }
    if (pos = 2) {
        outX := A_ScreenWidth - w - margin
        outY := margin
        return
    }
    if (pos = 3) {
        outX := margin
        outY := Floor((A_ScreenHeight - h) / 2)
        return
    }
    if (pos = 4) {
        outX := A_ScreenWidth - w - margin
        outY := Floor((A_ScreenHeight - h) / 2)
        return
    }
    if (pos = 5) {
        outX := margin
        outY := A_ScreenHeight - h - margin
        return
    }
    outX := A_ScreenWidth - w - margin
    outY := A_ScreenHeight - h - margin
}

WZ_TP:
    ControlGetText, id, %A_GuiControl%, A
    
    if (!id || id = "") {
        return
    }
    
    WinGet, gta5_id, ID, ahk_exe GTA5.exe
    
    if (gta5_id) {
        WinActivate, ahk_id %gta5_id%
        WinWaitActive, ahk_id %gta5_id%
        
        Sleep, 50
        SendInput, {t}
        Sleep, 50
        SendInput, /tp %id%{enter}
    } else {
        MsgBox, GTA5 не найдена!
    }
return

UpdateMode:
    Gui, 2: Submit, NoHide
    IniWrite, %Mode%, Settings.ini, Zones, MODE

    EnsureValidCurrentMapForMode()
    IniWrite, %CurrentMap%, Settings.ini, Zones, Map

    StopAllZoneTimers()
    
    ZoneMarkedForDeletion := []
    ZoneOriginalColors := []

    if (ZoneGUI_Created)
        ApplyMapZones(CurrentMap)

    if (ZoneSettingsGUI_Created)
        UpdateZoneSettingsMapList()
return

startfamtimer:
    Gui, 2: Submit, NoHide
    if (Mode = 2)
        ModeCode := 100
    else
        ModeCode := 125

    sleep 150
    SendInput, {t}
    sleep 150
    SendInput, /startfamtimer %famid% %ModeCode% 120
return

listfamtimers:
    sleep 150
    SendInput, {t}
    sleep 150
    SendInput, /listfamtimers %famid%{enter}
return

stopfamtimer:
    sleep 150
    SendInput, {t}
    sleep 150
    SendInput, /stopfamtimer{space}
return

continuefamtimer:
    sleep 150
    SendInput, {t}
    sleep 150
    SendInput, /continuefamtimer{space}
return

deletefamtimer:
    sleep 150
    SendInput, {t}
    sleep 150
    SendInput, /deletefamtimer{space}
return

feventon:
    Sleep 150
    BlockInput, SendAndMouse
    SendInput, {t}
    Sleep 150
    SendInput, /clearallfamtimer %famid%{space}
return

setdim:
    Sleep 150
    BlockInput, SendAndMouse
    SendInput, {t}
    Sleep 150
    SendInput, /setdim  %famid%
    Sleep 10
    length := StrLen(famid) + 1
    SendInput, {Left %length%}
return

rsetdim:
    Sleep 150
    BlockInput, SendAndMouse
    SendInput, {t}
    Sleep 150
    SendInput, /rsetdim 10 %famid%
return

vhod:
    Gui, 2: Submit, NoHide
    
    SendMessage, 0x50,, 0x4090409
    
    if (Radio4==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /esp 3{Enter}
        Sleep 300
    }
    if (Radio6==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /frange 2000 %famid%{Enter}
        Sleep 300
    }
    if (Radio2==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /waypoints_toggle{Enter}
        Sleep 300
    }
    if (Radio1==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /hidecheatinfo{Enter}
        Sleep 300
    }
    if (Radio3==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /gm{Enter}
        Sleep 300
    }
    if (Radio5==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /subs_to_map_sync 1{Enter}
        Sleep 300
    }
    if (Radio7==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /tempfamily %famid%{Enter}
        Sleep 300
    }
    
    if (Radio8==1)
    {
        SendInput, {T}
        Sleep 300
        SendInput, /zzoff %SeniorWZ_dimension%{Enter}
        Sleep 300
    }
return

:?:.фиол::/ctp -481 -261 36
:?:.фиолетовый::/ctp -481 -261 36
:?:.бел::/ctp -1652 88 64
:?:.белый::/ctp -1652 88 64
:?:.оранж::/ctp -2996 131 15
:?:.оранжевый::/ctp -2996 131 15
:?:.сер::/ctp 697 640 129
:?:.серый::/ctp 697 640 129
:?:.жел::/ctp -2589 2290 30
:?:.желтый::/ctp -2589 2290 30
:?:.кор::/ctp 325 39 90
:?:.коричневый::/ctp 325 39 90
:?:.син::/ctp 1300 1160 107
:?:.синий::/ctp 1300 1160 107
:?:.чер::/ctp -1457 865 183
:?:.черный::/ctp -1457 865 183
:?:.гол::/ctp -411 1195 325
:?:.голубой::/ctp -411 1195 325
:?:.беж::/ctp -1272 278 65
:?:.бежевый::/ctp -1272 278 65
:?:.зел::/ctp 146 -336 45
:?:.зеленый::/ctp 146 -336 45
:?:.крас::/ctp -76 -1089 27
:?:.красный::/ctp -76 -1089 27
:?:.роз::/ctp -587 -1192 18
:?:.розовый::/ctp -587 -1192 18
:?:.ргб::/ctp 970 139 81
:?:.rgb::/ctp 970 139 81

Reload:
    reload
return

^F8::reload
^F10::ExitApp

^F9::
    if (GuiVisible) {
        Gui, 2: Hide
        GuiVisible := false
    } else {
        Gui, 2: Show
        GuiVisible := true
    }
return

Close:
    Gui, 1: Destroy
    exitapp
return

Hide:
    Gui, 2: Hide
    GuiVisible := false
return

Show:
    Gui, 2: Show
    GuiVisible := true
return

GuiClose:
    Gui, 1: Destroy
    ExitApp
return

Gui2Close:
    Gui, 1: Destroy
    Gui, 2: Hide
    GuiVisible := false
return

Gui3Close:
    Gui, 3: Hide
    ZoneSettingsVisible := false
return

Gui4Close:
    Gui, 4: Hide
    WarzoneSettingsVisible := false
return

global ZoneTimerRunning1 := false
global ZoneTimerRunning2 := false
global ZoneTimerRunning3 := false
global ZoneTimerRunning4 := false
global ZoneTimerRunning5 := false
global ZoneTimerRunning6 := false
global ZoneTimerRunning7 := false
global ZoneTimerRunning8 := false
global ZoneTimerRunning9 := false

CreateZoneGUI() {
    global

    if (ZoneGUI_Created)
        return

    Gui, 1: -Caption -Border +AlwaysOnTop +ToolWindow +HwndhZoneGui
	Gui, 1: Color, 010203
    Gui, 1: Font, s11, Segoe UI Variable

    Gui, 1: +LastFound
    WinSet, TransColor, 010203 255

    titleH := ZoneTitleH

    Gui, 1: Add, Progress, x0 y%titleH% w230 h%ZoneGuiHeight% vZoneBgOuter hwndhZoneBgOuter c282b31 Backgrounde81c5a, 100
    ZoneGuiInnerHeight := ZoneGuiHeight - 4
    innerY := titleH + 2
    Gui, 1: Add, Progress, x2 y%innerY% w226 h%ZoneGuiInnerHeight% vZoneBgInner hwndhZoneBgInner c282b31 Background1e1e1e, 100

    StripProgressEdges(hZoneBgOuter)
    StripProgressEdges(hZoneBgInner)

    Gui, 1: Font, s12, Segoe UI Variable
    Gui, 1: Add, Text, x0 y2 w230 h18 +Center cE81C5A BackgroundTrans vMapTitleText, %CurrentMap%
    Gui, 1: Font, s11, Segoe UI Variable

    DisplayKey1 := ReadableKey(ZoneKey1)
    DisplayKey2 := ReadableKey(ZoneKey2)
    DisplayKey3 := ReadableKey(ZoneKey3)
    DisplayKey4 := ReadableKey(ZoneKey4)
    DisplayKey5 := ReadableKey(ZoneKey5)
    DisplayKey6 := ReadableKey(ZoneKey6)
    DisplayKey7 := ReadableKey(ZoneKey7)
    DisplayKey8 := ReadableKey(ZoneKey8)
    DisplayKey9 := ReadableKey(ZoneKey9)

    rowY1 := titleH + 15
    rowY2 := titleH + 45
    rowY3 := titleH + 75
    rowY4 := titleH + 105
    rowY5 := titleH + 135
    rowY6 := titleH + 165
    rowY7 := titleH + 195
    rowY8 := titleH + 225
    rowY9 := titleH + 255

    Gui, 1: Add, Text, x15 y%rowY1% w130 h20 cFFFFFF BackgroundTrans vKeyText1, %DisplayKey1%
    Gui, 1: Add, Text, x15 y%rowY2% w130 h20 cFFFFFF BackgroundTrans vKeyText2, %DisplayKey2%
    Gui, 1: Add, Text, x15 y%rowY3% w130 h20 cFFFFFF BackgroundTrans vKeyText3, %DisplayKey3%
    Gui, 1: Add, Text, x15 y%rowY4% w130 h20 cFFFFFF BackgroundTrans vKeyText4, %DisplayKey4%
    Gui, 1: Add, Text, x15 y%rowY5% w130 h20 cFFFFFF BackgroundTrans vKeyText5, %DisplayKey5%
    Gui, 1: Add, Text, x15 y%rowY6% w130 h20 cFFFFFF BackgroundTrans vKeyText6, %DisplayKey6%
    Gui, 1: Add, Text, x15 y%rowY7% w130 h20 cFFFFFF BackgroundTrans vKeyText7, %DisplayKey7%
    Gui, 1: Add, Text, x15 y%rowY8% w130 h20 cFFFFFF BackgroundTrans vKeyText8, %DisplayKey8%
    Gui, 1: Add, Text, x15 y%rowY9% w130 h20 cFFFFFF BackgroundTrans vKeyText9, %DisplayKey9%

    Gui, 1: Add, Text, x105 y%rowY1% w120 h20 cFF0000 BackgroundTrans vZoneText1,
    Gui, 1: Add, Text, x105 y%rowY2% w120 h20 c00CCCC BackgroundTrans vZoneText2,
    Gui, 1: Add, Text, x105 y%rowY3% w120 h20 cFF66CC BackgroundTrans vZoneText3,
    Gui, 1: Add, Text, x105 y%rowY4% w120 h20 c00CC00 BackgroundTrans vZoneText4,
    Gui, 1: Add, Text, x105 y%rowY5% w120 h20 c2929ff BackgroundTrans vZoneText5,
    Gui, 1: Add, Text, x105 y%rowY6% w120 h20 c996633 BackgroundTrans vZoneText6,
    Gui, 1: Add, Text, x105 y%rowY7% w120 h20 c9900FF BackgroundTrans vZoneText7,
    Gui, 1: Add, Text, x105 y%rowY8% w120 h20 cFFFF00 BackgroundTrans vZoneText8,
    Gui, 1: Add, Text, x105 y%rowY9% w120 h20 cFF9900 BackgroundTrans vZoneText9,

    ZoneGUI_Created := true
    ApplyMapZones(CurrentMap)
}

UpdateZoneGuiSize(zoneCount) {
    global ZoneGuiHeight, ZoneGUI_Created, hZoneGui
    if (!ZoneGUI_Created)
        return

    if (zoneCount < 1)
        zoneCount := 1

    ZoneGuiHeight := 50 + (zoneCount - 1) * 30
    if (ZoneGuiHeight < 20)
        ZoneGuiHeight := 20

    innerH := ZoneGuiHeight - 4

    GuiControl, 1: Move, ZoneBgOuter, h%ZoneGuiHeight%
    GuiControl, 1: Move, ZoneBgInner, h%innerH%

    if (hZoneGui) {
        WinGetPos, __x, __y,,, ahk_id %hZoneGui%
        totalH := ZoneGuiHeight + ZoneTitleH
        WinMove, ahk_id %hZoneGui%,, %__x%, %__y%, 230, %totalH%
    }
}

GetZoneHexByName(name) {
    if (name = "Красная")
        return "FF0000"
    if (name = "Бирюзовая")
        return "00CCCC"
    if (name = "Розовая")
        return "FF66CC"
    if (name = "Зеленая")
        return "00CC00"
    if (name = "Синяя")
        return "2929FF"
    if (name = "Коричневая")
        return "996633"
    if (name = "Фиолетовая")
        return "9900FF"
    if (name = "Желтая")
        return "FFFF00"
    if (name = "Оранжевая")
        return "FF9900"
    return "FFFFFF"
}

GetZoneGen(name) {
    if (name = "Красная")
        return "Красной"
    if (name = "Бирюзовая")
        return "Бирюзовой"
    if (name = "Розовая")
        return "Розовой"
    if (name = "Зеленая")
        return "Зелёной"
    if (name = "Синяя")
        return "Синей"
    if (name = "Коричневая")
        return "Коричневой"
    if (name = "Фиолетовая")
        return "Фиолетовой"
    if (name = "Желтая")
        return "Жёлтой"
    if (name = "Оранжевая")
        return "Оранжевой"
    return ""
}
GetZoneAcc(name) {
    if (name = "Красная")
        return "Красную"
    if (name = "Бирюзовая")
        return "Бирюзовую"
    if (name = "Розовая")
        return "Розовую"
    if (name = "Зеленая")
        return "Зеленую"
    if (name = "Синяя")
        return "Синюю"
    if (name = "Коричневая")
        return "Коричневую"
    if (name = "Фиолетовая")
        return "Фиолетовую"
    if (name = "Желтая")
        return "Желтую"
    if (name = "Оранжевая")
        return "Оранжевую"
    return ""
}

GetZoneInstrumental(name) {
    if (name = "Красная")
        return "Красным"
    if (name = "Бирюзовая")
        return "Бирюзовым"
    if (name = "Розовая")
        return "Розовым"
    if (name = "Зеленая")
        return "Зеленым"
    if (name = "Синяя")
        return "Синим"
    if (name = "Коричневая")
        return "Коричневым"
    if (name = "Фиолетовая")
        return "Фиолетовым"
    if (name = "Желтая")
        return "Желтым"
    if (name = "Оранжевая")
        return "Оранжевым"
    return ""
}

GetMapListForMode() {
    global Mode
    if (Mode = 2)
        return "Ghetto|Industrial Area|Vinewood|Sandy Shores|Farm|City|Mirror"
    return "Redwood|Windmill"
}

EnsureValidCurrentMapForMode() {
    global Mode, CurrentMap
    if (Mode = 2) {
        if (CurrentMap = "Redwood" || CurrentMap = "Windmill")
            CurrentMap := "Ghetto"
    } else {
        if !(CurrentMap = "Redwood" || CurrentMap = "Windmill")
            CurrentMap := "Redwood"
    }
}

UpdateZoneSettingsMapList() {
    global ZoneSettingsGUI_Created, CurrentMap
    if (!ZoneSettingsGUI_Created)
        return
    items := GetMapListForMode()
    GuiControl, 3:, MapChoice3, |%items%
    GuiControl, 3: ChooseString, MapChoice3, %CurrentMap%
}

StopAllZoneTimers() {
    global ZoneTimerRunning1, ZoneTimerRunning2, ZoneTimerRunning3, ZoneTimerRunning4
    global ZoneTimerRunning5, ZoneTimerRunning6, ZoneTimerRunning7, ZoneTimerRunning8, ZoneTimerRunning9
    global ZoneTimeRemaining1, ZoneTimeRemaining2, ZoneTimeRemaining3, ZoneTimeRemaining4
    global ZoneTimeRemaining5, ZoneTimeRemaining6, ZoneTimeRemaining7, ZoneTimeRemaining8, ZoneTimeRemaining9

    SetTimer, UpdateZone1, Off
    SetTimer, UpdateZone2, Off
    SetTimer, UpdateZone3, Off
    SetTimer, UpdateZone4, Off
    SetTimer, UpdateZone5, Off
    SetTimer, UpdateZone6, Off
    SetTimer, UpdateZone7, Off
    SetTimer, UpdateZone8, Off
    SetTimer, UpdateZone9, Off

    ZoneTimerRunning1 := ZoneTimerRunning2 := ZoneTimerRunning3 := ZoneTimerRunning4 := false
    ZoneTimerRunning5 := ZoneTimerRunning6 := ZoneTimerRunning7 := ZoneTimerRunning8 := false
    ZoneTimerRunning9 := false

    ZoneTimeRemaining1 := ZoneTimeRemaining2 := ZoneTimeRemaining3 := ZoneTimeRemaining4 := 300
    ZoneTimeRemaining5 := ZoneTimeRemaining6 := ZoneTimeRemaining7 := ZoneTimeRemaining8 := 300
    ZoneTimeRemaining9 := 300
}

UpdateZoneDisplayFromArrays() {
    global ZoneGUI_Created
    if (!ZoneGUI_Created)
        return

    global ZoneNom, ZoneHex, CurrentZoneCount, Mode, ZoneMarkedForDeletion, ZoneOriginalColors
    global ZoneTimeRemaining1, ZoneTimeRemaining2, ZoneTimeRemaining3, ZoneTimeRemaining4, ZoneTimeRemaining5
    global ZoneTimeRemaining6, ZoneTimeRemaining7, ZoneTimeRemaining8, ZoneTimeRemaining9

    UpdateZoneGuiSize(CurrentZoneCount)

    Loop, 9 {
        i := A_Index
        if (i <= CurrentZoneCount && ZoneNom.HasKey(i) && ZoneNom[i] != "") {
            if (ZoneMarkedForDeletion.HasKey(i) && ZoneMarkedForDeletion[i]) {
                originalColor := ZoneOriginalColors[i]
                if (originalColor = "")
                    originalColor := ZoneHex[i]
                if (originalColor = "")
                    originalColor := GetZoneHexByName(ZoneNom[i])
                
                GuiControl, 1: Show, KeyText%i%
                GuiControl, 1: Show, ZoneText%i%
                GuiControl, 1: +c%originalColor%, ZoneText%i%
                GuiControl, 1:, ZoneText%i%, % "✗ " . ZoneNom[i]
            } else {
                __zoneColor := ZoneHex[i]
                if (__zoneColor = "")
                    __zoneColor := GetZoneHexByName(ZoneNom[i])

                GuiControl, 1: Show, KeyText%i%
                GuiControl, 1: Show, ZoneText%i%
                GuiControl, 1: +c%__zoneColor%, ZoneText%i%

                if (Mode = 2) {
                    remaining := ZoneTimeRemaining%i%
                    minutes := Floor(remaining / 60)
                    seconds := Mod(remaining, 60)
                    timeFormatted := Format("{:01}:{:02}", minutes, seconds)
                    GuiControl, 1:, ZoneText%i%, % ZoneNom[i] . ": " . timeFormatted
                } else {
                    GuiControl, 1:, ZoneText%i%, % ZoneNom[i]
                }
            }
        } else {
            GuiControl, 1: Hide, KeyText%i%
            GuiControl, 1: Hide, ZoneText%i%
        }
    }
}

RemoveZoneAtSlot(idx) {
    global ZoneNom, ZoneGen, ZoneAcc, ZoneHex, CurrentZoneCount, ZoneMarkedForDeletion, ZoneOriginalColors
    global Zones_Pos, hZoneGui, ZoneTitleH, ZoneGuiHeight, ZoneGUI_Created
    
    ZoneMarkedForDeletion.Delete(idx)
    ZoneOriginalColors.Delete(idx)
    
    if (!ZoneNom.HasKey(idx) || ZoneNom[idx] = "")
        return

    oldZoneCount := CurrentZoneCount
    oldTotalHeight := ZoneGuiHeight + ZoneTitleH

    i := idx
    while (i < 9) {
        ZoneNom[i] := ZoneNom[i+1]
        ZoneGen[i] := ZoneGen[i+1]
        ZoneAcc[i] := ZoneAcc[i+1]
        ZoneHex[i] := ZoneHex[i+1]
        
        if (ZoneMarkedForDeletion.HasKey(i+1)) {
            ZoneMarkedForDeletion[i] := ZoneMarkedForDeletion[i+1]
            ZoneOriginalColors[i] := ZoneOriginalColors[i+1]
        } else {
            ZoneMarkedForDeletion.Delete(i)
            ZoneOriginalColors.Delete(i)
        }
        
        i++
    }

    ZoneNom[9] := ""
    ZoneGen[9] := ""
    ZoneAcc[9] := ""
    ZoneHex[9] := ""
    ZoneMarkedForDeletion.Delete(9)
    ZoneOriginalColors.Delete(9)

    if (CurrentZoneCount > 0)
        CurrentZoneCount -= 1

    if (CurrentZoneCount < 0)
        CurrentZoneCount := 0

    UpdateZoneDisplayFromArrays()
    
    if (ZoneGUI_Created && hZoneGui) {
        WinGetPos, winX, winY, winW, winH, ahk_id %hZoneGui%
        
        newTotalH := ZoneGuiHeight + ZoneTitleH
        
        heightDiff := oldTotalHeight - newTotalH
        
        if (Zones_Pos = 5 || Zones_Pos = 6) {
            if (heightDiff > 0) {
                newY := winY + heightDiff
                WinMove, ahk_id %hZoneGui%,, %winX%, %newY%, %winW%, %newTotalH%
            }
        }
    }
}

SaveVZZCurrentZones() {
    global Mode, CurrentMap, CurrentZoneCount, ZoneNom, iniFile
    
    if (Mode != 1)
        return

    __list := ""
    Loop, %CurrentZoneCount% {
        __z := ZoneNom[A_Index]
        if (__z = "")
            continue
        if (__list != "")
            __list .= "|"
        __list .= __z
    }

    if (__list = "")
        IniDelete, %iniFile%, VZZ_ZONES, %CurrentMap%
    else
        IniWrite, %__list%, %iniFile%, VZZ_ZONES, %CurrentMap%
}

ApplyMapZones(mapName) {
    global ZoneNom, ZoneGen, ZoneAcc, ZoneHex, Mode, ZoneGUI_Created, iniFile, hZoneGui
    global CurrentZoneCount, ZoneMarkedForDeletion, ZoneOriginalColors
    
    ZoneMarkedForDeletion := []
    ZoneOriginalColors := []
    
    ZoneNom := [], ZoneGen := [], ZoneAcc := [], ZoneHex := []

    if (Mode = 1) {
        if (mapName = "Windmill") {
            zones := ["Красная","Желтая","Зеленая","Розовая","Синяя","Оранжевая","Фиолетовая","Бирюзовая"]
        } else {
            zones := ["Красная","Коричневая","Желтая","Фиолетовая","Синяя","Бирюзовая","Розовая","Зеленая","Оранжевая"]
            mapName := "Redwood"
        }
    } else {
        if (mapName = "Ghetto")
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Коричневая","Фиолетовая","Желтая"]
        else if (mapName = "Industrial Area")
            zones := ["Красная","Бирюзовая","Зеленая","Синяя","Фиолетовая","Желтая"]
        else if (mapName = "Vinewood")
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Коричневая","Фиолетовая","Желтая","Оранжевая"]
        else if (mapName = "Sandy Shores")
            zones := ["Красная","Бирюзовая","Зеленая","Синяя","Фиолетовая","Желтая"]
        else if (mapName = "Farm")
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Коричневая"]
        else if (mapName = "City")
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Оранжевая"]
        else if (mapName = "Mirror")
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Желтая"]
        else
            zones := ["Красная","Бирюзовая","Розовая","Зеленая","Синяя","Коричневая","Фиолетовая","Желтая","Оранжевая"]
    }

    if (Mode = 1) {
        IniRead, __savedZones, %iniFile%, VZZ_ZONES, %mapName%, ERROR
        if (__savedZones != "ERROR" && __savedZones != "") {
            __allowed := {}
            for __i, __z in zones
                __allowed[__z] := 1

            __used := {}
            __new := []
            for __i, __z in StrSplit(__savedZones, "|") {
                if (__allowed.HasKey(__z) && !__used.HasKey(__z)) {
                    __new.Push(__z)
                    __used[__z] := 1
                }
            }

            if (__new.Length() > 0)
                zones := __new
            else
                IniDelete, %iniFile%, VZZ_ZONES, %mapName%
        }
    }

    CurrentZoneCount := zones.Length()

    StopAllZoneTimers()

    Loop, 9 {
        i := A_Index
        if (i <= zones.Length()) {
            n := zones[i]
            ZoneNom[i] := n
            ZoneGen[i] := GetZoneGen(n)
            ZoneAcc[i] := GetZoneAcc(n)
            ZoneHex[i] := GetZoneHexByName(n)
        } else {
            ZoneNom[i] := ""
            ZoneGen[i] := ""
            ZoneAcc[i] := ""
            ZoneHex[i] := ""
        }
    }

    UpdateZoneDisplayFromArrays()

    if (ZoneGUI_Created) {
        GuiControl, 1:, MapTitleText, %mapName%
        ForceGuiRedraw(hZoneGui)
    }
}

ZoneMapChanged:
    Gui, 1: Submit, NoHide
    CurrentMap := MapChoice
    EnsureValidCurrentMapForMode()
    IniWrite, %CurrentMap%, Settings.ini, Zones, Map
    if (ZoneGUI_Created)
        ApplyMapZones(CurrentMap)
return

ZoneMapChangedSettings:
    Gui, 3: Submit, NoHide
    CurrentMap := MapChoice3
    EnsureValidCurrentMapForMode()
    IniWrite, %CurrentMap%, Settings.ini, Zones, Map
    if (ZoneGUI_Created)
        ApplyMapZones(CurrentMap)
return

ToggleZoneGeneric(idx) {
    global ZoneNom, ZoneGen, ZoneAcc
    global ZoneTimerRunning1, ZoneTimerRunning2, ZoneTimerRunning3, ZoneTimerRunning4, ZoneTimerRunning5, ZoneTimerRunning6, ZoneTimerRunning7, ZoneTimerRunning8, ZoneTimerRunning9
    global ZoneTimeRemaining1, ZoneTimeRemaining2, ZoneTimeRemaining3, ZoneTimeRemaining4, ZoneTimeRemaining5, ZoneTimeRemaining6, ZoneTimeRemaining7, ZoneTimeRemaining8, ZoneTimeRemaining9
    global ZoneMarkedForDeletion, ZoneOriginalColors, ZoneGUI_Created, CurrentMap, Mode, ZoneHex

    if (!ZoneNom.HasKey(idx) || ZoneNom[idx] = "")
        return

    global Mode
    if (Mode = 1) {
        if (ZoneMarkedForDeletion.HasKey(idx) && ZoneMarkedForDeletion[idx]) {
            RemoveZoneAtSlot(idx)
            SaveVZZCurrentZones()
        } else {
            ZoneMarkedForDeletion[idx] := true
            ZoneOriginalColors[idx] := ZoneHex[idx]
            
            if (ZoneGUI_Created) {
                originalColor := ZoneHex[idx]
                if (originalColor = "")
                    originalColor := GetZoneHexByName(ZoneNom[idx])
                
                GuiControl, 1:, ZoneText%idx%, % "✗ " . ZoneNom[idx]
                GuiControl, 1: +c%originalColor%, ZoneText%idx%
            }
        }
        return
    }
    
    running := ZoneTimerRunning%idx%
    remaining := ZoneTimeRemaining%idx%

    timerLabel := "UpdateZone" . idx

    zGen := ZoneGen[idx]
    zAcc := ZoneAcc[idx]

    if (running) {
        ZoneTimerRunning%idx% := false

        SetTimer, %timerLabel%, Off

        Sleep, 300
        SendInput, {T}
        Sleep, 300
        minutes := Floor(remaining / 60)
        seconds := Mod(remaining, 60)
        timeFormatted := Format("{:01}:{:02}", minutes, seconds)
        SendInput, /cb Таймер %zGen% зоны приостановлен, оставшееся время в зоне: %timeFormatted%{Enter}
    } else {
        ZoneTimerRunning%idx% := true
        Sleep, 300
        SendInput, {T}
        Sleep, 300

        if (remaining = 300) {
            FormatTime, CurrentTime,, HH:mm:ss
            SendInput, /cb Вы заняли %zAcc% зону в %CurrentTime%{Enter}
            Sleep, 300
        } else {
            minutes := Floor(remaining / 60)
            seconds := Mod(remaining, 60)
            timeFormatted := Format("{:01}:{:02}", minutes, seconds)
            SendInput, /cb Таймер %zGen% зоны возобновлён, оставшееся время в зоне: %timeFormatted%{Enter}
            Sleep, 300
        }

        ZoneTimerRunning%idx% := true

        SetTimer, %timerLabel%, 1000
    }
}

ToggleZone1:
    ToggleZoneGeneric(1)
return

ToggleZone2:
    ToggleZoneGeneric(2)
return

ToggleZone3:
    ToggleZoneGeneric(3)
return

ToggleZone4:
    ToggleZoneGeneric(4)
return

ToggleZone5:
    ToggleZoneGeneric(5)
return

ToggleZone6:
    ToggleZoneGeneric(6)
return

ToggleZone7:
    ToggleZoneGeneric(7)
return

ToggleZone8:
    ToggleZoneGeneric(8)
return

ToggleZone9:
    ToggleZoneGeneric(9)
return

UpdateZoneTick(idx) {
    global ZoneNom
    global Mode
    if (Mode = 1)
        return
    remVar := "ZoneTimeRemaining" . idx
    runVar := "ZoneTimerRunning" . idx

    if (!ZoneNom.HasKey(idx) || ZoneNom[idx] = "")
        return

    remaining := %remVar%
    running   := %runVar%

    if (running) {
        if (remaining > 0) {
            remaining--
            %remVar% := remaining

            minutes := Floor(remaining / 60)
            seconds := Mod(remaining, 60)
            timeFormatted := Format("{:01}:{:02}", minutes, seconds)
            GuiControl, 1:, ZoneText%idx%, % ZoneNom[idx] . ": " . timeFormatted
        } else {
            %runVar% := false
            timerLabel := "UpdateZone" . idx
            SetTimer, %timerLabel%, Off
            GuiControl, 1:, ZoneText%idx%, % ZoneNom[idx] . ": 0:00"
        }
    }
}

UpdateZone1:
    UpdateZoneTick(1)
return

UpdateZone2:
    UpdateZoneTick(2)
return

UpdateZone3:
    UpdateZoneTick(3)
return

UpdateZone4:
    UpdateZoneTick(4)
return

UpdateZone5:
    UpdateZoneTick(5)
return

UpdateZone6:
    UpdateZoneTick(6)
return

UpdateZone7:
    UpdateZoneTick(7)
return

UpdateZone8:
    UpdateZoneTick(8)
return

UpdateZone9:
    UpdateZoneTick(9)
return

ResetAllZones:
    StopAllZoneTimers()
    if (Mode = 1) {
        IniDelete, %iniFile%, VZZ_ZONES, Redwood
        IniDelete, %iniFile%, VZZ_ZONES, Windmill
        ZoneMarkedForDeletion := []
        ZoneOriginalColors := []
    }
    ApplyMapZones(CurrentMap)
    
    if (ZoneGUI_Created && hZoneGui) {
        ZoneGuiHeight := 290
        
        TotalZoneH := ZoneGuiHeight + ZoneTitleH
        
        GetAnchoredPos(Zones_Pos, 230, TotalZoneH, zx, zy)
        
        WinMove, ahk_id %hZoneGui%,, %zx%, %zy%, 230, %TotalZoneH%
        
        UpdateZoneDisplayFromArrays()
    }

ClearWarzoneIDs:
    Loop, 6 {
        team := A_Index
        Loop, 4 {
            slot := A_Index
            controlName := "WZ_ID" . team . "_" . slot
            GuiControl, 4:, %controlName%, 
        }
        enControl := "WZ_En" . team
        GuiControl, 4:, %enControl%, 0
    }
    Gosub, SaveWarzoneSettings
return