Scriptname RugInvItemScript extends ObjectReference  

Import YHUtil

Quest property YoureHired auto
Activator property RugActivator auto
static property RugStatic auto
Message property DropMerchantobj auto

BusinessScript owningMerchant
ObjectReference playerRef
ObjectReference rugActivatorRef
ObjectReference rugStaticRef

Event OnInit()
    playerRef = (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef
EndEvent


Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Log("InvItemScript - We are in teh change container event.")
    if akOldContainer && !akNewContainer
        if (YoureHired as YoureHiredMerchantPropertiesScript).GetShowDropMessage()
            int answer = DropMerchantobj.Show()
            if answer
                akOldContainer.AddItem(self, 1, true)
            endIf
        endIf
    endIf
endEvent

Event OnEquipped(Actor akActor)
    GoToState("BusyState")
    Log(self + " You just activated the rug in your inventory!!!!")
    If (akActor == playerRef)
        If akActor.GetParentCell().IsInterior()
            owningMerchant.SleepLocationMarker.MoveTo(playerRef,0,0,1, abMatchRotation = false)
            rugActivatorRef = owningMerchant.SleepLocationMarker.PlaceAtMe(RugActivator, 1, true)
            ; rugActivatorRef.SetAngle(0.0,0.0,0.0)
            Log(self + " Just placed the activator: " + rugActivatorRef)
            Log(self + " teh rugStatic: " + rugStatic)
            rugStaticRef = owningMerchant.SleepLocationMarker.PlaceAtMe(RugStatic, 1, true)
            (rugActivatorRef as RugActivationScript).SetPlacedRug(rugStaticRef)
            (rugActivatorRef as RugActivationScript).SetOwningMerchant(owningMerchant)
            
            If (Game.GetPlayer().GetItemCount(Self))
                owningMerchant.ClearInventoryRug()
                Game.GetPlayer().RemoveItem(self)        
            EndIf
        EndIf
    EndIf
    GoToState("")
EndEvent

State BusyState
    Event OnEquipped(Actor akActor)
        Log(self + " Hello from the busy state") 
    EndEvent
EndState    

Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant
EndFunction