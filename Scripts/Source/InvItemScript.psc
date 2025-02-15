Scriptname InvItemScript extends ObjectReference  
{Controls the merchant stand while in the players inventory}

Message property DropStallMessage auto
Quest property YoureHired auto
Activator property MerchantStallActivator auto
Activator property ChildMerchantStallActivator auto
Static property XMarker auto
Actor property PlayerRef auto

ObjectReference property MerchantStandRef auto
ObjectReference property ChildMerchantStandRef auto

BusinessScript owningMerchant
ObjectReference theMarker
Activator thisActivator
float staticLength

Import YHUtil

Event OnInit()
    Log("InvItemScript - We are in the inventory items on init")
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)

    Log("InvItemScript - We are in teh change container event.")
    if akOldContainer && !akNewContainer
        if (YoureHired as YoureHiredMerchantPropertiesScript).GetShowDropMessage()
            int answer = DropStallMessage.Show()
            if answer > 0
                Log("InvItemScript - You decided to keep the item.")
                akOldContainer.AddItem(self as form, 1, true)
            endIf
        endIf
    elseif akNewContainer && !akOldContainer
      Debug.Trace("We have been picked up!")
    else
        if akNewContainer == Game.GetPlayer()
            ; thisFaction = (akOldContainer as BusinessScript).YoureHiredFaction
            Log("InvItemScript - we were bought or sold")
        endIf        
        Debug.Trace("We have switched containers!")
    endIf
endEvent

Event OnEqupped(Actor akActor)
    Log(self + " in the empty state")
EndEvent

state BusyState
    Event OnEquipped(Actor akActor)
        Log("InvItemScript - Activated from busy state")
    EndEvent
endState

Auto State OrphanState
    Event OnEquipped(Actor akActor)
        GoToState("BusyState")
        if akActor == PlayerRef
            BusinessScript merchant = (YoureHired as YoureHiredMCM).MM_ThisMerchant
            if merchant && !merchant.GetMerchnatStandInventoryItem()
                int index = (YoureHired as MerchantScript).GetMerchantAliasIndex(merchant)
                If (!(YoureHired as YoureHiredMerchantPropertiesScript).ActivatorsCurrent[index])
                    SetOwningMerchant(merchant)
                    owningMerchant.SetInventoryMerchantStall(self)
                    GoToState("PlaceStallState")
                    Log(self + " Going back to the place stall state")
                    return
                EndIf
            endIf
        EndIf
        Log(self + " Going back to the orphan state")
        GoToState("OrphanState")
    EndEvent
EndState


State PlaceStallState
    Event OnEquipped(Actor akActor)
        GoToState("BusyState")
        If (akActor == PlayerRef) 
            Log("about to see if gate is locked")
            If (owningMerchant.ProxyActor) 
                Log("InvItemScript - We are in effect event" + XMarker)
                
                theMarker = akActor.PlaceAtMe(XMarker, 1)
                Log("InvItemScript - staticLength: " + staticLength)
                theMarker.MoveTo(akActor, (staticLength * Math.Sin(theMarker.GetAngleZ())), (staticLength * Math.Cos(theMarker.GetAngleZ())), -5.0, true)
                theMarker.SetAngle(0.0,0.0,akActor.GetAngleZ())
                ObjectReference newActivator = theMarker.PlaceAtMe(thisActivator, 1, true, false)
                ; newActivator.SetAngle(0,0,newActivator.GetAngleZ())
                (newActivator as MerchantStallActivationScript).SetOwningMerchant(owningMerchant)
                (newActivator as MerchantStallActivationScript).PlaceRemainingStallObjects()            
                
                int index = (YoureHired as MerchantScript).GetMerchantAliasIndex(owningMerchant)
                GlobalVariable merchantPackage = (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[index]
                merchantPackage.SetValueInt(1)
                Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal(merchantPackage)
                Log("InvItemScript - The global is: " + merchantPackage.GetValueInt())
                theMarker.Disable()
                theMarker.Delete()
                If (Game.GetPlayer().GetItemCount(Self))
                    Log("InvItemScript - The player has this item (self)")
                    owningMerchant.ClearInventoryMerchantStall()
                    Game.GetPlayer().RemoveItem(self)
                EndIf
    
                EndIf
            EndIf
        GoToState("PlaceStallState")
    EndEvent
    
EndState
Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant
    if merchant.GetActorReference().IsChild()
        staticLength = ChildMerchantStandRef.GetLength()
        thisActivator = ChildMerchantStallActivator
        GoToState("PlaceStallState")
        return
    endIf
    thisActivator = MerchantStallActivator
    staticLength = MerchantStandRef.GetLength()
    GoToState("PlaceStallState")
EndFunction

Function ClearOwningMerchant()
    owningMerchant = NONE
    GoToState("OrphanState")
EndFunction