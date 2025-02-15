Scriptname InventortyItemScript extends ObjectReference  


Message property DropStallMessage auto
Quest property YoureHired auto
Activator property MerchantStandActivator auto
Static property XMarker auto


ObjectReference theMarker
bool showDropMessage = true

Import YHUtil


YoureHiredMerchantPropertiesScript property FixedProperties auto
Furniture property MerchantStandFurniture auto
Furniture property ChildMerchantStandFurniture auto
ObjectReference property MerchantStandRef auto
ObjectReference property ChildMerchantStandRef auto
Furniture property ChildChairMarker auto
; ObjectReference property xmarker auto
ObjectReference property mapMarker01 auto
ObjectReference property WriteLedgerIdle auto
ObjectReference property BrowseIdle auto
ObjectReference property SweepIdle auto
ObjectReference property WipeBrowIdle auto
GlobalVariable property Merchant_01_PackageEnable auto

bool isChild = false
float staticLength
float staticWidth
float furnLength
float furnWidth
Quest yhQuest
BusinessScript owningMerchant
ObjectReference standRef
Furniture merchantFurniture
ObjectReference newStall



Event OnInit()
    yhQuest = Quest.GetQuest("aaslrYoureHiredMainQuest")
    Log("INVENTORY: We are in the inventory items on init")
    standRef = MerchantStandRef
    merchantFurniture = MerchantStandFurniture
    ; Self.RegisterForMenu("InventoryMenu")
EndEvent

; Event OnUpdate()
;     YHUtil.Log(" We are in the update event and newStall is: " + newStall)
;     If (newStall)
;         YHUtil.Log("We have a merchant stall object!!! in the ivnentory on update")
;         ; newStall.Enable()
;     EndIf
; EndEvent

Function SetShowDropMessage(bool show)
    showDropMessage = show
EndFunction
bool Function GetShowDropMessage()
    return showDropMessage
EndFunction


Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant
    if merchant.GetActorReference().IsChild()
        standRef = ChildMerchantStandRef
    endIf
    staticLength = standRef.GetLength()
EndFunction

Function SetIsChild(bool child)
    isChild = child
    if isChild
        standRef = ChildMerchantStandRef
    endIf
    staticLength = standRef.GetLength()
EndFunction

bool locked = false
Event OnEquipped(Actor akActor)
    GoToState("BusyState")
    ; If (!locked)
    ;     locked = true
    If (akActor == FixedProperties.PlayerRef) 
        Log("about to see if gate is locked")
        If (owningMerchant.ProxyActor) 
            YHUtil.Log("We are in effect event" + XMarker)
            
            theMarker = akActor.PlaceAtMe(XMarker, 1)
            YHUtil.Log("staticLength: " + staticLength)
            theMarker.MoveTo(akActor, (staticLength * Math.Sin(theMarker.GetAngleZ())), (staticLength * Math.Cos(theMarker.GetAngleZ())), -5.0, true)
            theMarker.SetAngle(0.0,0.0,akActor.GetAngleZ())
            ObjectReference newActivator = theMarker.PlaceAtMe(MerchantStandActivator, 1, true, false)
            ; newActivator.SetAngle(0,0,newActivator.GetAngleZ())
            (newActivator as MerchantStallActivationScript).SetOwningMerchant(owningMerchant)
            (newActivator as MerchantStallActivationScript).PlaceRemainingStallObjects()            
            
            int index = (YoureHired as MerchantScript).GetMerchantAliasIndex(owningMerchant)
            GlobalVariable merchantPackage = (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[index]
            merchantPackage.SetValueInt(1)
            Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal(merchantPackage)
            YHUtil.Log("The global is: " + merchantPackage.GetValueInt())
            theMarker.Disable()
            theMarker.Delete()
            If (Game.GetPlayer().GetItemCount(Self))
                YHUtil.Log("The player has this item (self)")
                owningMerchant.ClearInventoryMerchantStall()
                Game.GetPlayer().RemoveItem(self)
            EndIf

            ; staticWidth = standRef.GetWidth()
            ; YHUtil.Log("dimension - static Length: " + staticLength)
            ; YHUtil.Log("dimension - static Width: " + staticWidth)
            ; YHUtil.Log("Moved the theMarker -")
            ; float x = (staticLength * Math.Sin(theMarker.GetAngleZ()))
            ; float y = (staticLength * Math.Cos(theMarker.GetAngleZ()))
            ; YHUtil.Log("X:" + x + ", Y:" + y)
            
            ; Set the marker and place the counterLeanIdle
            
            ; mapMarker01.MoveTo(theMarker)
            ; If (mapMarker01.IsEnabled())
            ;     mapMarker01.DisableNoWait()
            ; EndIf
            
            ; newStall = theMarker.PlaceAtMe(merchantFurniture, 1, true, false)
            ; int merchantIndex = (yhQuest as MerchantScript).GetMerchantAliasIndex(owningMerchant)
            ; YHUtil.Log("The index is: " + merchantIndex)
            ; newStall.SetAngle(0,0,newStall.GetAngleZ())
            ; furnLength = newStall.GetLength()
            ; furnWidth = newStall.GetWidth()
            ; YHUtil.Log("dimension - Idle Length: " + furnLength)
            ; YHUtil.Log("dimension - Idle Width: " + furnWidth)
            ; float mapMrkOffsetX = (125 + staticWidth) * Math.Sin(theMarker.GetAngleZ())
            ; float mapMrkOffsetY = (125 + staticWidth) * Math.Cos(theMarker.GetAngleZ())
            
            ; float x2 = (furnLength * Math.Sin(akActor.GetAngleZ()))
            ; float y2 = (furnLength * Math.Cos(akActor.GetAngleZ()))
            ; YHUtil.Log("x2: " + x2 + ", y2: " + y2)
            ; float diffX = (x2 - x) / 2
            ; float diffY = (y2 - y) / 2
            ; YHUtil.Log("dimension - diffX: " + diffX)
            ; YHUtil.Log("dimension - diffY: " + diffY)
            ; theMarker.MoveTo(theMarker, diffX * Math.Sin(akActor.GetAngleZ()), diffY * Math.Cos(akActor.GetAngleZ()), - 5.0, false)
            
            ; (newActivator as MerchantStallActivationScript).AddStandObject(newStall)
            ; (newActivator as MerchantStallActivationScript).AddStandObject(newActivator)
            ; if isChild
            ;     theMarker.MoveTo(mapMarker01)
            ;     theMarker.SetAngle(0,0,(mapMarker01.GetAngleZ() + 145))
            ;     theMarker.MoveTo(mapMarker01, 50 * Math.Sin(theMarker.GetAngleZ()), 50 * Math.Cos(theMarker.GetAngleZ()), 0, false)
            ;     ObjectReference chairMarkerRef = theMarker.PlaceAtMe(ChildChairMarker, 1, true, false)
            ;     (newActivator as MerchantStallActivationScript).AddStandObject(chairMarkerRef)
            ;     chairMarkerRef.SetAngle(0,0,(chairMarkerRef.GetAngleZ() - 180))
            ; endIf
            ; theMarker.MoveTo(mapMarker01, 20*Math.Sin(theMarker.GetAngleZ()), 20*Math.Cos(theMarker.GetAngleZ()), 0.0, true)
            
            ; ObjectReference newWipeBrowIdle = theMarker.PlaceAtMe(WipeBrowIdle.GetBaseObject(), 1, true, false)
            ; ; WipeBrowIdle.SetAngle(0.0,0.0,(theMarker.GetAngleZ() - 30))
            ; ; (newActivator as MerchantStallActivationScript).AddStandObject(newWipeBrowIdle)
            
            ; ObjectReference newWriteLedgerIdle = theMarker.PlaceAtMe(WriteLedgerIdle.GetBaseObject(), 1, true, false)
            ; newWriteLedgerIdle.MoveTo(theMarker, 60*Math.Cos(theMarker.GetAngleZ()), 60*Math.Sin(theMarker.GetAngleZ()), 0.0, true)
            ; ; WriteLedgerIdle.MoveTo(WriteLedgerIdle, 20*Math.Sin(theMarker.GetAngleZ()), 20*Math.Cos(theMarker.GetAngleZ()), 0.0, true)
            ; newWriteLedgerIdle.SetAngle(0.0,0.0,(theMarker.GetAngleZ() - 30))
            ; (newActivator as MerchantStallActivationScript).AddStandObject(newWriteLedgerIdle)
            
            ; theMarker.MoveTo(mapMarker01)
            ; theMarker.SetAngle(0.0,0.0,(mapMarker01.GetAngleZ() - 20))
            
            ; ObjectReference newSweepIdle = theMarker.PlaceAtMe(SweepIdle.GetBaseObject(), 1, true, false)
            ; newSweepIdle.MoveTo(theMarker, (130 + staticWidth) * Math.Sin(theMarker.GetAngleZ()), (130 + staticWidth) * Math.Cos(theMarker.GetAngleZ()), 0.0, true)
            ; newSweepIdle.SetAngle(0.0,0.0,newSweepIdle.GetAngleZ()+120)
            ; ; (newActivator as MerchantStallActivationScript).AddStandObject(newSweepIdle)
            
            ; theMarker.SetAngle(0.0,0.0,mapMarker01.GetAngleZ() + 15)
            
            ; ObjectReference newBrowseIdle = theMarker.PlaceAtMe(BrowseIdle.GetBaseObject(), 1, true, false)
            ; newBrowseIdle.MoveTo(theMarker, (175 + staticWidth) * Math.Sin(theMarker.GetAngleZ()), (175 + staticWidth) * Math.Cos(theMarker.GetAngleZ()), 0.0, true)
            ; newBrowseIdle.SetAngle(0.0,0.0,newBrowseIdle.GetAngleZ()+190)
            ; (newActivator as MerchantStallActivationScript).AddStandObject(newBrowseIdle)
            
            ; If (!theMarker.GetParentCell().IsInterior())
            ;     mapMarker01.Enable()
            ;     mapMarker01.AddToMap()
            ;     YHUtil.Log("ismapvisible:" + mapMarker01.IsMapMarkerVisible())
            ;     mapMarker01.EnableFastTravel()
            ; EndIf
            
            ; theMarker.MoveTo(akActor, abMatchRotation = false)
            ; ; mapMarker01.MoveTo(theMarker, mapMrkOffsetX, mapMrkOffsetY, 0.0, true)
            ; mapMarker01.SetAngle(0.0,0.0,akActor.GetAngleZ()+180)
            ; (newActivator as MerchantStallActivationScript).SetMapMarker(mapMarker01)
            ; YHUtil.Log("The stand was placed")
            ;     locked = false
            
            EndIf
        EndIf
            ; EndIf
    GoToState("")
EndEvent
    

state BusyState
    Event OnEquipped(Actor akActor)
        YHUtil.Log("Activated from busy state")
    EndEvent
endState


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)

    YHUtil.Log("We are in teh change container event.")
    if akOldContainer && !akNewContainer
        if ShowDropMessage
            int answer = DropStallMessage.Show()
            if answer > 0
                YHUtil.Log("You decided to keep the item.")
                akOldContainer.AddItem(self as form, 1, true)
            endIf
        endIf
    elseif akNewContainer && !akOldContainer
      Debug.Trace("We have been picked up!")
    else
        if akNewContainer == Game.GetPlayer()
            ; thisFaction = (akOldContainer as BusinessScript).YoureHiredFaction
            YHUtil.Log("we were bought or sold")
        endIf        
        Debug.Trace("We have switched containers!")
    endIf
endEvent