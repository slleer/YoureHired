Scriptname SellAllJunkScript extends ObjectReference  

Quest property YoureHired auto
FormList property JunkFilterFormList auto
bool changeDetected = false

Event OnActivate(ObjectReference akActionRef)
    if akActionRef == (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef
        Logger("We are in the OnActivate event")
        RegisterForMenu("ContainerMenu")
    endif
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if !changeDetected
        changeDetected = true
    endIf
    if JunkFilterFormList.Find(akBaseItem) > -1
        GoToState("DuplicateItem")
        RemoveItem(akBaseItem, aiItemCount, true, akSourceContainer)
        GoToState("")
        return
    endIf
    JunkFilterFormList.AddForm(akBaseItem)
    if aiItemCount > 1
        GoToState("DuplicateItem")
        RemoveItem(akBaseItem, (aiItemCount - 1), true, akSourceContainer)
        GoToState("")
    endIf
    Logger(akBaseItem.GetName() + " was added!")
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if !changeDetected
        changeDetected = true
    endIf

    if JunkFilterFormList.HasForm(akBaseItem)
        JunkFilterFormList.RemoveAddedForm(akBaseItem)
        Logger(akBaseItem.GetName() + " was removed!")
    endIf
EndEvent

State DuplicateItem
    Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    EndEvent
EndState


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

Event OnMenuClose(string menu)
    Logger("We are in the OnClose event")
    UnRegisterForMenu("ContainerMenu")
    if menu == "ContainerMenu"
        if changeDetected
            int handle = ModEvent.Create("aaslrYH_JunkFilterEvent")
            if handle
                ModEvent.Send(handle)
            endIf
        endIf
    endif
EndEvent