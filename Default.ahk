#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; KEYBOARD SHORTCUTS
; Parameters
global FromCtrlQ := false

; Conditions
nonAllowedCondition := !WinActive("ahk_class Shell_TrayWnd") && !WinActive("ahk_exe Nexus.exe") && !WinActive("ahk_exe Overwatch.exe")
nonAllowedWindow() => nonAllowedCondition
isAllowedEdge()    => WinActive("ahk_exe msedge.exe") && nonAllowedCondition
isAllowedCode()    => WinActive("ahk_exe code.exe") && nonAllowedCondition
isAllowedZen()     => WinActive("ahk_exe zen.exe") && nonAllowedCondition

; Global Shortcuts
; Ctrl + Q => Ctrl + W
#InputLevel 2
^q::{
    if nonAllowedWindow() {
        FromCtrlQ := true
        Send ("^w")
        SetTimer () => FromCtrlQ := false, -10
        return
    }
}
#InputLevel 1
^Up::{
    if nonAllowedWindow() {
        Send("{PgUp}")
    }
}
; Ctrl + Down => PgDn
^Down::{
    if nonAllowedWindow() {
        Send("{PgDn}")
    }
}
; Ctrl + N => Ctrl + T
^n::{
    if nonAllowedWindow() {
        Send("^t")
    }
}
; Ctrl + T => Ctrl + Shift + N
^t::{
    if nonAllowedWindow() {
        Send("^+n")
    }
}
; Ctrl + Shift + Up => Ctrl + Home
^+Up::{
    if nonAllowedWindow() {
        Send("^{Home}")
    }
}
; Ctrl + Shift + Down => Ctrl + End
^+Down::{
    if nonAllowedWindow() {
        Send("^{End}")
    }
}
; Ctrl + Alt + Left => Home
^!Left::{
    if nonAllowedWindow() {
        Send("{Home}")
    }
}
; Ctrl + Alt + Right => End
^!Right::{
    if nonAllowedWindow() {
        Send("{End}")
    }
}
; Ctrl + Alt + F => F11
^!f::{
    if nonAllowedWindow() {
        Send("{F11}")
    }
}
; Win + S => Shift + Win + S
#s::{
    if nonAllowedWindow() {
        Send("+#s")
    }
}
; Win + Q => Alt + F4
#q::{
    if nonAllowedWindow() {
        Send("!{F4}")
    }
}
; Win + Ctrl + Q => Win + Ctrl + F4
^#q::{
    if nonAllowedWindow() {
        Send("^#{F4}")
    }
}
; Win + Enter => Maximize
<#Enter::{
    if nonAllowedWindow() {
        WinMaximize("A")
    }
}
; Windows Key + M => Minimize
<#m::{
    if nonAllowedWindow() {
        WinMinimize("A")
    }
}
; FancyZones
^#f::{
    if nonAllowedWindow() {
        Send("+#f")
    }
}

; App Shortcuts
; Custom Ctrl+W logic
^w::{
    if (FromCtrlQ)
        return
    if WinActive("ahk_exe code.exe") {
        ; VSCode: Ctrl + W => Ctrl + Alt + W
        Send("^!w")
    }
    else if WinActive("ahk_exe msedge.exe") {
        ; Edge: Ctrl + W => Ctrl + Shift + ,
        Send("^+,")
    }
    else if WinActive("ahk_exe zen.exe") {
        ; Zen: Ctrl + W => Ctrl + Shift + W
        Send("^!w")
    }
    else {
        Send ("^w")
    }
    return
}

; Edge: Ctrl + Shift + D => Ctrl + Shift + K
^d::{
    if isAllowedEdge() {
        Send("^+k")
    }
}
; Edge: Ctrl + Shift + N => Ctrl + N
^+n::{
    if isAllowedEdge() {
        Send("^n")
    }
}
; Edge: Ctrl + Shift + Z => Ctrl + Shift + T
^+z::{
    if isAllowedEdge() {
        Send("^+t")
    }
}

;SAMEAPPCYCLE

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
  activeProcess := WinGetProcessName("A") ; Retrieves the name of the process that owns the active window
  activeWindowsIdList := WinGetList("ahk_exe " activeProcess,,,)
  sortedActiveWindowsIdList := SortNumArray(activeWindowsIdList)

  return sortedActiveWindowsIdList
}

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

; TERMINAL SCROLL FIX

A_MaxHotkeysPerInterval := 1000 

CheckActive()
{
    MouseGetPos , , &win
    return WinGetProcessName(win) == "WindowsTerminal.exe" || WinActive("ahk_exe WindowsTerminal.exe")
}

HotIf(hk=>CheckActive())

^WheelUp::return
^WheelDown::return

HotIf