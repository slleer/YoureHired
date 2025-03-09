Scriptname MerchantScript extends Quest  
{Manages all merchants and handles adding/removing them}

Import YHUtil

YoureHiredMerchantPropertiesScript property FixedProperties auto
PlayerRefScript property PlayerScript auto

; FormList property Merchants auto


Actor[] hiredActors
BusinessScript[] merchantAliases
string[] merchantNames

int NextOpenAlias
int LastFoundMerchant
Quest myQuest



Event OnInit()
    AddLineBreakWithText(self + "We are in the OnInit")
    AddLineBreakGameTimeOptional()
    myQuest = Quest.GetQuest("aaslrYoureHiredMainQuest")
    int numAlias = FixedProperties.aaslrMaxNumberMerchants.GetValueInt()
    hiredActors = new Actor[12]
    merchantAliases = new BusinessScript[12]
    merchantNames = Utility.CreateStringArray(numAlias,"*EMPTY*")
    int index = 0
    While (index < numAlias)
        merchantAliases[index] = (myQuest.GetNthAlias(index) as BusinessScript)
        merchantAliases[index].SetMerchantIndex(index)
        index += 1
    EndWhile
    NextOpenAlias = 0
    ; RegisterForMenu("Journal Menu")
EndEvent


Event OnUpdate()
    Log(self + " We are in the update event!!!")
    Utility.wait(0.1)
    int index = 0
    Actor thisMerchant
    While index < FixedProperties.aaslrMaxNumberMerchants.GetValueInt()
        thisMerchant = hiredActors[index]
        Log(self + "This merchant" + thisMerchant)
        if thisMerchant
            If FixedProperties.GetToggleBetweenMenuOrGametimeReset()
                merchantAliases[index].MerchantChestScript.ToggleOnMenuCloseOrGametime()
            EndIf
            If FixedProperties.GetNeedToUpdateMerchantChests()
                merchantAliases[index].MerchantChestScript.ResetChest(false)
            EndIf
            If (FixedProperties.GetUpdateVanillaMerchantFaction())
                If (merchantAliases[index].GetIsVanillaMerchant())
                    If (myQuest as YoureHiredMCM).S_DoubleMerchantEnabled
                        If (!thisMerchant.IsInFaction(FixedProperties.JobMerchantFaction))
                            thisMerchant.AddToFaction(FixedProperties.JobMerchantFaction)
                            thisMerchant.SetFactionRank(FixedProperties.JobMerchantFaction, merchantAliases[index].GetJobMerchantFactionRank())
                        EndIf
                    Else
                        If (thisMerchant.IsInFaction(FixedProperties.JobMerchantFaction))
                            merchantAliases[index].SetJobMerchantFactionRank(thisMerchant.GetFactionRank(FixedProperties.JobMerchantFaction))
                            thisMerchant.RemoveFromFaction(FixedProperties.JobMerchantFaction)
                        EndIf
                    EndIf
                EndIf
            EndIf

        endIf
        index += 1
    EndWhile
    FixedProperties.SetToggleBetweenMenuOrGametimeReset(false)
    FixedProperties.SetNeedToUpdateMerchantChests(false)
    isWaiting = false
EndEvent


BusinessScript[] Function GetMerchantAliasScripts()
    return merchantAliases
EndFunction

string[] Function GetMerchantNames()
    int index = 0
    int nameIndex = 0
    while index < hiredActors.Length
        If hiredActors[index]
            merchantNames[nameIndex] = hiredActors[index].GetBaseObject().GetName()
            nameIndex += 1
        ; Else
        ;     merchantNames[index] = "*EMPTY*"
        EndIf       
        index += 1
    endWhile
    return Utility.ResizeStringArray(merchantNames, nameIndex)
EndFunction

bool Function IsValidMerchantType(Actor akMerchant)
    If (FixedProperties.aaslrVoicesNPCsNOCHILD.HasForm(akMerchant.GetVoiceType()))
        return true
    EndIf
    If (FixedProperties.aaslrPlayableRacesFormList.HasForm(akMerchant.GetRace()))
        return true
    EndIf
    If (akMerchant.IsChild())
        If (FixedProperties.aaslrAllowChildrenFlag.GetValue() == 1.0)
            return true
        EndIf
    EndIf
    If (FixedProperties.aaslrAnimalVoiceTypes.HasForm(akMerchant.GetVoiceType()))
        If (FixedProperties.aaslrAllowBeastsFlag.GetValue() == 1.0)
            return true
        EndIf
    EndIf

    return false
EndFunction

; ;Add or remove an actor as a merchant
; Function HandleMerchant(Actor akMerchant)
;     Log(self + "In AddRemoveMerchant with: " + akMerchant.GetBaseObject().GetName(), 2)
;     If (hiredActors.Find(akMerchant) > -1)
;         DoRemoveMerchant(akMerchant)
;     ElseIf IsValidMerchantType(akMerchant)
;         If (FixedProperties.GetNumMerchantsGlobal() < (FixedProperties.aaslrMaxNumberMerchants.GetValue() as int))
;             Log(self + "Actor is not yet a merchant")
;             if NextOpenAlias > -1
;                 DoAddMerchant(akMerchant)
;             Else
;                 NextOpenAlias = hiredActors.Find(NONE)
;                 if NextOpenAlias == -1
;                     FixedProperties.aaslrNumberOfMerchants.SetValue(FixedProperties.aaslrMaxNumberMerchants.GetValue())
;                     FixedProperties.FullMerchantListMessage.Show()
;                 Else
;                     DoAddMerchant(akMerchant)
;                 EndIf
;             endIf
;         Else
;             Log(self + "NextOpenAlias pointed to filled alias")
;             FixedProperties.FullMerchantListMessage.Show()
;         EndIf
;     EndIf
; EndFunction

;Add an actor as a Merchant from dialogue
Function AddMerchant(Actor akMerchant)
    AddLineBreakGameTimeOptional()
    Log(self + "In AddMerchant (from dialogue) with: " + akMerchant.GetBaseObject().GetName())
    If (IsValidMerchantType(akMerchant))
        If hiredActors.Find(akMerchant) < 0
            if NextOpenAlias > -1
                DoAddMerchant(akMerchant)       
            Else
                NextOpenAlias = hiredActors.Find(NONE)
                if NextOpenAlias > -1
                    DoAddMerchant(akMerchant)
                endIf
                FixedProperties.FullMerchantListMessage.Show()
            endIf 
        EndIf
    EndIf
EndFunction

Function DoAddMerchant(Actor akMerchant)
    Log(self + "Actor is not yet a merchant, in DoAddMerchant")
    BusinessScript newMerchant = merchantAliases[NextOpenAlias]
    bool success
    If (!newMerchant.GetActorReference())             
        success = newMerchant.FillAliasWithActor(akMerchant)
        if success
            FixedProperties.SetNumMerchantsGlobal(1.0)
            myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
            (FixedProperties.AddedMerchantMessageFormList.GetAt(NextOpenAlias) as Message).Show()
        endIf
        hiredActors[NextOpenAlias] = akMerchant
        NextOpenAlias = hiredActors.Find(NONE)
    Else
        Log(self + "NextOpenAlias pointed to filled alias or actor is already a merchant!")
        FixedProperties.FailedAddMerchantMessage.Show()
    EndIf        
EndFunction

; Remove an actor as a Merchant from dialogue
Function RemoveMerchant(Actor akMerchant)
    Log(self + "Removing a merchant from dialogue")
    If (hiredActors.Find(akMerchant) > -1)
        DoRemoveMerchant(akMerchant)
    EndIf
EndFunction

Function DoRemoveMerchant(Actor akMerchant)
    LastFoundMerchant = hiredActors.Find(akMerchant)
    BusinessScript exMerchant = merchantAliases[LastFoundMerchant]
    Log(self + "removing actor from merchants")
    FixedProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    (FixedProperties.RemovedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    exMerchant.clearActorFromAlias()
    hiredActors[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Log(self + "Actor cleared from alias!!!")
EndFunction

Function RemoveThisMerchant(BusinessScript thisMerchant)
    LastFoundMerchant = hiredActors.Find(thisMerchant.GetActorReference())
    Log(self + "The index for this merchant is " + LastFoundMerchant + " and the merchant name from that index is: " + hiredActors[LastFoundMerchant].GetName())
    FixedProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    thisMerchant.ClearActorFromAlias()
    (FixedProperties.RemovedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    hiredActors[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Log(self + "Removed this merchant")
EndFunction

Function RemoveThisDeadDisabledMerchant(BusinessScript thisMerchant, bool isDead)
    LastFoundMerchant = hiredActors.Find(thisMerchant.GetActorReference())
    Log(self + "The index for this merchant is " + LastFoundMerchant + " and the merchant name from that index is: " + hiredActors[LastFoundMerchant].GetName())
    FixedProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    if isDead
        (FixedProperties.DeadMerchantRemovedMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    else
        (FixedProperties.DisabledDeletedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    endIf
    thisMerchant.ClearActorFromAlias()
    hiredActors[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Log(self + "Removed this merchant")
EndFunction

Function RemoveAllMerchants()
    int numMerchants = merchantAliases.Length
    Log(self + "About to remove all Merchants")
    Actor thisMerhcant
    While (numMerchants)
        numMerchants -= 1
        thisMerhcant = hiredActors[numMerchants]
        If (thisMerhcant)
            Log(self + "About to clear: " + thisMerhcant.GetBaseObject().GetName())
            merchantAliases[numMerchants].ClearActorFromAlias()
            hiredActors[numMerchants] = NONE
            FixedProperties.SetNumMerchantsGlobal(-1)
        EndIf
    EndWhile
    NextOpenAlias = 0
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    FixedProperties.RemovedAllMerchantsMessage.Show()
EndFunction

;Changes the vender chest reference using the passed in string as key
Function ChangeChestType(Actor akMerchant, string chestType)
    bool success
    If (hiredActors.Find(akMerchant) > -1)
        int index = hiredActors.Find(akMerchant)
        BusinessScript merchant = merchantAliases[index]
        If (merchant)            
            success = merchant.changeChestType(chestType)
            Log(self + "Chest type changed to: " + chestType)
        EndIf
    EndIf
EndFunction

Function YHShowBarterMenu(Actor akSpeaker)
    Log(self + "In YHShowBarterMenu!!!!!")
    If (hiredActors.Find(akSpeaker) > -1)
        Log(self + "We found the merchant: " + akSpeaker.GetBaseObject().GetName())
        int index = hiredActors.Find(akSpeaker)
        BusinessScript merchant = merchantAliases[index]
        If (merchant)
            If (FixedProperties.EnableHotKeyUse)
                FixedProperties.IsManagedMerchantTrading = true
                merchant.MerchantChestScript.ListenForHotKeys()
            EndIf
            Log(self + "BarterMenu actor found: "+ merchant.GetActorName())
            merchant.ProxyActor.ShowBarterMenu()
        EndIf
    Else
        akSpeaker.ShowBarterMenu()
    EndIf
EndFunction

Function SellJunkAuto(Actor akMerchant)
    If (myQuest as YoureHiredMCM).S_AutoSellJunk
        SellJunk(akMerchant)
    EndIf
endFunction

Function SellJunk(Actor akMerchant)
    If (hiredActors.Find(akMerchant) > -1)
        int index = hiredActors.Find(akMerchant)
        int junkPrice = PlayerScript.GetSellCostOfJunk(akMerchant.GetActorBase().GetSex() != PlayerScript.GetActorReference().GetActorBase().GetSex(), merchantAliases[index].MerchantChestScript)
        PlayerScript.GetActorReference().additem(FixedProperties.gold, junkPrice)
        merchantAliases[index].MerchantChestScript.BuyJunk(junkPrice)
        Log(self + "Adding " + junkPrice + " to the player and removing it from the proxy")
    EndIf
EndFunction

Function PromoteToFence(Actor akFence)
    If (hiredActors.Find(akFence) > -1)
        int index = hiredActors.Find(akFence)
        BusinessScript newFence = merchantAliases[index]
        If (newFence)
            newFence.PromoteToFence()
        EndIf
    Else
        Log(self + "Actor is not a merchant!!!")
    EndIf
EndFunction

BusinessScript Function GetMerchant(Actor akMerchant)
    int index = 0
    BusinessScript foundMerchant
    While (index < hiredActors.Length)
        foundMerchant = merchantAliases[index]
        If (foundMerchant && foundMerchant.GetActorReference() == akMerchant)
            LastFoundMerchant = index
            return foundMerchant
        EndIf
        index += 1
    EndWhile
    return none
EndFunction

bool isWaiting = false
Function UpdateResetCondtions()
    Log(self + " We are about to reset everything!!! ")
    If (!isWaiting)
        isWaiting = true
        RegisterForSingleUpdate(0.1)
    EndIf
EndFunction

bool Function IsManagedMerchant(Actor akMerchant)
    return (hiredActors.Find(akMerchant) > -1)
EndFunction

Function ResetChest(Actor akMerchant)
    int index = hiredActors.Find(akMerchant)
    BusinessScript merchantToReset = merchantAliases[index]
    if(merchantToReset)
        merchantToReset.MerchantChestScript.ResetChest(false)
    endIf

EndFunction