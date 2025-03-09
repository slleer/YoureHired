Scriptname YoureHiredMCM_HomePage  Hidden 
{For managing the home page}

string Function GetPageName() global
    return ""
EndFunction

Function RenderPage(YoureHiredMCM mcm, string page) global
    If (page == GetPageName())
        mcm.SetTitleText("You're Hired! - Merchant Manager")
        ; mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
        ; LEFT(mcm)
        ; mcm.SetCursorPosition(1)
        ; RIGHT(mcm)
    EndIf
EndFunction

Function LEFT(YoureHiredMCM mcm) global
    ; mcm.AddEmptyOption()

EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    ; mcm.AddEmptyOption()

EndFunction


Function OnSelect(YoureHiredMCM mcm, int optionId) global

EndFunction

Function OnHighlight(YoureHiredMCM mcm, int optionId) global

EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global

EndFunction
