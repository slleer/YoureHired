Scriptname RugActivationScript extends ObjectReference  

Import YHUtil

Quest property YoureHired auto
static[] property RugChoicesArray auto
Message property ActivateRugMessage auto
Message property RugChoiceMessage auto
ObjectReference property JunkContainer auto

GlobalVariable enableSleepPackageGlobal
ObjectReference placedRug
BusinessScript owningMerchant
bool pickUp = false
bool sleepPackageEnabled = false

Event OnInit()
    RegisterForModEvent("aaslrYH_RugSelfDestruct", "OnSelfDestructRequest")
    ; RegisterforCrosshairRef()
EndEvent



; Event OnCrosshairRefChange(ObjectReference ref)
;     ; Log(self + " ref: " + ref)

;     if ref == self
;         string prompt = "<b>" + owningMerchant.GetActorName()
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

Event OnUpdate()
    int index = owningMerchant.GetMerchantIndex()
    enableSleepPackageGlobal = (YoureHired as YoureHiredMerchantPropertiesScript).MerchantSleep_PackageEnable[index]
    EnableSleepPackage()
EndEvent

Event OnSelfDestructRequest(Form sender)
    Log(self + "We are in the self destruct")
    if (sender as Faction) == owningMerchant.YoureHiredFaction
        Log(self + "Calling destoy merchant stand")
        DestroyThisRug()
    endIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
    GoToState("BusyState")
    
    int enabled = enableSleepPackageGlobal.GetValueInt()

    int choice = ActivateRugMessage.Show(enabled)

    if choice
        if choice == 1
            if sleepPackageEnabled
                DisableSleepPackage()
            else 
                EnableSleepPackage()
            endIf
            return
        elseIf choice == 2
            JunkContainer.Activate(akActionRef)
            return
        elseIf choice == 3
            int rugIndex = RugChoicesArray.Find(placedRug.GetBaseObject() as Static)
            int rugChoice = RugChoiceMessage.Show((rugIndex + 1))
            if rugChoice == 4
                GoToState("")
                return
            endIf
            if rugIndex == rugChoice
                GoToState("")
                return
            endIf
            SwitchRugDesigns(rugChoice)
        endIf
        GoToState("")
        return
    endIf

    pickUp = true
    DestroyThisRug()

    GoToState("")
EndEvent

State BusyState
    Event OnActivate(ObjectReference akActionRef)
    EndEvent
EndState


Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_RugSelfDestruct", "OnSelfDestructRequest")
EndFunction

Function SetPlacedRug(ObjectReference rug)
    placedRug = rug
EndFunction

Function SetOwningMerchant(BusinessScript merchant)
    owningMerchant = merchant 
    (YoureHired as YoureHiredMerchantPropertiesScript).AddRugActivatorToList(self, owningMerchant)
    RegisterForSingleUpdate(0.1)
EndFunction

Function DestroyThisRug()
    owningMerchant.SleepLocationMarker.MoveTo(owningMerchant.ChestXMarker)
    placedRug.Disable()
    placedRug.Delete()
    
    if pickUp
        pickUp = false
        ObjectReference newRugInvItem = (YoureHired as YoureHiredMerchantPropertiesScript).GetInvRugSleepMarker()
        If (newRugInvItem)
            (newRugInvItem as RugInvItemScript).SetOwningMerchant(owningMerchant)
            newRugInvItem.SetDisplayName(owningMerchant.GetActorName() + "'s Home Warming Rug")
            owningMerchant.SetInventoryMerchantStall(newRugInvItem)
            (YoureHired as YoureHiredMerchantPropertiesScript).PlayerRef.AddItem(newRugInvItem, 1, true)
        EndIf
    endIf
    DisableSleepPackage()
    (YoureHired as YoureHiredMerchantPropertiesScript).RemoveRugActivatorFromList(self)
    self.Disable()
    self.Delete()
EndFunction

Function DisableSleepPackage()
    enableSleepPackageGlobal.SetValueInt(0)
    sleepPackageEnabled = false
    YoureHired.UpdateCurrentInstanceGlobal(enableSleepPackageGlobal)
EndFunction

Function EnableSleepPackage()
    enableSleepPackageGlobal.SetValueInt(1)
    sleepPackageEnabled = true
    YoureHired.UpdateCurrentInstanceGlobal(enableSleepPackageGlobal)
EndFunction

bool Function IsSleepPackageEnabled()
    return sleepPackageEnabled
EndFunction

Function SwitchRugDesigns(int choice)
    ObjectReference tempRug = placedRug.PlaceAtMe(RugChoicesArray[choice], 1, true)
    placedRug.Disable()
    placedRug.Delete()
    placedRug = tempRug
EndFunction