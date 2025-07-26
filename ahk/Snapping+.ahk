#SingleInstance Force
#NoTrayIcon

<#m::
{
    If Not WinActive("ahk_class Shell_TrawWnd")
    {
        WinMinimize("A")
    }
}

<#Enter::
{
    If Not WinActive("ahk_class Shell_TrawWnd")
    {
        WinMaximize("A")
    }
}
