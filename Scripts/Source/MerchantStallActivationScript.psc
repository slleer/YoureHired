Scriptname MerchantStallActivationScript extends ObjectReference  

Quest property YoureHired auto
Furniture property MerchantStallFurniture auto
Furniture property ChildMerchantStallFurniture auto
ObjectReference property JunkContainer auto
ObjectReference property mapReturnMarker auto
ObjectReference property WriteLedgerIdle auto
ObjectReference property BrowseIdle auto
ObjectReference property SweepIdle auto
ObjectReference property WipeBrowIdle auto
ObjectReference property ChildPlayDirtIdle auto


MerchantStandPlacementThreadManager threadMgr
ObjectReference[] property StandObjectRefs auto
Message property ActivateMessage auto
ObjectReference mapMarker
BusinessScript owningMerchant
bool PickUp = false
int index = 0
int enableIndex

Event OnInit()
    StandObjectRefs = new ObjectReference[12]
    threadMgr = (YoureHired as MerchantStandPlacementThreadManager)
    Logger("Registering for self destruct")
    RegisterForModEvent("aaslrYH_StallSelfDestruct", "OnSelfDestructRequest")
    RegisterForModEvent("aaslrYH_CollectStallObjects", "OnStallObjPlacementComplete")
    ; RegisterforCrosshairRef()
EndEvent



; Event OnCrosshairRefChange(ObjectReference ref)
;     Logger("Self: " + self + ", ref: " + ref)

;     if ref == self
;         string prompt = "<font color='#808080'>" + "Manage:" + "</font>"
;         string label = owningMerchant.GetActorName()
;         logger("label: " + label)
;         label += "'s " + UI.GetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.text")
;         logger("label: " + label)
;         ; label = StringUtil.Substring(label, StringUtil.Find(label,StringUtil.AsChar(13)))
;         logger("label: " + label)
;         UI.SetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.htmlText", prompt + label)
;     endIf
; EndEvent


Event OnSelfDestructRequest(Form sender)
    Logger("We are in the self destruct")
    if (sender as Faction) == owningMerchant.YoureHiredFaction
        Logger("Calling destoy merchant stand")
        DestroyThisMerchantStand()
    endIf
EndEvent

bool locked = false
Event OnStallObjPlacementComplete(Form stallObj)
    while locked
        Utility.WaitMenuMode(0.1)
    EndWhile
    locked = true
    
    if (stallObj as ObjectReference).GetBaseObject() == MerchantStallFurniture || (stallObj as ObjectReference).GetBaseObject() == ChildMerchantStallFurniture
        enableIndex = index
    endIf
    Logger("We recieved: " + stallObj + ", " + index)
    StandObjectRefs[index] = stallObj as ObjectReference
    index += 1
    locked = false
EndEvent

Event OnUpdate()
    threadMgr.wait_all()
    Utility.wait(0.1)
    Logger("We just waited for all the objs")
    StandObjectRefs[enableIndex].Enable(false)
    StandObjectRefs[enableIndex].SetFactionOwner(owningMerchant.YoureHiredFaction)
    UnregisterForModEvent("aaslrYH_CollectStallObjects")
EndEvent

Event OnActivate(ObjectReference akActionRef)
    GoToState("BusyState")
    Logger("In the activate script!!!")
    Logger(" going through the formlist")
    
    Logger("Form Count: " + index)
    int choice = ActivateMessage.Show()
    
    Logger("choice: " + choice)
    if choice
        if choice == 1
            DisableStallPackage()
        elseIf choice == 2
            JunkContainer.Activate(akActionRef)
        elseIf choice == 3

        endIf
        return
    endIf
    PickUp = true
    ; PlayerRef.AddItem
    DestroyThisMerchantStand()
    
    PickUp = false
    
    GoToState("")
EndEvent

State BusyState
    Event OnActivate(ObjectReference akActionRef)
        Logger("Activated from busy state")
    EndEvent
EndState

Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_StandSelfDestruct", "OnSelfDestructRequest")
    ; RegisterforCrosshairRef()
EndFunction

Function PlaceRemainingStallObjects()
    bool isChild = owningMerchant.GetActorReference().IsChild()
    Logger("The owning merchant is: " + owningMerchant.GetActorName() + ", they are a child: " + owningMerchant.GetActorReference().IsChild())
    threadMgr.PlaceStallAsync(self, isChild)
    ; if isChild
    ;     threadMgr.PlaceChairAsync()
    ; endIf
    threadMgr.PlaceMapMarkerAsync(mapMarker, isChild)
    threadMgr.PlaceIdleMarkerAsync(WipeBrowIdle, 20.0, 0.0, 0.0, false, false)
    if isChild
        threadMgr.PlaceIdleMarkerAsync(ChildPlayDirtIdle, 60.0, 0.0, -30.0, false, true)
    else
        threadMgr.PlaceIdleMarkerAsync(WriteLedgerIdle, 60.0, 0.0, -30.0, false, true)
    endIf
    threadMgr.PlaceIdleMarkerAsync(SweepIdle, 130.0, -20.0, 120.0, true, false)
    threadMgr.PlaceIdleMarkerAsync(BrowseIdle, 175.0, 15.0, 190.0, true, false)
    RegisterForSingleUpdate(0.01)
EndFunction
; Function PlaceIdleMarkerAsync(ObjectReference idleMarker, float distance, float angle, float roation, bool useStallWidth, bool invert)

Function DestroyThisMerchantStand()
    DisableStallPackage()
    index = 0
    ObjectReference deleteMe = StandObjectRefs[index]
    while index < StandObjectRefs.Length && deleteMe
        StandObjectRefs[index] = NONE
        deleteMe.Disable()
        deleteMe.Delete()
        index += 1
        deleteMe = StandObjectRefs[index]
        Logger("index: " + index)
    endWhile
    if mapMarker.IsEnabled()
        mapMarker.DisableNoWait()
        mapMarker.MoveTo(mapReturnMarker)
    EndIf
    index = 0
    if PickUp
        Logger(" in pickup")
        ObjectReference invMerchantStandOwned = (YoureHired as YoureHiredMerchantPropertiesScript).GetInventoryStand()
        If (invMerchantStandOwned)
            (invMerchantStandOwned as InvItemScript).SetOwningMerchant(owningMerchant)
            invMerchantStandOwned.SetDisplayName(owningMerchant.GetActorName() + "'s Merchant Stall")
            owningMerchant.SetInventoryMerchantStall(invMerchantStandOwned)
        EndIf
        (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef.AddItem(invMerchantStandOwned, 1, true)
    endIf
    (YoureHired as YoureHiredMerchantPropertiesScript).RemoveActivatorFromList(self)
    self.Disable()
    self.Delete()
EndFunction

Function DisableStallPackage()
    int merchantIndex = (YoureHired as MerchantScript).GetMerchantAliasIndex(owningMerchant)
    Logger("Merchant index: " + merchantIndex)
    (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex].SetValueInt(0)
    Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal((YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex])
    Logger("The global is: " + (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex].GetValueInt())
EndFunction

Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant 
    (YoureHired as YoureHiredMerchantPropertiesScript).AddActivatorToList(self, owningMerchant)
    mapMarker = owningMerchant.MapMarker
EndFunction

BusinessScript Function GetOwningMerchant()
    return owningMerchant
EndFunction

Function AssignNewOwner(Actor akActionRef)
    BusinessScript merchant = (YoureHired as YoureHiredMCM).MM_ThisMerchant
    if merchant && !merchant.GetMerchnatStandInventoryItem()
        ; int merchantIndex = (YoureHired as MerchantScript).GetMerchantAliasIndex(merchant)
        (YoureHired as YoureHiredMerchantPropertiesScript).RemoveActivatorFromList(self)
        SetOwningMerchant(merchant)
        owningMerchant.SetInventoryMerchantStall(self)
        ; If (!(YoureHired as YoureHiredMerchantPropertiesScript).ActivatorsCurrent[merchantIndex])
        ; EndIf
    endIf
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("ActivatorScript - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("ActivatorScript - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction