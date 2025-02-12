Scriptname BusinessScript extends ReferenceAlias  
{This manages actors after they've been added to You're Hired Merchant factions.}

Faction property YoureHiredFaction auto
YoureHiredMerchantPropertiesScript property FixedProperties auto
ActorBase property  ProxyBase_Male auto
ActorBase property ProxyBase_Female auto
ActorBase property ProxyBase_Animal auto
Actor property ProxyActor auto
ObjectReference property ChestXMarker auto
YoureHiredMerchantChestScript property MerchantChestScript auto


string _actorName
string _currentChestType
bool isVanillaMerchant = false
ObjectReference invMerchantStandOwned

int proxyOutfitId = 0x00103AF2
int proxyKeepid01 = 0x0003C9FE
string blacksmithChestText = "Blacksmith"
string potionsChestText = "Apothecary"
string magicChestText = "Magic"
string miscChestText = "General Goods"
string innKeeperChestText = "Innkeeper"
string jewelerChestText = "Jeweler"
string tailorJewelerChestText = "TailorJeweler"
string tailorChestText = "Tailor"

Event OnInit()
    Logger("In OnInit")
EndEvent

Event OnReset()

    Logger("We have been reset")
EndEvent

Event OnDeath(Actor akKiller)
    If (GetActorReference().IsDead())
        YHUtil.Log(self + " The actor has been killed")
        string deadMerchant = GetActorName()
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, true)
        YHUtil.Log(self + " " + deadMerchant + " was removed.")
    EndIf
EndEvent

Event OnUnload()
    YHUtil.Log(self + " In OnUnload ")
    If (GetActorReference().IsDisabled())
        YHUtil.Log(self + " Actor is disabled OH NO!!")
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, false)
        YHUtil.Log(self + " The disabled actor has been removed!!! ")
        return
    EndIf
    If (GetActorReference().IsDeleted())
        YHUtil.Log(self + " ACtor has been deleted!!!! WAHH NAIGH")
        FixedProperties.MerchantManager.RemoveThisDeadDisabledMerchant(self, false)
        YHUtil.Log(self + " The deleted actor has been removed!!! ")
        return
    EndIf
EndEvent

; calles logger with some preformating 1:Log, 2:LineBreakTEXT, 3:LineBreakGAMETIME
Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("Business Script Redux - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("Business Script Redux - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

; Empty state declaration
;change the faction's container to chestType
Function ChangeChestType(string chestType)
    Logger("In the empty state")
EndFunction

;State to start in so don't delete the bank chest
Auto State BlankChestState
    ;change the faction's container to chestType.
    Function ChangeChestType(string chestType)
        Logger(" in default state change chest type function ", logType = 2)
        Form newContainer
        if chestType == "Random"
            newContainer = FixedProperties.GetRandomChestType()
            chestType = newContainer.GetName()
            Logger("Random chest is: " + chestType)
        else
            newContainer = FixedProperties.getChestBase(chestType)
        endIf
        ObjectReference newContainerRef = ChestXMarker.PlaceAtMe(newContainer, abForcePersist = true)
        Logger("newContainerRef: " + newContainerRef)
        MerchantChestScript = (newContainerRef as YoureHiredMerchantChestScript)
        _currentChestType = chestType
        MerchantChestScript.ProxyActor = ProxyActor
        
        If (newContainer)
            int moreGold = 175 + Utility.RandomInt()
            newContainerRef.AddItem(FixedProperties.gold, moreGold, true)
            YoureHiredFaction.SetMerchantContainer(newContainerRef)
            newContainerRef.SetActorOwner(ProxyActor.GetBaseObject() as ActorBase)
            Logger("newContainerRef.GetActorOwner(): " + newContainerRef.GetActorOwner())
            addJobTypeFaction(chestType)
        EndIf
        GoToState("DisposeChestState")
    EndFunction
EndState
;State to move to after inialization so we can take disable/delete added containers
State DisposeChestState
    ;change the faction's container and disable/delete the previous one
    Function ChangeChestType(string chestType)
        Logger(" in Dispose state change chest type function ", logType = 2)
        Form newContainer
        if chestType == "Random"
            newContainer = FixedProperties.GetRandomChestType()
            chestType =newContainer.GetName()
            Logger("Random chest is: " + chestType)
        else
            Logger("The chest type is: " + chestType)
            newContainer = FixedProperties.getChestBase(chestType)
        endIf
        ObjectReference oldContainer = YoureHiredFaction.GetMerchantContainer()
        string oldChestType = oldContainer.GetDisplayName()
        if oldChestType != chestType
            ObjectReference newContainerRef = ChestXMarker.PlaceAtMe(newContainer, abForcePersist = true)
            Logger("newContainerRef: " + newContainerRef)
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

;retrieves the current chest type
string Function GetChestType()
    return _currentChestType
EndFunction

;resets the faction's container to the blankchest
Function ResetFactionContainer()
    ObjectReference oldContainer = YoureHiredFaction.GetMerchantContainer()
    YoureHiredFaction.SetMerchantContainer(FixedProperties.BlankChestRef)
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
        If !invMerchantStandOwned
            invMerchantStandOwned = FixedProperties.GetInventoryStand()
            invMerchantStandOwned.SetDisplayName(_actorName + "'s Merchant Stall")
            (invMerchantStandOwned as InventortyItemScript).SetOwningMerchant(self)
            ProxyActor.AddItem(invMerchantStandOwned,1,true)
        EndIf
        if akMerchant.IsChild()
            (invMerchantStandOwned as InventortyItemScript).SetIsChild(true)
        endIf
    endIf
    return success
EndFunction
;Clears the actor from the RefAlias and adds any factions that might have been cleared by accident
Function ClearActorFromAlias()
    ResetFactionContainer()
    _actorName = ""
    ResetProxy()
    SendStallSelfDestruct()
    PromoteToFence(true)
    ClearJobTypeFactions()
    self.Clear()
EndFunction
;creates an instance of the proxy actor and names it after the new merchant
Function FillProxy(Actor proxy)
    int sex = proxy.GetActorBase().GetSex()
    Logger("merchant sex: " + sex + ", merchant race: " + proxy.GetRace())
    If (sex == 0)
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Male, abForcePersist = true) as Actor
    ElseIf (sex == 1)
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Female, abForcePersist = true) as Actor
    Else
        ProxyActor = ChestXMarker.PlaceAtMe(ProxyBase_Animal, abForcePersist = true) as Actor
    EndIf
    ProxyActor.SetRace(proxy.GetRace())
    Logger("Placed and moved the proxy actor")
    Faction[] proxyFactions = proxy.GetFactions(-120,120)
    int index = 0
    While index < proxyFactions.Length
        If (FixedProperties.PlayerRef.IsInFaction(proxyFactions[index]))
            ProxyActor.AddToFaction(proxyFactions[index])
            ProxyActor.SetFactionRank((proxyFactions[index]), proxy.GetFactionRank(proxyFactions[index]))
        EndIf
        index += 1
    EndWhile
    int relationshipRank = proxy.GetRelationshipRank(FixedProperties.PlayerRef)
    ProxyActor.SetRelationshipRank(FixedProperties.PlayerRef, relationshipRank)
    Logger("Added proxy to necessary factions and set relationship rank")
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
            Logger("Faction : " + thisFaction.GetName() + " removed successfully: " + success)
        EndIf
        If (FixedProperties.aaslrYoureHiredVoiceTypeJobFactionsFormList.HasForm(thisFaction as Form))
            success = self.TryToRemoveFromFaction(thisFaction)
            Logger("Faction : " + thisFaction.GetName() + " removed successfully: " + success)
        EndIf
    endWhile
EndFunction

ObjectReference Function GetMerchnatStandInventoryItem()
    return invMerchantStandOwned
EndFunction

Function SendStallSelfDestruct()
    int handle = ModEvent.Create("aaslrYH_StandSelfDestruct")
    if handle
        ModEvent.PushForm(handle, YoureHiredFaction)
        ModEvent.Send(handle)
    endIf
EndFunction


; Sets faction to accept stolen goods or not
Function PromoteToFence(bool setDefault = false)
    Logger("In Promote to fence", logType = 2)
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

;Remove the jobTypeFaction that matches the passed in string
Function RemoveJobTypeFaction(string chestType)
    Logger("Chest type in removeJobTypeFaction: " + chestType)
    bool success
    bool voiceAdded
    Faction oldFaction = FixedProperties.GetFactionByString(chestType)
    success = self.TryToRemoveFromFaction(oldFaction)
    Logger("old faction being removed: " + oldFaction.GetName() + " success: " + success)
    oldFaction = NONE
    if chestType == blacksmithChestText
        If FixedProperties.aaslrVoicesBlacksmith.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    elseIf chestType == potionsChestText
        If FixedProperties.aaslrVoicesApothecary.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    elseif chestType == innKeeperChestText
        If FixedProperties.aaslrVoicesTownInnkeeper.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    elseif chestType == miscChestText
        If FixedProperties.aaslrVoicesMisc.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    elseif chestType == magicChestText
        If FixedProperties.aaslrVoicesMagic.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    elseif chestType == tailorJewelerChestText
        If FixedProperties.aaslrVoicesTailor.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(tailorChestText)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
        If FixedProperties.aaslrVoicesJeweler.HasForm(self.GetActorReference().GetVoiceType() as Form)
            oldFaction = FixedProperties.GetVoiceTypeFactionByString(jewelerChestText)
            voiceAdded = self.TryToRemoveFromFaction(oldFaction)
            Logger("voiceTypeFaction removed: " + oldFaction.GetName() + " : " + voiceAdded)
        EndIf
    endIf
    
EndFunction

Function AddJobTypeFaction(string chestType)
    Logger("Chest type in AddJobTypeFaction: " + chestType)
    bool success
    bool voiceAdded
    Faction newFaction = FixedProperties.GetFactionByString(chestType)
    success =  self.TryToAddToFaction(newFaction)
    Logger("New Faction being added: " + newFaction.GetName() + " success: " + success)
    newFaction = NONE
    if chestType == blacksmithChestText
        Logger(chestType + " " + blacksmithChestText)
        If FixedProperties.aaslrVoicesBlacksmith.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    elseIf chestType == potionsChestText
        Logger(chestType + " " + potionsChestText)
        If FixedProperties.aaslrVoicesApothecary.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    elseif chestType == innKeeperChestText
        Logger(chestType + " " + innKeeperChestText)
        If FixedProperties.aaslrVoicesTownInnkeeper.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    elseif chestType == miscChestText
        Logger(chestType + " " + miscChestText)
        If FixedProperties.aaslrVoicesMisc.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    elseif chestType == magicChestText
        Logger(chestType + " " + magicChestText)
        If FixedProperties.aaslrVoicesMagic.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(chestType)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    elseif chestType == tailorJewelerChestText
        Logger(chestType + " " + tailorJewelerChestText)
        If FixedProperties.aaslrVoicesTailor.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(tailorChestText)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
        If FixedProperties.aaslrVoicesJeweler.HasForm(self.GetActorReference().GetVoiceType() as Form)
            newFaction = FixedProperties.GetVoiceTypeFactionByString(jewelerChestText)
            voiceAdded = self.TryToAddToFaction(newFaction)
            Logger("voice Faction added: " + newFaction.GetName() + " success: " + voiceAdded)
        EndIf
    endIf
    
EndFunction
