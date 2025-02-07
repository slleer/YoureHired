Scriptname YoureHiredMCM_StoreManagerPage  Hidden 
{Manages the stores/chest types and their setttins}

string Function GetPageName() global
    ; return "Store Manager"
    return "     "
EndFunction

Function RenderPage(YoureHiredMCM mcm, string page) global
    If (page == GetPageName())
        mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
        LEFT(mcm)
        mcm.SetCursorPosition(1)
        RIGHT(mcm)
    EndIf
EndFunction

Function LEFT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Stores")
    ; mcm.AddEmptyOption()

EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Store Options")
    ; mcm.AddEmptyOption()

EndFunction


Function OnSelect(YoureHiredMCM mcm, int optionId) global

EndFunction

Function OnHighlight(YoureHiredMCM mcm, int optionId) global

EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global

EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1) global
    if logType == 1
        YHUtil.Log("MCM StorePage - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MCM StorePage - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction