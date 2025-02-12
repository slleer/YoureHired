Scriptname YoureHiredMerchantManagerScript extends Quest  
{Manages all merhants and controls their adding and removal}

YoureHiredMerchantPropertiesScript property FixedMerchantProperties auto

FormList property Merchants auto


BusinessScript[] filledMerchantAliases
BusinessScript[] merchantAliasScripts
string[] merchantNames

int NextOpenAlias
int LastFoundMerchant
Quest myQuest



Event OnInit()
    Logger("We are in the OnInit",logType = 2)
    Logger(logType = 3)
    myQuest = Quest.GetQuest("aaslrYoureHiredMainQuest")
    int numAlias = FixedMerchantProperties.aaslrMaxNumberMerchants.GetValueInt()
    filledMerchantAliases = new BusinessScript[12]
    merchantAliasScripts = new BusinessScript[12]
    merchantNames = Utility.CreateStringArray(numAlias,"*EMPTY*")
    int index = 0
    While (index < numAlias)
        merchantAliasScripts[index] = (myQuest.GetNthAlias(index) as BusinessScript)
        index += 1
    EndWhile
    NextOpenAlias = 0
    RegisterForMenu("Journal Menu")
EndEvent

Event OnMenuClose(string openMenu)
    Logger("The menu that was closed is: " + openMenu)
    if openMenu == "Journal Menu"
        If FixedMerchantProperties.UpdateNeeded > 0
            int index = 0
            Logger("Need to update")
            BusinessScript thisMerchant
            While index < FixedMerchantProperties.aaslrMaxNumberMerchants.GetValueInt()
                thisMerchant = FilledMerchantAliases[index]
                Logger("This merchant" + thisMerchant)
                if thisMerchant
                    If FixedMerchantProperties.ToggleBetweenMenuOrGametimeReset > 0
                        thisMerchant.MerchantChestScript.ToggleOnMenuCloseOrGametime()
                    EndIf
                    If FixedMerchantProperties.NeedToUpdateMerchantChests > 0
                        thisMerchant.MerchantChestScript.ResetChest(false)
                    EndIf
                endIf
                index += 1
            EndWhile
            FixedMerchantProperties.UpdateNeeded = 0
            FixedMerchantProperties.ToggleBetweenMenuOrGametimeReset = 0
            FixedMerchantProperties.NeedToUpdateMerchantChests = 0
        EndIf
        Logger("End of OnMenuClose")
    endIf
EndEvent

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("MerchantManager - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MerchantManager - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

BusinessScript[] Function GetMerchantAliasScripts()
    return merchantAliasScripts
EndFunction

string[] Function GetMerchantNames()
    int index = 0
    int merchantSize = Merchants.GetSize()
    int nameSize = merchantNames.Length
    while index < nameSize

        If index < merchantSize
            merchantNames[index] = (Merchants.GetAt(index) as actor).GetBaseObject().GetName()
        Else
            merchantNames[index] = "*EMPTY*"
        EndIf       
        index += 1
    endWhile
    return merchantNames
EndFunction

bool Function IsValidMerchantType(Actor akMerchant)
    If (FixedMerchantProperties.aaslrVoicesNPCsNOCHILD.HasForm(akMerchant.GetVoiceType()))
        return true
    EndIf
    If (akMerchant.IsChild())
        If (FixedMerchantProperties.aaslrAllowChildrenFlag.GetValue() == 1.0)
            return true
        EndIf
    EndIf
    If (FixedMerchantProperties.aaslrAnimalVoiceTypes.HasForm(akMerchant.GetVoiceType()))
        If (FixedMerchantProperties.aaslrAllowBeastsFlag.GetValue() == 1.0)
            return true
        EndIf
    EndIf
    return false
EndFunction

;Add or remove an actor as a merchant
Function HandleMerchant(Actor akMerchant)
    Logger("In AddRemoveMerchant with: " + akMerchant.GetBaseObject().GetName(), 2)
    If (Merchants.HasForm(akMerchant))
        DoRemoveMerchant(akMerchant)
    ElseIf IsValidMerchantType(akMerchant)
        If (FixedMerchantProperties.GetNumMerchantsGlobal() < (FixedMerchantProperties.aaslrMaxNumberMerchants.GetValue() as int))
            Logger("Actor is not yet a merchant")
            if NextOpenAlias > -1
                DoAddMerchant(akMerchant)
            Else
                NextOpenAlias = filledMerchantAliases.Find(NONE)
                if NextOpenAlias == -1
                    FixedMerchantProperties.aaslrNumberOfMerchants.SetValue(FixedMerchantProperties.aaslrMaxNumberMerchants.GetValue())
                    FixedMerchantProperties.FullMerchantListMessage.Show()
                Else
                    DoAddMerchant(akMerchant)
                EndIf
            endIf
        Else
            Logger("NextOpenAlias pointed to filled alias")
            FixedMerchantProperties.FullMerchantListMessage.Show()
        EndIf
    EndIf
EndFunction

;Add an actor as a Merchant from dialogue
Function AddMerchant(Actor akMerchant)
    Logger(logType = 3)
    Logger("In AddMerchant (from dialogue) with: " + akMerchant.GetBaseObject().GetName(), 2)
    If (!Merchants.HasForm(akMerchant) && NextOpenAlias > -1 && NextOpenAlias < merchantAliasScripts.Length)
        DoAddMerchant(akMerchant)        
    Else
        NextOpenAlias = filledMerchantAliases.Find(NONE)
        if NextOpenAlias > -1 && NextOpenAlias < merchantAliasScripts.Length
            DoAddMerchant(akMerchant)
        endIf
        FixedMerchantProperties.FullMerchantListMessage.Show()
    EndIf
EndFunction

Function DoAddMerchant(Actor akMerchant)
    Logger("Actor is not yet a merchant, in DoAddMerchant")
    BusinessScript newMerchant = merchantAliasScripts[NextOpenAlias]
    bool success
    If (!newMerchant.GetActorReference())             
        success = newMerchant.FillAliasWithActor(akMerchant)
        if success
            FixedMerchantProperties.SetNumMerchantsGlobal(1.0)
            myQuest.UpdateCurrentInstanceGlobal(FixedMerchantProperties.aaslrNumberOfMerchants)
            (FixedMerchantProperties.AddedMerchantMessageFormList.GetAt(NextOpenAlias) as Message).Show()
        endIf
        filledMerchantAliases[NextOpenAlias] = newMerchant
        Merchants.AddForm(akMerchant)
        NextOpenAlias = filledMerchantAliases.Find(NONE)
        ; bool packageSuccess = MerchantScript.TryToEvaluatePackage()
        ; Logger("Package success: " + packageSuccess)
    Else
        Logger("NextOpenAlias pointed to filled alias or actor is already a merchant!")
        FixedMerchantProperties.FailedAddMerchantMessage.Show()
    EndIf        
EndFunction

; Remove an actor as a Merchant from dialogue
Function RemoveMerchant(Actor akMerchant)
    Logger("Removing a merchant from dialogue")
    If (Merchants.HasForm(akMerchant))
        DoRemoveMerchant(akMerchant)
    EndIf
EndFunction

Function DoRemoveMerchant(Actor akMerchant)
    BusinessScript exMerchant = GetMerchant(akMerchant)
    Logger("actor is already a merchant")
    FixedMerchantProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedMerchantProperties.aaslrNumberOfMerchants)
    (FixedMerchantProperties.RemovedMerchantMessageFormList.GetAt(LastFoundMerchant) as Message).Show()
    exMerchant.clearActorFromAlias()
    Merchants.RemoveAddedForm(akMerchant)
    filledMerchantAliases[LastFoundMerchant] = NONE
    NextOpenAlias = LastFoundMerchant
    Logger("Actor cleared from alias!!!")
EndFunction

Function RemoveThisMerchant(BusinessScript thisMerchant)
    Merchants.RemoveAddedForm(thisMerchant.GetActorReference())
    int index = filledMerchantAliases.Find(thisMerchant)
    Logger("The index for this merchant is " + index + " and the merchant name from that index is: " + filledMerchantAliases[index].GetActorName())
    FixedMerchantProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedMerchantProperties.aaslrNumberOfMerchants)
    (FixedMerchantProperties.RemovedMerchantMessageFormList.GetAt(index) as Message).Show()
    thisMerchant.ClearActorFromAlias()
    filledMerchantAliases[index] = NONE
    NextOpenAlias = index
    Logger("Removed this merchant")
EndFunction

Function RemoveThisDeadDisabledMerchant(BusinessScript thisMerchant, bool isDead)
    Merchants.RemoveAddedForm(thisMerchant.GetActorReference())
    int index = filledMerchantAliases.Find(thisMerchant)
    Logger("The index for this merchant is " + index + " and the merchant name from that index is: " + filledMerchantAliases[index].GetActorName())
    FixedMerchantProperties.SetNumMerchantsGlobal(-1.0)
    myQuest.UpdateCurrentInstanceGlobal(FixedMerchantProperties.aaslrNumberOfMerchants)
    if isDead
        (FixedMerchantProperties.DeadMerchantRemovedMessageFormList.GetAt(index) as Message).Show()
    else
        (FixedMerchantProperties.DisabledDeletedMerchantMessageFormList.GetAt(index) as Message).Show()
    endIf
    thisMerchant.ClearActorFromAlias()
    filledMerchantAliases[index] = NONE
    NextOpenAlias = index
    Logger("Removed this merchant")
EndFunction

Function RemoveAllMerchants()
    int numMerchants = merchantAliasScripts.Length
    Logger("About to remove all Merchants")
    BusinessScript thisMerhcant
    While (numMerchants)
        numMerchants -= 1
        thisMerhcant = filledMerchantAliases[numMerchants]
        If (thisMerhcant)
            Logger("About to clear: " + thisMerhcant.GetActorName())
            thisMerhcant.ClearActorFromAlias()
            filledMerchantAliases[numMerchants] = NONE
        EndIf
    EndWhile
    FixedMerchantProperties.aaslrNumberOfMerchants.SetValue(0.0)
    Merchants.Revert()
    NextOpenAlias = 0
    myQuest.UpdateCurrentInstanceGlobal(FixedMerchantProperties.aaslrNumberOfMerchants)
    FixedMerchantProperties.RemovedAllMerchantsMessage.Show()
EndFunction

;Changes the vender chest reference using the passed in string as key
Function ChangeChestType(Actor akMerchant, string chestType)
    bool success
    If (Merchants.HasForm(akMerchant))
        BusinessScript merchant = GetMerchant(akMerchant)
        If (merchant)            
            success = merchant.changeChestType(chestType)
            Logger("Chest type changed to: " + chestType)
        EndIf
    EndIf
EndFunction

Function YHShowBarterMenu(Actor akSpeaker)
    Logger("In YHShowBarterMenu!!!!!")
    If (Merchants.HasForm(akSpeaker))
        Logger("We found the merchant: " + akSpeaker.GetBaseObject().GetName())
        BusinessScript merchant = GetMerchant(akSpeaker)
        If (merchant)
            FixedMerchantProperties.IsManagedMerchantTrading = true
            If (FixedMerchantProperties.EnableHotKeyUse)
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
    If (Merchants.HasForm(akFence))
        BusinessScript newFence = GetMerchant(akFence)
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
    While (index < filledMerchantAliases.Length)
        foundMerchant = merchantAliasScripts[index]
        If (foundMerchant && foundMerchant.GetActorReference() == akMerchant)
            LastFoundMerchant = index
            return foundMerchant
        EndIf
        index += 1
    EndWhile
    return none
EndFunction

Function ResetChest(Actor akMerchant)
    BusinessScript merchantToReset = GetMerchant(akMerchant)
    if(merchantToReset)
        merchantToReset.MerchantChestScript.ResetChest(false)
    endIf

EndFunction