#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon

; DEBUG HELPER
; #F1:: {
;     hwnd := WinActive("A")
;     class := WinGetClass(hwnd)
;     exe := WinGetProcessName(hwnd)
;     isBlocked := isBlockedWindow()
;     ToolTip("Window: " . exe . "`nClass: " . class . "`nBlocked: " . (isBlocked ? "Yes" : "No"), , , 1)
;     SetTimer () => ToolTip("", , , 1), -3000
; }

;################ KEYBOARD SHORTCUTS ################ KEYBOARD SHORTCUTS ################ KEYBOARD SHORTCUTS ################ KEYBOARD SHORTCUTS ################

global FromCtrlQ := false
global FromWinS := false
isBlockedWindow() {
    hwnd := WinActive("A")
    if !hwnd
        return false

    class := WinGetClass(hwnd)
    exe := WinGetProcessName(hwnd)

    blockedClasses := ["Shell_TrayWnd", "ThunderRT5Form"]
    blockedExes    := ["Nexus.exe", "Overwatch.exe", "SandFall-WinGDK-Shipping.exe", "SandFall.exe"]

    isBlocked := false
    for idx, blockedClass in blockedClasses {
        if (class == blockedClass) {
            isBlocked := true
            break
        }
    }
    
    if (!isBlocked) {
        for idx, blockedExe in blockedExes {
            if (exe == blockedExe) {
                isBlocked := true
                break
            }
        }
    }
    
    return isBlocked
}
isAllowedEdge()    => WinActive("ahk_exe msedge.exe") && !isBlockedWindow()
isAllowedCode()    => WinActive("ahk_exe code.exe") && !isBlockedWindow()
isAllowedZen()     => WinActive("ahk_exe zen.exe") && !isBlockedWindow()

; ## Global Shortcuts ##
#InputLevel 1

!Space:: {
    if WinActive("ahk_exe overwatch.exe") {
        return
    }
    else {
        Send("!{Space}")
    }
}

#HotIf isBlockedWindow()
; Win+Q => Alt+F4
#q::{
    Send("!{F4}")
}
; Win+Ctrl+Q => Win+Ctrl+F4
^#q::{
    Send("^#{F4}")
}
#HotIf

#HotIf !isBlockedWindow()
; RCtrl => Context Menu
RCtrl:: {
    Click("Right")
}
;Ctrl+Q => Ctrl+W
^q::{
    if WinActive("ahk_exe chatgpt.exe") {
        FromCtrlQ := true
        Send ("^+{Del}")
        SetTimer () => FromCtrlQ := false, -10
        return
    }
    else {
        FromCtrlQ := true
        Send ("^w")
        SetTimer () => FromCtrlQ := false, -10
        return
    }
}
; Ctrl+` => Ctrl+Shift+Tab
^`::{
    Send("^+{Tab}")
}
; Ctrl+Up => PgUp
^Up::{
    Send("{PgUp}")
}
; Ctrl+Down => PgDn
^Down::{
    Send("{PgDn}")
}
; Ctrl+N => Ctrl+T
^n::{
    if  WinActive("ahk_exe chatgpt.exe") {
        Send("^+o")
    }
    else {
        Send("^t")
    }
}
; Ctrl+T => Ctrl+Shift+N
^t::{
    Send("^+n")
}
; Ctrl+Shift+Up => Ctrl+Home
^+Up::{
    Send("^{Home}")
}
; Ctrl+Shift+Down => Ctrl+End
^+Down::{
    Send("^{End}")
}
; Ctrl+Alt+Left => Home
^!Left::{
    Send("{Home}")
}
; Ctrl+Alt+Right => End
^!Right::{
    Send("{End}")
}
; Ctrl+Alt+F => F11
^!f::{
    Send("{F11}")
}

; ## Windows Key Shortcuts ##

; Win+Mouse4=> Win+Left
#XButton1::{
        Send("#{Left}")
}
; Win+Mouse5=> Win+Right
#XButton2::{
        Send("#{Right}")
}
; Alt+Mouse4=> Ctrl+Win+Left
^#XButton1::{
        Send("^#{Left}")
}
; Alt+Mouse5=> Ctrl+Win+Right
^#XButton2::{
        Send("^#{Right}")
}
; Win+S => Shift+Win+S
#+s::{
    if (FromWinS) {
        return
    }
    else {
        Send("#{PrintScreen}")
    }
}
; Win+Shift+S => Shift+Win+S
#s::{
    FromWinS := true
    Send("+#s")
    SetTimer () => FromWinS := false, -10
}
; Win+Q => Alt+F4
#q::{
    Send("!{F4}")
}
; Win+Ctrl+Q => Win+Ctrl+F4
^#q::{
    Send("^#{F4}")
}
; Win+Enter => Maximize
<#Enter::
<#NumpadEnter::{
    WinMaximize("A")
}
; Win+M => Minimize
<#m::{
    WinMinimize("A")
}
; FancyZones
^#f::{
    Send("+#f")
}

; ## App Shortcuts ##

; Custom Ctrl+W logic
^w::{
    if (FromCtrlQ)
        return
    if WinActive("ahk_exe code.exe") {
        ; VSCode: Ctrl+W => Ctrl+Alt+W
        Send("^!w")
    }
    else if WinActive("ahk_exe msedge.exe") {
        ; Edge: Ctrl+W => Ctrl+Shift+,
        Send("^+,")
    }
    else if WinActive("ahk_exe zen.exe") {
        ; Zen: Ctrl+W => Ctrl+Alt+W
        Send("^!w")
    }
    else if WinActive("ahk_exe windowsterminal.exe") {
        ; Windows Terminal: Ctrl+W => Ctrl+Shift+W
        Send("^+w")
    }
    else if WinActive("ahk_exe chatgpt.exe") {
        ; ChatGPT: Ctrl+W => Ctrl+Shift+S
        Send("^+s")
    }
    else {
        Send("^w")
    }
    return
}
; Edge: Ctrl+Shift+D => Ctrl+Shift+K
^+d::{
    if isAllowedEdge() {
        Send("^+k")
    }
    else {
        Send("^+d")
    }
}
; Edge: Ctrl+Shift+N => Ctrl+N
^+n::{
    if isAllowedEdge() {
        Send("^n")
    }
    else {
        Send("^+n")
    }
}
; Edge & Zen: Ctrl+Shift+Z => Ctrl+Shift+T
^+z::{
    if isAllowedEdge() || isAllowedZen() {
        Send("^+t")
    }
    else {
        Send("^+z")
    }
}
#HotIf

;################ SAME APP CYCLE ################ SAME APP CYCLE ################ SAME APP CYCLE ################ SAME APP CYCLE ################
SendMode("Input")
SetWorkingDir(A_ScriptDir)

SortNumArray(arr) {
  str := ""
  for k, v in arr
    str .= v "`n"
  str := Sort(RTrim(str, "`n"), "N")
  return StrSplit(str, "`n")
}

getArrayValueIndex(arr, val) {
  Loop arr.Length {
    if (arr[A_Index] == val)
      return A_Index
  }
}

activateNextWindow(activeWindowsIdList) {
  currentWinId := WinGetID("A")
  currentIndex := getArrayValueIndex(activeWindowsIdList, currentWinId)

  if (currentIndex == activeWindowsIdList.Length) {
    nextIndex := 1
  }
  else {
    nextIndex := currentIndex + 1
  }

  try {
    WinActivate("ahk_id " activeWindowsIdList[nextIndex])
  } catch Error {
    clonedList := activeWindowsIdList.Clone()
    clonedList.RemoveAt(nextIndex)
    activateNextWindow(clonedList)
  }
}

activatePreviousWindow(activeWindowsIdList) {
  currentWinId := WinGetID("A")
  currentIndex := getArrayValueIndex(activeWindowsIdList, currentWinId)

  if (currentIndex == 1) {
    previousIndex := activeWindowsIdList.Length
  }
  else {
    previousIndex := currentIndex - 1
  }

  try {
    WinActivate("ahk_id " activeWindowsIdList[previousIndex])
  } catch Error {
    clonedList := activeWindowsIdList.Clone()
    clonedList.RemoveAt(previousIndex)
    activatePreviousWindow(clonedList)
  }
}

getSortedActiveWindowsIdList() {
  activeProcess := WinGetProcessName("A")
  activeWindowsIdList := WinGetList("ahk_exe " activeProcess,,,)
  sortedActiveWindowsIdList := SortNumArray(activeWindowsIdList)

  return sortedActiveWindowsIdList
}

#HotIf !isBlockedWindow()
!`:: {
  global
  activeWindowsIdList := getSortedActiveWindowsIdList()
  if (activeWindowsIdList.Length == 1) {
    return
  }
  activateNextWindow(activeWindowsIdList)
  return
}

+!`:: {
  global
  activeWindowsIdList := getSortedActiveWindowsIdList()
  if (activeWindowsIdList.Length == 1) {
    return
  }
  activatePreviousWindow(activeWindowsIdList)
  return
}
#HotIf

;################# TERMINAL SCROLL AND NEWLINE FIX ################# TERMINAL SCROLL AND NEWLINE FIX ################ TERMINAL SCROLL AND NEWLINE FIX ################ TERMINAL SCROLL AND NEWLINE FIX ################

A_MaxHotkeysPerInterval := 1000 

CheckActive()
{
    MouseGetPos , , &win
    return WinGetProcessName(win) == "WindowsTerminal.exe" || WinActive("ahk_exe WindowsTerminal.exe")
}

HotIf(hk=>CheckActive())

^WheelUp:: {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        return
    }
    else {
        Send("^{WheelUp}")
    }
}
^WheelDown:: {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        return
    }
    else {
        Send("^{WheelDown}")
    }
}
^Enter:: {
    if WinActive("ahk_exe WindowsTerminal.exe") {
        return
    }
    else {
        Send("^{Enter}")
    }
}

HotIf

;################ TRIGGER PEEK USING SPACEBAR ################ TRIGGER PEEK USING SPACEBAR ################ TRIGGER PEEK USING SPACEBAR ################ TRIGGER PEEK USING SPACEBAR ################

GetFocusedControlClassNN()
{
    GuiWindowHwnd := WinExist("A")
    if !GuiWindowHwnd
        return "NoWindowFound"
    FocusedControl := ControlGetFocus("ahk_id " GuiWindowHwnd)
    if !FocusedControl
        return "NoFocusedControl"
    return ControlGetClassNN(FocusedControl)
}

#HotIf WinActive("ahk_exe explorer.exe")
space::
{
    classnn:=GetFocusedControlClassNN()
    if (RegExMatch(classnn,"DirectUIHWND3"))
    {
        Send("{space}")
    }
    else if (!RegExMatch(classnn,"Microsoft.UI.Content.DesktopChildSiteBridge.*") and !RegExMatch(classnn,"Edit.*") )
    { 
        Send("!+{space}")
    }
    else
    {
        Send("{space}")
    }
    return
}
#HotIf

#HotIf WinActive("ahk_exe PowerToys.Peek.UI.exe")
space::^w
#HotIf
;EOF