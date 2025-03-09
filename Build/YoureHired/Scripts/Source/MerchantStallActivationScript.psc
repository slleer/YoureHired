Scriptname MerchantStallActivationScript extends ObjectReference  

Import YHUtil

Quest property YoureHired auto
Furniture property MerchantStallFurniture auto
Furniture property ChildMerchantStallFurniture auto
ObjectReference property JunkContainer auto
ObjectReference property mapReturnMarker auto
ObjectReference property WriteLedgerIdle auto
ObjectReference property BrowseIdle auto
ObjectReference property SweepIdle auto
ObjectReference property WipeBrowIdle auto
ObjectReference property LookFarIdleMarker auto


MerchantStandPlacementThreadManager threadMgr
ObjectReference[] property StandObjectRefs auto
Message property ActivateMessage auto
ObjectReference mapMarker
BusinessScript owningMerchant
GlobalVariable merchantStallPackage
bool PickUp = false
bool stallPackageEnabled = false
int index = 0
int enableIndex

Event OnInit()
    StandObjectRefs = new ObjectReference[12]
    threadMgr = (YoureHired as MerchantStandPlacementThreadManager)
    Log(self + "Registering for self destruct")
    RegisterForModEvent("aaslrYH_StallSelfDestruct", "OnSelfDestructRequest")
    RegisterForModEvent("aaslrYH_CollectStallObjects", "OnStallObjPlacementComplete")
    ; RegisterforCrosshairRef()
EndEvent



; Event OnCrosshairRefChange(ObjectReference ref)
;     ; Log(self + " ref: " + ref)

;     if ref == self
;         string prompt = owningMerchant.GetActorName()
;         ; string prompt = "<font color='#808080'>" + "Manage:" + "</font>"
;         ; string label = owningMerchant.GetActorName()
;         ; Log(self + "label: " + label)
;         ; label += "'s " + UI.GetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.text")
;         string label = UI.GetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.text")
;         ; Log(self + "label: " + label)
;         ; ; label = StringUtil.Substring(label, StringUtil.Find(label,StringUtil.AsChar(13)))
;         ; Log(self + "label: " + label)
;         UI.SetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.htmlText", prompt + label)
;     endIf
; EndEvent


Event OnSelfDestructRequest(Form sender)
    Log(self + "We are in the self destruct")
    if (sender as Faction) == owningMerchant.YoureHiredFaction
        Log(self + "Calling destoy merchant stand")
        DestroyThisMerchantStand()
    endIf
EndEvent

bool locked = false
Event OnStallObjPlacementComplete(Form stallObj)
    while locked
        Utility.WaitMenuMode(0.05)
    EndWhile
    locked = true
    if (stallObj as ObjectReference).GetBaseObject() != BrowseIdle.GetBaseObject()
        Log(self + "Not the browseIdle")
        (stallObj as ObjectReference).SetFactionOwner(owningMerchant.YoureHiredFaction)
    endif
    if (stallObj as ObjectReference).GetBaseObject() == MerchantStallFurniture || (stallObj as ObjectReference).GetBaseObject() == ChildMerchantStallFurniture
        enableIndex = index
    endIf
    Log(self + "We recieved: " + stallObj + ", " + index)
    StandObjectRefs[index] = stallObj as ObjectReference
    index += 1
    locked = false
EndEvent

Event OnUpdate()
    threadMgr.wait_all()
    StandObjectRefs[enableIndex].Enable(false)
    EnableStallPackage()
    stallPackageEnabled = true
    Log(self + "We just waited for all the objs")
    UnregisterForModEvent("aaslrYH_CollectStallObjects")
EndEvent

Event OnActivate(ObjectReference akActionRef)
    GoToState("BusyState")
    Log(self + "In the activate script!!!")
    
    int enabled = 0
    int assigned = 0
    int merchantIndex = owningMerchant.GetMerchantIndex()
    if merchantIndex >= 0
        enabled = merchantStallPackage.GetValueInt()
    endIf
    if owningMerchant
        assigned = 1
    endIf
    int choice = ActivateMessage.Show(enabled, assigned)
    
    Log(self + "choice: " + choice)
    if choice
        if choice == 1
            If stallPackageEnabled
                DisableStallPackage()
            else
                EnableStallPackage()
            EndIf
        elseIf choice == 2
            JunkContainer.Activate(akActionRef)
        ; elseIf choice == 3
        ;     AssignNewOwner()
        endIf
        GoToState("")
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
        Log(self + "Activated from busy state")
    EndEvent
EndState

Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_StandSelfDestruct", "OnSelfDestructRequest")
    ; RegisterforCrosshairRef()
EndFunction

Function PlaceRemainingStallObjects()
    bool isChild = owningMerchant.GetActorReference().IsChild()
    Log(self + "The owning merchant is: " + owningMerchant.GetActorName() + ", they are a child: " + owningMerchant.GetActorReference().IsChild())
    threadMgr.PlaceStallAsync(self, isChild)
    ; if isChild
    ;     threadMgr.PlaceChairAsync()
    ; endIf
    threadMgr.PlaceMapMarkerAsync(mapMarker, isChild)
    threadMgr.PlaceIdleMarkerAsync(WipeBrowIdle, 20.0, 0.0, 0.0, false, false)
    if isChild
        threadMgr.PlaceIdleMarkerAsync(LookFarIdleMarker, 60.0, 0.0, -30.0, false, true)
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
        Log(self + "index: " + index)
    endWhile
    if mapMarker.IsEnabled()
        mapMarker.DisableNoWait()
        mapMarker.MoveTo(mapReturnMarker)
    EndIf
    index = 0
    if PickUp
        Log(self + " in pickup")
        ObjectReference invMerchantStandOwned = (YoureHired as YoureHiredMerchantPropertiesScript).GetInventoryStand()
        If (invMerchantStandOwned)
            (invMerchantStandOwned as InvItemScript).SetOwningMerchant(owningMerchant)
            invMerchantStandOwned.SetDisplayName(owningMerchant.GetActorName() + "'s Merchant Stall")
            owningMerchant.SetInventoryMerchantStall(invMerchantStandOwned)
            (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef.AddItem(invMerchantStandOwned, 1, true)
        EndIf
    endIf
    (YoureHired as YoureHiredMerchantPropertiesScript).RemoveStallActivatorFromList(self)
    self.Disable()
    self.Delete()
EndFunction

Function DisableStallPackage()
    merchantStallPackage.SetValueInt(0)
    stallPackageEnabled = false
    YoureHired.UpdateCurrentInstanceGlobal(merchantStallPackage)
    Log(self + "The global is: " + (merchantStallPackage.GetValueInt()))
EndFunction

Function EnableStallPackage()
    merchantStallPackage.SetValueInt(1)
    stallPackageEnabled = true
    YoureHired.UpdateCurrentInstanceGlobal(merchantStallPackage)
EndFunction

bool Function IsMerchantStallPackageEnabled()
    return stallPackageEnabled
EndFunction

Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant 
    (YoureHired as YoureHiredMerchantPropertiesScript).AddStallActivatorToList(self, owningMerchant)
    mapMarker = owningMerchant.MapMarker
    int merchantIndex = merchant.GetMerchantIndex()
    merchantStallPackage = (YoureHired as YoureHiredMerchantPropertiesScript).MerchantStall_PackageEnable[merchantIndex]
EndFunction

Function UpdateMapMarker(ObjectReference oldMarker)
    if oldMarker == mapMarker
        return
    endIf
    mapMarker.MoveTo(oldMarker, abMatchRotation = true)
    mapMarker.Enable()
    mapMarker.AddToMap()
    mapMarker.EnableFastTravel()
    oldMarker.MoveTo(mapReturnMarker)
    oldMarker.DisableNoWait()
EndFunction

BusinessScript Function GetOwningMerchant()
    return owningMerchant
EndFunction

Function AssignNewOwner()
    BusinessScript merchant = (YoureHired as YoureHiredMCM).MM_ThisMerchant
    if merchant && !merchant.GetMerchnatStandInventoryItem() && (!merchant.isAnimal)
        If (stallPackageEnabled)
            DisableStallPackage()
        EndIf
        (YoureHired as YoureHiredMerchantPropertiesScript).RemoveStallActivatorFromList(self)
        ObjectReference oldMapMarker = mapMarker
        SetOwningMerchant(merchant)
        UpdateMapMarker(oldMapMarker)
    endIf
EndFunction
