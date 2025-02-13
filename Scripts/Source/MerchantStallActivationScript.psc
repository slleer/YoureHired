Scriptname MerchantStallActivationScript extends ObjectReference  

Quest property YoureHired auto
ObjectReference property JunkContainer auto

ObjectReference[] property StandObjectRefs auto
Message property ActivateMessage auto
BusinessScript owningMerchant
ObjectReference mapMarker
bool PickUp = false
int index = 0

Event OnInit()
    StandObjectRefs = new ObjectReference[12]
    (YoureHired as YoureHiredMerchantPropertiesScript).AddActivatorToList(self)
    Logger("Registering for self destruct")
    RegisterForModEvent("aaslrYH_StandSelfDestruct", "OnSelfDestructRequest")
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


Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_StandSelfDestruct", "OnSelfDestructRequest")
    ; RegisterforCrosshairRef()
EndFunction

Event OnSelfDestructRequest(Form sender)
    Logger("We are in the self destruct")
    if (sender as Faction) == owningMerchant.YoureHiredFaction
        Logger("Calling destoy merchant stand")
        DestroyThisMerchantStand()
    endIf
EndEvent

bool locked = false
Event OnActivate(ObjectReference akActionRef)
    Logger("In the activate script!!!")
    Logger(" going through the formlist")

    If !locked
        locked = true
    
        Logger("we are passed the locked gate")
        Logger("Form Count: " + index)
        int choice = ActivateMessage.Show()
        
        Logger("choice: " + choice)
        if choice
            if choice == 1
                DisableStallPackage()
            elseIf choice == 2
                JunkContainer.Activate(akActionRef)
            endIf
            locked = false
            return
        endIf
        PickUp = true
        ; PlayerRef.AddItem
        DestroyThisMerchantStand()
        
        PickUp = false
        locked = false
    EndIf
    
    ; USE BELOW FOR CHANGING THE ACTIVATION TEXT DYNAMICALLY 

EndEvent

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
        mapMarker.Disable()
    EndIf
    index = 0
    if PickUp
        Logger(" in pickup")
        ObjectReference invMerchantStandOwned = (YoureHired as YoureHiredMerchantPropertiesScript).GetInventoryStand()
        (invMerchantStandOwned as InventortyItemScript).SetOwningMerchant(owningMerchant)
        invMerchantStandOwned.SetDisplayName(owningMerchant.GetActorName() + "'s Merchant Stall")
        owningMerchant.SetInventoryMerchantStall(invMerchantStandOwned)
        (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef.AddItem(invMerchantStandOwned, 1, true)
    endIf
    (YoureHired as YoureHiredMerchantPropertiesScript).RemoveActivatorFromList(self)

EndFunction

Function DisableStallPackage()
    int merchantIndex = (YoureHired as MerchantScript).GetMerchantAliasIndex(owningMerchant)
    Logger("Merchant index: " + merchantIndex)
    (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex].SetValueInt(0)
    Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal((YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex])
    Logger("The global is: " + (YoureHired as YoureHiredMerchantPropertiesScript).Merchant_PackageEnable[merchantIndex].GetValueInt())
EndFunction

Function AddStandObject(ObjectReference thisObject)
    StandObjectRefs[index] = thisObject
    index += 1
EndFunction

Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant
EndFunction

BusinessScript Function GetOwningMerchant()
    return owningMerchant
EndFunction

Function SetMapMarker(ObjectReference marker)
    mapMarker = marker
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