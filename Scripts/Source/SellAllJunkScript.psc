Scriptname SellAllJunkScript extends ObjectReference  

Quest property YoureHired auto
FormList property JunkFilterFormList auto
bool changeDetected = false

Event OnActivate(ObjectReference akActionRef)
    if akActionRef == (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef
        Logger("We are in the OnActivate event")
    endif
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if !changeDetected
        changeDetected = true
    endIf
    ; update to add items to formlist
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if !changeDetected
        changeDetected = true
    endIf
    ; update to remove items from formlist
EndEvent


Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("SellAllJunkScritp - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("SellAllJunkScritp - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

Event OnClose(ObjectReference akActionRef)
    Logger("We are in the OnClose event")
    if akActionRef == (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef
        ;("aaslrYH_JunkFilterEvent", "OnJunkFilterChange")
        if changeDetected
            int handle = ModEvent.Create("aaslrYH_JunkFilterEvent")
            if handle
                ModEvent.Send(handle)
            endIf
        endIf
    endif
EndEvent