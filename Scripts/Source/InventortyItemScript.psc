Scriptname InventortyItemScript extends ObjectReference  


Message property DropStallMessage auto
bool property ShowDropMessage = true auto
YoureHiredMerchantPropertiesScript property FixedProperties auto

Faction property thisFaction auto

Activator property MerchantStandActivator auto
Activator property ChildMerchantStandActivator auto
Furniture property MerchantStandFurniture auto
Furniture property ChildMerchantStandFurniture auto
Static property Chair auto
Furniture property ChildChairMarker auto
ObjectReference property xmarker auto
ObjectReference property mapMarker01 auto
ObjectReference property MerchantStandRef auto
ObjectReference property ChildMerchantStandRef auto
ObjectReference property WriteLedgerIdle auto
ObjectReference property BrowseIdle auto
ObjectReference property SweepIdle auto
ObjectReference property WipeBrowIdle auto
GlobalVariable property Merchant_01_PackageEnable auto

bool isChild = false
Quest yhQuest
BusinessScript owningMerchant
ObjectReference standRef
Furniture merchantFurniture


Event OnInit()
    yhQuest = Quest.GetQuest("aaslrYoureHiredMainQuest")
    YHUtil.Log("INVENTORY: We are in the inventory items on init")
    standRef = MerchantStandRef
    merchantFurniture = MerchantStandFurniture
    ; Self.RegisterForMenu("InventoryMenu")
EndEvent


Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant
EndFunction

Function SetIsChild(bool child)
    isChild = child
EndFunction

bool locked = false
Event OnEquipped(Actor akActor)
    If (akActor == Game.GetPlayer()) ; need to replace with property, probably
        ; If (owningMerchant && !FixedProperties.InventoryBusy)
        ; FixedProperties.InventoryBusy = true
        YHUtil.Log("about to see if gate is locked")
        If (owningMerchant.ProxyActor && !locked)
            locked = true
            YHUtil.Log("we are passed the locked gate")

            YHUtil.Log("We are in effect event")
            
            xmarker.MoveTo(akActor, abMatchRotation = true)
            xmarker.SetAngle(0.0,0.0,xmarker.GetAngleZ())
            
            if isChild
                standRef = ChildMerchantStandRef
                merchantFurniture = ChildMerchantStandFurniture
            endIf
            YHUtil.Log("Moved the xmarker -")
            float x = (standRef.GetLength() * Math.Sin(xmarker.GetAngleZ()))
            float y = (standRef.GetLength() * Math.Cos(xmarker.GetAngleZ()))
            YHUtil.Log("X:" + x + ", Y:" + y)
            
            ; Set the marker and place the counterLeanIdle
            
            mapMarker01.MoveTo(xmarker)
            If (mapMarker01.IsEnabled())
                mapMarker01.DisableNoWait()
            EndIf
            xmarker.MoveTo(akActor, (standRef.GetLength() * Math.Sin(xmarker.GetAngleZ())), (standRef.GetLength() * Math.Cos(xmarker.GetAngleZ())), -5.0, true)
            
            ObjectReference newStall = xmarker.PlaceAtMe(merchantFurniture, 1, true, false)
            ; int merchantIndex = (yhQuest as MerchantScript).GetMerchantAliasIndex(owningMerchant)
            ; YHUtil.Log("The index is: " + merchantIndex)
            FixedProperties.CounterLeanIdleRef = newStall
            newStall.SetAngle(0,0,newStall.GetAngleZ())
            YHUtil.Log("Idle Length: " + newStall.GetLength())
            YHUtil.Log("Idle Width: " + newStall.GetWidth())
            float mapMrkOffsetX = (125 + standRef.GetWidth()) * Math.Sin(xmarker.GetAngleZ())
            float mapMrkOffsetY = (125 + standRef.GetWidth()) * Math.Cos(xmarker.GetAngleZ())
            
            float x2 = (newStall.GetLength() * Math.Sin(akActor.GetAngleZ()))
            float y2 = (newStall.GetLength() * Math.Cos(akActor.GetAngleZ()))
            float diffX = (x2 - x) / 2
            float diffY = (y2 - y) / 2
            xmarker.MoveTo(xmarker, diffX * Math.Sin(akActor.GetAngleZ()), diffY * Math.Cos(akActor.GetAngleZ()), - 5.0, false)
            ObjectReference newActivator = newStall.PlaceAtMe(MerchantStandActivator, 1, true, false)
            FixedProperties.MerchantStand = newActivator
            newActivator.SetAngle(0,0,newActivator.GetAngleZ())
            (newActivator as MerchantStallActivationScript).AddStandObject(newStall)
            (newActivator as MerchantStallActivationScript).AddStandObject(newActivator)
            (newActivator as MerchantStallActivationScript).SetOwningMerchant(owningMerchant)
            if isChild
                xmarker.MoveTo(mapMarker01)
                xmarker.SetAngle(0,0,(mapMarker01.GetAngleZ() + 145))
                xmarker.MoveTo(mapMarker01, 50 * Math.Sin(xmarker.GetAngleZ()), 50 * Math.Cos(xmarker.GetAngleZ()), 0, false)
                ObjectReference chairRef = xmarker.PlaceAtMe(Chair, 1, true, false)
                (newActivator as MerchantStallActivationScript).AddStandObject(chairRef)
                chairRef.SetAngle(0,0,(chairRef.GetAngleZ() - 180))
                ObjectReference chairMarkerRef = xmarker.PlaceAtMe(ChildChairMarker, 1, true, false)
                (newActivator as MerchantStallActivationScript).AddStandObject(chairMarkerRef)
                chairMarkerRef.SetAngle(0,0,(chairMarkerRef.GetAngleZ() - 180))
            endIf
            xmarker.MoveTo(mapMarker01, 20*Math.Sin(xmarker.GetAngleZ()), 20*Math.Cos(xmarker.GetAngleZ()), 0.0, true)
            
            ObjectReference newWipeBrowIdle = xmarker.PlaceAtMe(WipeBrowIdle.GetBaseObject(), 1, true, false)
            newWipeBrowIdle.MoveTo(xmarker)
            ; WipeBrowIdle.SetAngle(0.0,0.0,(xmarker.GetAngleZ() - 30))
            (newActivator as MerchantStallActivationScript).AddStandObject(newWipeBrowIdle)
            
            ObjectReference newWriteLedgerIdle = xmarker.PlaceAtMe(WriteLedgerIdle.GetBaseObject(), 1, true, false)
            newWriteLedgerIdle.MoveTo(xmarker, 60*Math.Cos(xmarker.GetAngleZ()), 60*Math.Sin(xmarker.GetAngleZ()), 0.0, true)
            ; WriteLedgerIdle.MoveTo(WriteLedgerIdle, 20*Math.Sin(xmarker.GetAngleZ()), 20*Math.Cos(xmarker.GetAngleZ()), 0.0, true)
            newWriteLedgerIdle.SetAngle(0.0,0.0,(xmarker.GetAngleZ() - 30))
            (newActivator as MerchantStallActivationScript).AddStandObject(newWriteLedgerIdle)
            
            xmarker.MoveTo(mapMarker01)
            xmarker.SetAngle(0.0,0.0,(mapMarker01.GetAngleZ() - 20))
            
            ObjectReference newSweepIdle = xmarker.PlaceAtMe(SweepIdle.GetBaseObject(), 1, true, false)
            newSweepIdle.MoveTo(xmarker, (130 + standRef.GetWidth()) * Math.Sin(xmarker.GetAngleZ()), (130 + standRef.GetWidth()) * Math.Cos(xmarker.GetAngleZ()), 0.0, true)
            newSweepIdle.SetAngle(0.0,0.0,newSweepIdle.GetAngleZ()+120)
            (newActivator as MerchantStallActivationScript).AddStandObject(newSweepIdle)
            
            xmarker.SetAngle(0.0,0.0,mapMarker01.GetAngleZ() + 15)
            
            ObjectReference newBrowseIdle = xmarker.PlaceAtMe(BrowseIdle.GetBaseObject(), 1, true, false)
            newBrowseIdle.MoveTo(xmarker, (175 + standRef.GetWidth()) * Math.Sin(xmarker.GetAngleZ()), (175 + standRef.GetWidth()) * Math.Cos(xmarker.GetAngleZ()), 0.0, true)
            newBrowseIdle.SetAngle(0.0,0.0,newBrowseIdle.GetAngleZ()+190)
            (newActivator as MerchantStallActivationScript).AddStandObject(newBrowseIdle)
            
            If (!xmarker.GetParentCell().IsInterior())
                mapMarker01.Enable()
                mapMarker01.AddToMap()
                YHUtil.Log("ismapvisible:" + mapMarker01.IsMapMarkerVisible())
                mapMarker01.EnableFastTravel()
            EndIf
            
            xmarker.MoveTo(akActor, abMatchRotation = false)
            mapMarker01.MoveTo(xmarker, mapMrkOffsetX, mapMrkOffsetY, 0.0, true)
            mapMarker01.SetAngle(0.0,0.0,akActor.GetAngleZ()+180)
            (newActivator as MerchantStallActivationScript).SetMapMarker(mapMarker01)
            YHUtil.Log("The stand was placed")
            
            Merchant_01_PackageEnable.SetValueInt(1)
            Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal(Merchant_01_PackageEnable)
            YHUtil.Log("The global is: " + Merchant_01_PackageEnable.GetValueInt())
            If (Game.GetPlayer().GetItemCount(Self))
                YHUtil.Log("The player has this item (self)")
                owningMerchant.ClearInventoryMerchantStall()
                Game.GetPlayer().RemoveItem(self)
            EndIf
            locked = false
        EndIf
    EndIf
EndEvent
    


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