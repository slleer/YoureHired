Scriptname SellAllJunkScript extends ObjectReference  

Import YHUtil

Quest property YoureHired auto
FormList property JunkFilterFormList auto
bool changeDetected = false
int junkMap

Event OnActivate(ObjectReference akActionRef)
    if akActionRef == (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef
        Log(self + "We are in the OnActivate event")
        RegisterForMenu("ContainerMenu")
    endif
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    GoToState("DuplicateItem")
    
    if !changeDetected
        changeDetected = true
    endIf
    int formIndex = JunkFilterFormList.Find(akBaseItem)
    Log(self + "formIndex : " + formIndex + ", " + akBaseItem.GetName() + ", itemCount: " + aiItemCount)
    if formIndex > -1 
        RemoveItem(akBaseItem, aiItemCount, true, akSourceContainer)
        return
    endIf
    JunkFilterFormList.AddForm(akBaseItem)
    if aiItemCount > 1
        RemoveItem(akBaseItem, (aiItemCount - 1), true, akSourceContainer)
        Utility.WaitMenuMode(0.1)
    endIf
    Log(self + akBaseItem.GetName() + " was added!")
    
    GoToState("")
EndEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if !changeDetected
        changeDetected = true
    endIf
    
    if JunkFilterFormList.HasForm(akBaseItem)
        JunkFilterFormList.RemoveAddedForm(akBaseItem)
        Log(self + akBaseItem.GetName() + " was removed!")
    endIf
EndEvent

State DuplicateItem
    Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
        Log(self + "In the duplicateItemState")
    EndEvent
EndState


Event OnMenuClose(string menu)
    Log(self + "We are in the OnClose event")
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