Scriptname MerchantScript extends Quest  
{Manages all merchants and handles adding/removing them}

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
    Logger("We are in the OnInit",logType = 2)
    Logger(logType = 3)
    myQuest = Quest.GetQuest("aaslrYoureHiredMainQuest")
    int numAlias = FixedProperties.aaslrMaxNumberMerchants.GetValueInt()
    hiredActors = new Actor[12]
    merchantAliases = new BusinessScript[12]
    merchantNames = Utility.CreateStringArray(numAlias,"*EMPTY*")
    int index = 0
    While (index < numAlias)
        merchantAliases[index] = (myQuest.GetNthAlias(index) as BusinessScript)
        index += 1
    EndWhile
    NextOpenAlias = 0
    RegisterForMenu("Journal Menu")
EndEvent

Event OnMenuClose(string openMenu)
    Logger("The menu that was closed is: " + openMenu)
    if openMenu == "Journal Menu"
        If FixedProperties.UpdateNeeded > 0
            int index = 0
            Logger("Need to update")
            Actor thisMerchant
            While index < FixedProperties.aaslrMaxNumberMerchants.GetValueInt()
                thisMerchant = hiredActors[index]
                Logger("This merchant" + thisMerchant)
                if thisMerchant
                    If FixedProperties.ToggleBetweenMenuOrGametimeReset > 0
                        merchantAliases[index].MerchantChestScript.ToggleOnMenuCloseOrGametime()
                    EndIf
                    If FixedProperties.NeedToUpdateMerchantChests > 0
                        merchantAliases[index].MerchantChestScript.ResetChest(false)
                    EndIf
                endIf
                index += 1
            EndWhile
            FixedProperties.UpdateNeeded = 0
            FixedProperties.ToggleBetweenMenuOrGametimeReset = 0
            FixedProperties.NeedToUpdateMerchantChests = 0
        EndIf
        Logger("End of OnMenuClose")
    endIf
EndEvent

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("MerchantManager Redux - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MerchantManager Redux - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

BusinessScript[] Function GetMerchantAliasScripts()
    return merchantAliases
EndFunction

int Function GetMerchantAliasIndex(BusinessScript merchant)
    return merchantAliases.Find(merchant)
EndFunction

string[] Function GetMerchantNames()
    int index = 0
    while index < hiredActors.Length
        If hiredActors[index]
            merchantNames[index] = hiredActors[index].GetBaseObject().GetName()
        Else
            merchantNames[index] = "*EMPTY*"
        EndIf       
        index += 1
    endWhile
    return merchantNames
EndFunction

bool Function IsValidMerchantType(Actor akMerchant)
    If (FixedProperties.aaslrVoicesNPCsNOCHILD.HasForm(akMerchant.GetVoiceType()))
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

;Add or remove an actor as a merchant
Function HandleMerchant(Actor akMerchant)
    Logger("In AddRemoveMerchant with: " + akMerchant.GetBaseObject().GetName(), 2)
    If (hiredActors.Find(akMerchant) > -1)
        DoRemoveMerchant(akMerchant)
    ElseIf IsValidMerchantType(akMerchant)
        If (FixedProperties.GetNumMerchantsGlobal() < (FixedProperties.aaslrMaxNumberMerchants.GetValue() as int))
            Logger("Actor is not yet a merchant")
            if NextOpenAlias > -1
                DoAddMerchant(akMerchant)
            Else
                NextOpenAlias = hiredActors.Find(NONE)
                if NextOpenAlias == -1
                    FixedProperties.aaslrNumberOfMerchants.SetValue(FixedProperties.aaslrMaxNumberMerchants.GetValue())
                    FixedProperties.FullMerchantListMessage.Show()
                Else
                    DoAddMerchant(akMerchant)
                EndIf
            endIf
        Else
            Logger("NextOpenAlias pointed to filled alias")
            FixedProperties.FullMerchantListMessage.Show()
        EndIf
    EndIf
EndFunction

;Add an actor as a Merchant from dialogue
Function AddMerchant(Actor akMerchant)
    Logger(logType = 3)
    Logger("In AddMerchant (from dialogue) with: " + akMerchant.GetBaseObject().GetName(), true, 2)
    If (hiredActors.Find(akMerchant) < 0 && NextOpenAlias > -1)
        DoAddMerchant(akMerchant)        
    Else
        NextOpenAlias = hiredActors.Find(NONE)
        if NextOpenAlias > -1
            DoAddMerchant(akMerchant)
        endIf
        FixedProperties.FullMerchantListMessage.Show()
    EndIf
EndFunction

Function DoAddMerchant(Actor akMerchant)
    Logger("Actor is not yet a merchant, in DoAddMerchant")
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
        Logger("NextOpenAlias pointed to filled alias or actor is already a merchant!")
        FixedProperties.FailedAddMerchantMessage.Show()
    EndIf        
EndFunction

; Remove an actor as a Merchant from dialogue
Function RemoveMerchant(Actor akMerchant)
    Logger("Removing a merchant from dialogue")
    If (hiredActors.Find(akMerchant) > -1)
        DoRemoveMerchant(akMerchant)
    EndIf
EndFunction

Function DoRemoveMerchant(Actor akMerchant)
    LastFoundMerchant = hiredActors.Find(akMerchant)
    BusinessScript exMerchant = merchantAliases[LastFoundMerchant]
    Logger("removing actor from merchants")
    FixedProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    (FixedProperties.RemovedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    exMerchant.clearActorFromAlias()
    hiredActors[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Logger("Actor cleared from alias!!!")
EndFunction

Function RemoveThisMerchant(BusinessScript thisMerchant)
    LastFoundMerchant = hiredActors.Find(thisMerchant.GetActorReference())
    Logger("The index for this merchant is " + LastFoundMerchant + " and the merchant name from that index is: " + hiredActors[LastFoundMerchant].GetName())
    FixedProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedProperties.aaslrNumberOfMerchants)
    (FixedProperties.RemovedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    thisMerchant.ClearActorFromAlias()
    hiredActors[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Logger("Removed this merchant")
EndFunction

Function RemoveThisDeadDisabledMerchant(BusinessScript thisMerchant, bool isDead)
    LastFoundMerchant = hiredActors.Find(thisMerchant.GetActorReference())
    Logger("The index for this merchant is " + LastFoundMerchant + " and the merchant name from that index is: " + hiredActors[LastFoundMerchant].GetName())
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
    Logger("Removed this merchant")
EndFunction

Function RemoveAllMerchants()
    int numMerchants = merchantAliases.Length
    Logger("About to remove all Merchants")
    Actor thisMerhcant
    While (numMerchants)
        numMerchants -= 1
        thisMerhcant = hiredActors[numMerchants]
        If (thisMerhcant)
            Logger("About to clear: " + thisMerhcant.GetName())
            merchantAliases[numMerchants].ClearActorFromAlias()
            hiredActors[numMerchants] = NONE
        EndIf
    EndWhile
    FixedProperties.aaslrNumberOfMerchants.SetValue(0.0)
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
            Logger("Chest type changed to: " + chestType)
        EndIf
    EndIf
EndFunction

Function YHShowBarterMenu(Actor akSpeaker)
    Logger("In YHShowBarterMenu!!!!!")
    If (hiredActors.Find(akSpeaker) > -1)
        Logger("We found the merchant: " + akSpeaker.GetBaseObject().GetName())
        int index = hiredActors.Find(akSpeaker)
        BusinessScript merchant = merchantAliases[index]
        If (merchant)
            FixedProperties.IsManagedMerchantTrading = true
            If (FixedProperties.EnableHotKeyUse)
                merchant.MerchantChestScript.ListenForHotKeys()
            EndIf
            Logger("BarterMenu actor found: "+ merchant.GetActorName())
            Logger("ProxyActor name: " + merchant.ProxyActor.GetBaseObject().GetName())
            Logger("Faction Chest name: " + merchant.MerchantChestScript.GetDisplayName())
            Logger("The actor that was made [" +  merchant.ProxyActor.GetBaseObject().GetName() + "] has " +  merchant.ProxyActor.GetNumItems() + " items: " +  merchant.ProxyActor.GetContainerForms())

            merchant.ProxyActor.ShowBarterMenu()
        EndIf
    Else
        akSpeaker.ShowBarterMenu()
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
        Logger("Actor is not a merchant!!!")
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