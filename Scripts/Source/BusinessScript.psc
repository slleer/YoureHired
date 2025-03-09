Scriptname BusinessScript extends ReferenceAlias
{This manages actors after they've been added to You're Hired Merchant factions.}

import YHUtil

Faction property YoureHiredFaction auto
Quest property YoureHired auto
YoureHiredMerchantPropertiesScript property FixedProperties auto
ActorBase property  ProxyBase_Male auto
ActorBase property ProxyBase_Female auto
ActorBase property ProxyBase_Animal auto
ObjectReference property ChestXMarker auto
ObjectReference property SleepLocationMarker auto
ObjectReference property MapMarker auto
bool property isAnimal = false auto

Actor property ProxyActor auto
YoureHiredMerchantChestScript property MerchantChestScript auto


string _actorName
string _currentChestType
bool isVanillaMerchant = false
ObjectReference invMerchantStandOwned
ObjectReference invRugSleepMarkerOwned
Actor playerRef

int jobMerchantFactionRank = 0
int merchantIndex = -1

string blacksmithChestText = "Blacksmith"
string potionsChestText = "Apothecary"
string magicChestText = "Magic"
string miscChestText = "General Goods"
string innKeeperChestText = "Innkeeper"
string tailorJewelerChestText = "Tailor"
; Used for adding voices types to tailorJeweler chest types
string jewelerChestText = "Jeweler"
string tailorChestText = "Tailor"

Event OnInit()
    Log(self + "In OnInit")
    playerRef = FixedProperties.PlayerRef
EndEvent

Event OnReset()

    Log(self + "We have been reset")
EndEvent

Event OnDeath(Actor akKiller)
    If (GetActorReference().IsDead())
        string deadMerchant = GetActorName()
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, true)
    EndIf
EndEvent

Event OnUnload()
    Log(self + " In OnUnload ")
    If (GetActorReference().IsDisabled())
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, false)
        return
    EndIf
    If (GetActorReference().IsDeleted())
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, false)
        return
    EndIf
    ProxyActorFactionRecheck()
EndEvent

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
    if akTarget.GetDistance(akViewer) < 384 ; approx 18 feet (128 = 6')
        int stage = (merchantIndex + 1) * 10
        YoureHired.SetObjectiveCompleted(stage, true)
        YoureHired.SetObjectiveDisplayed(stage, false)
        YoureHired.SetStage(0)
        (YoureHired as YoureHiredMCM).MM_LocateMerchant = false
        return
    endIf
    RegisterForSingleLOSGain(playerRef, GetActorReference())
EndEvent

; Empty state declaration
;change the faction's container to chestType
Function ChangeChestType(string chestType)
    Log(self + "In the empty state")
EndFunction

Function LoadGameMaintenance()
    YoureHiredFaction.SetMerchantContainer(MerchantChestScript)
    ProxyActor.GetBaseObject().SetName(_actorName)       
    ProxyActor.SetRace(GetActorReference().GetRace())
EndFunction

Function SetMerchantIndex(int index)
    merchantIndex = index
EndFunction

int Function GetMerchantIndex()
    return merchantIndex
EndFunction

bool Function GetIsVanillaMerchant()
    return isVanillaMerchant
endFunction

int Function GetJobMerchantFactionRank()
    return jobMerchantFactionRank
EndFunction

Function SetJobMerchantFactionRank(int rank)
    jobMerchantFactionRank = rank
EndFunction

;State to start in so don't delete the bank chest
Auto State BlankChestState
    ;change the faction's container to chestType.
    Function ChangeChestType(string chestType)
        AddLineBreakWithText(self + " in default state change chest type function ")
        Form newContainer
        if chestType == "Random"
            newContainer = FixedProperties.GetRandomChestType()
            chestType = newContainer.GetName()
        else
            newContainer = FixedProperties.getChestBase(chestType)
        endIf
        ObjectReference newContainerRef = ChestXMarker.PlaceAtMe(newContainer, abForcePersist = true)
        Log(self + "newContainerRef: " + newContainerRef)
        MerchantChestScript = (newContainerRef as YoureHiredMerchantChestScript)
        _currentChestType = chestType
        MerchantChestScript.ProxyActor = ProxyActor
        
        If (newContainer)
            int moreGold = 175 + Utility.RandomInt()
            newContainerRef.AddItem(FixedProperties.gold, moreGold, true)
            YoureHiredFaction.SetMerchantContainer(newContainerRef)
            newContainerRef.SetActorOwner(ProxyActor.GetBaseObject() as ActorBase)
            addJobTypeFaction(chestType)
        EndIf
        GoToState("DisposeChestState")
    EndFunction
EndState
;State to move to after inialization so we can take disable/delete added containers
State DisposeChestState
    ;change the faction's container and disable/delete the previous one
    Function ChangeChestType(string chestType)
        AddLineBreakWithText(self + " in Dispose state change chest type function, chestType: " + chestType)
        Form newContainer
        if chestType == "Random"
            newContainer = FixedProperties.GetRandomChestType()
            chestType =newContainer.GetName()
        else
            newContainer = FixedProperties.getChestBase(chestType)
        endIf
        ObjectReference oldContainer = YoureHiredFaction.GetMerchantContainer()
        string oldChestType = oldContainer.GetDisplayName()
        if oldChestType != chestType
            ObjectReference newContainerRef = ChestXMarker.PlaceAtMe(newContainer, abForcePersist = true)
            MerchantChestScript.StopListeningAll()
            MerchantChestScript = (newContainerRef as YoureHiredMerchantChestScript)
            _currentChestType = chestType
            MerchantChestScript.ProxyActor = ProxyActor

            If (newContainer)
                
                int moreGold = 175 + Utility.RandomInt()
                newContainerRef.AddItem(FixedProperties.gold, moreGold, true)
                YoureHiredFaction.SetMerchantContainer(newContainerRef)
                newContainerRef.SetActorOwner(ProxyActor.GetBaseObject() as ActorBase)
                
                RemoveJobTypeFaction(oldChestType)
                
                AddJobTypeFaction(chestType)
                
                oldContainer.DisableNoWait()
                oldContainer.Delete()
            EndIf
        endIf
    EndFunction
EndState

;retrieves the actor's name from the reference
string Function GetActorName()
    return _actorName
EndFunction

int Function LocateMerchant(bool locate = true)
    int stage = (merchantIndex + 1) * 10
    if  locate
        YoureHired.SetObjectiveDisplayed(stage, true, true)
        YoureHired.SetStage(stage)
        RegisterForSingleLOSGain(playerRef, GetActorReference())
    else
        YoureHired.SetObjectiveDisplayed(stage, false)
        YoureHired.SetStage(0)
        UnregisterForLOS(playerRef, GetActorReference())
    endIf
    return stage
EndFunction

;retrieves the current chest type
string Function GetChestType()
    return _currentChestType
EndFunction

;resets the faction's container to the blankchest
Function ResetFactionContainer()
    ObjectReference oldContainer = YoureHiredFaction.GetMerchantContainer()
    YoureHiredFaction.SetMerchantContainer(FixedProperties.BlankChestRef)
    MerchantChestScript.StopListeningAll()
    MerchantChestScript = NONE
    _currentChestType = ""
    oldContainer.DisableNoWait()
    oldContainer.Delete()
    GoToState("BlankChestState")
EndFunction
;Fills alias with actor and instantiate proxy
bool Function FillAliasWithActor(Actor akMerchant)
    bool success = self.ForceRefIfEmpty(akMerchant)
    if success
        _actorName = akMerchant.GetBaseObject().GetName()
        FillProxy(akMerchant)
        ChangeChestType("Random")

        If (!isAnimal)
            invMerchantStandOwned = FixedProperties.GetInventoryStand()
            invMerchantStandOwned.SetDisplayName(_actorName + "'s Merchant Stall")
            (invMerchantStandOwned as InvItemScript).SetOwningMerchant(self)
            ProxyActor.AddItem(invMerchantStandOwned,1,true)
            
            invRugSleepMarkerOwned = FixedProperties.GetInvRugSleepMarker()
            invRugSleepMarkerOwned.SetDisplayName(_actorName + "'s Home Warming Rug")
            (invRugSleepMarkerOwned as RugInvItemScript).SetOwningMerchant(self)
            ProxyActor.AddItem(invRugSleepMarkerOwned, 1, true)

        EndIf

        if akMerchant.IsInFaction(FixedProperties.JobMerchantFaction)
            isVanillaMerchant = true
            If !(YoureHired as YoureHiredMCM).S_DoubleMerchantEnabled
                jobMerchantFactionRank = akMerchant.GetFactionRank(FixedProperties.JobMerchantFaction)
                akMerchant.RemoveFromFaction(FixedProperties.JobMerchantFaction)
            EndIf
        endIf
        

    endIf
    return success
EndFunction
;Clears the actor from the RefAlias and adds any factions that might have been cleared by accident
Function ClearActorFromAlias()
    ResetFactionContainer()
    _actorName = ""
    ResetProxy()
    isAnimal = false
    SendRugSelfDestruct()
    SendStallSelfDestruct()
    PromoteToFence(true)
    ClearJobTypeFactions()
    if isVanillaMerchant
        If !(YoureHired as YoureHiredMCM).S_DoubleMerchantEnabled
            GetActorReference().AddToFaction(FixedProperties.JobMerchantFaction)    
            GetActorReference().SetFactionRank(FixedProperties.JobMerchantFaction, jobMerchantFactionRank)
        EndIf
        isVanillaMerchant = false
    endIf
    self.Clear()
EndFunction
;creates an instance of the proxy actor and names it after the new merchant
Function FillProxy(Actor proxy)
    int sex = proxy.GetActorBase().GetSex()
    If (sex == 0)
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Male, abForcePersist = true) as Actor
    ElseIf (sex == 1)
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Female, abForcePersist = true) as Actor
    Else
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Animal, abForcePersist = true) as Actor
    EndIf
    ProxyActor.SetRace(proxy.GetRace())
    ProxyActor.EnableAI(false)
    
    ProxyActor.GetBaseObject().SetName(_actorName)
    If (FixedProperties.aaslrAnimalVoiceTypes.HasForm(proxy.GetVoiceType()))
        isAnimal = true
    EndIf
    Log(self + "Placed and moved the proxy actor")
    ProxyActorFactionRecheck()
EndFunction
;Disables and deletes the proxy instance
Function ResetProxy()
    ProxyActor.RemoveFromAllFactions()
    ProxyActor.DisableNoWait()
    ProxyActor.Delete()
    ProxyActor = NONE
EndFunction

; Clears the job type factions added for merchant
Function ClearJobTypeFactions()
    Actor merchant = self.GetActorReference()
    int numFactions = merchant.GetFactions(-123,123).Length
    bool success
    Faction thisFaction
    while numFactions
        numFactions -= 1
        thisFaction = merchant.GetFactions(-123,123)[numFactions]
        If (FixedProperties.JobTypesFactionList.HasForm(thisFaction as Form))
            success = self.TryToRemoveFromFaction(thisFaction)
        EndIf
        If (FixedProperties.aaslrYoureHiredVoiceTypeJobFactionsFormList.HasForm(thisFaction as Form))
            success = self.TryToRemoveFromFaction(thisFaction)
        EndIf
    endWhile
EndFunction

ObjectReference Function GetMerchnatStandInventoryItem()
    return invMerchantStandOwned
EndFunction

Function SendRugSelfDestruct()
    if invRugSleepMarkerOwned
        playerRef.RemoveItem(invRugSleepMarkerOwned, 1)
        invRugSleepMarkerOwned = NONE
        return
    endIf
    int handle = ModEvent.Create("aaslrYH_RugSelfDestruct")
    if handle
        ModEvent.PushForm(handle, YoureHiredFaction)
        ModEvent.Send(handle)
    endIf
EndFunction

Function SendStallSelfDestruct()
    If invMerchantStandOwned
        ; invMerchantStandOwned.SetDisplayName("Merchant Stall")
        ; (invMerchantStandOwned as InvItemScript).ClearOwningMerchant()
        playerRef.RemoveItem(invMerchantStandOwned, 1)
        invMerchantStandOwned = NONE
        return
    EndIf
    if FixedProperties.IsDestroyOnRemoval()
        int handle = ModEvent.Create("aaslrYH_StallSelfDestruct")
        if handle
            ModEvent.PushForm(handle, YoureHiredFaction)
            ModEvent.Send(handle)
        endIf
        return
    else
        MapMarker.Disable()
        FixedProperties.MerchantStall_PackageEnable[merchantIndex].SetValueInt(0)
        YoureHired.UpdateCurrentInstanceGlobal(FixedProperties.MerchantStall_PackageEnable[merchantIndex])
    endIf
EndFunction

Function ClearInventoryMerchantStall()
    invMerchantStandOwned = NONE
EndFunction

Function ClearInventoryRug()
    invRugSleepMarkerOwned = NONE
EndFunction

Function SetInventoryRug(ObjectReference newRug)
    invRugSleepMarkerOwned = newRug
    invRugSleepMarkerOwned.SetDisplayName(_actorName + "'s Home Warming Rug")
EndFunction

Function SetInventoryMerchantStall(ObjectReference newStall)
    invMerchantStandOwned = newStall
    invMerchantStandOwned.SetDisplayName(_actorName + "'s Merchant Stall")
EndFunction

; Sets faction to accept stolen goods or not
Function PromoteToFence(bool setDefault = false)
    AddLineBreakWithText(self + "In Promote to fence")
    if setDefault
        YoureHiredFaction.SetOnlyBuysStolenItems(false)
        RemoveJobTypeFaction("Fence")
    else
        bool fenceState = !YoureHiredFaction.OnlyBuysStolenItems()
        YoureHiredFaction.SetOnlyBuysStolenItems(fenceState)
        
        if FixedProperties.aaslrVoicesFence.HasForm(self.GetActorReference().GetVoiceType() as Form)
            If (fenceState)
                Self.TryToAddToFaction(FixedProperties.YoureHiredFenceFaction)
            Else
                Self.TryToRemoveFromFaction(FixedProperties.YoureHiredFenceFaction)
            EndIf
        endIf

    endIf
EndFunction

Function ProxyActorFactionRecheck()
    Faction[] proxyFactions = GetActorReference().GetFactions(-120,120)
    int index = 0
    While index < proxyFactions.Length
        If (playerRef.IsInFaction(proxyFactions[index]))
            ProxyActor.AddToFaction(proxyFactions[index])
            ProxyActor.SetFactionRank((proxyFactions[index]), GetActorReference().GetFactionRank(proxyFactions[index]))
        EndIf
        index += 1
    EndWhile
    int relationshipRank = GetActorReference().GetRelationshipRank(playerRef)
    ProxyActor.SetRelationshipRank(playerRef, relationshipRank)
    Log(self + "Added proxy to necessary factions and set relationship rank")
EndFunction


;Remove the jobTypeFaction that matches the passed in string
Function RemoveJobTypeFaction(string chestType)
    Log(self + "Chest type in removeJobTypeFaction: " + chestType)
    bool success
    bool voiceAdded
    Faction oldFaction = FixedProperties.GetFactionByString(chestType)
    success = self.TryToRemoveFromFaction(oldFaction)
    oldFaction = NONE
    if chestType == blacksmithChestText
        If FixedProperties.aaslrVoicesBlacksmith.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    elseIf chestType == potionsChestText
        If FixedProperties.aaslrVoicesApothecary.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    elseif chestType == innKeeperChestText
        If FixedProperties.aaslrVoicesTownInnkeeper.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    elseif chestType == miscChestText
        If FixedProperties.aaslrVoicesMisc.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    elseif chestType == magicChestText
        If FixedProperties.aaslrVoicesMagic.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    elseif chestType == tailorJewelerChestText
        If FixedProperties.aaslrVoicesTailor.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(tailorChestText)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
        If FixedProperties.aaslrVoicesJeweler.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(jewelerChestText)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
        EndIf
    endIf
    
EndFunction

Function AddJobTypeFaction(string chestType)
    Log(self + "Chest type in AddJobTypeFaction: " + chestType)
    bool success
    bool voiceAdded
    Faction newFaction = FixedProperties.GetFactionByString(chestType)
    success =  self.TryToAddToFaction(newFaction)
    newFaction = NONE
    if chestType == blacksmithChestText
        Log(self + chestType + " " + blacksmithChestText)
        If FixedProperties.aaslrVoicesBlacksmith.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    elseIf chestType == potionsChestText
        Log(self + chestType + " " + potionsChestText)
        If FixedProperties.aaslrVoicesApothecary.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    elseif chestType == innKeeperChestText
        Log(self + chestType + " " + innKeeperChestText)
        If FixedProperties.aaslrVoicesTownInnkeeper.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    elseif chestType == miscChestText
        Log(self + chestType + " " + miscChestText)
        If FixedProperties.aaslrVoicesMisc.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    elseif chestType == magicChestText
        Log(self + chestType + " " + magicChestText)
        If FixedProperties.aaslrVoicesMagic.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    elseif chestType == tailorJewelerChestText
        Log(self + chestType + " " + tailorJewelerChestText)
        If FixedProperties.aaslrVoicesTailor.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(tailorChestText)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
        If FixedProperties.aaslrVoicesJeweler.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(jewelerChestText)
            voiceAdded = self.TryToAddToFaction(newFaction)
        EndIf
    endIf
    
EndFunction
