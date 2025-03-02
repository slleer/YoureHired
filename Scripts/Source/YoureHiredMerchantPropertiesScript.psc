Scriptname YoureHiredMerchantPropertiesScript extends Quest  
{This is a helper script that holds properties needed by the BusinessManager script to avoid having multiple references to the same static properties}

Import YHUtil

Actor property PlayerRef auto
Faction property JobMerchantFaction auto
Faction property YoureHiredFenceFaction auto
ObjectReference property BlankChestRef auto
MerchantScript property MerchantManager auto
YoureHiredVanillaManagerScript property YHVanillaManagerScript auto

ObjectReference property InvMerchantStand auto
ObjectReference property InvRugSleepMarker auto
ObjectReference[] property StallActivatorsCurrent auto
ObjectReference[] property RugActivatorsCurrent auto
MiscObject property gold auto

GlobalVariable property aaslrNumberOfMerchants auto
GlobalVariable property aaslrMaxNumberMerchants auto
GlobalVariable property aaslrMaxGoldValueGlobal auto
GlobalVariable[] property MerchantStall_PackageEnable auto
GlobalVariable[] property MerchantSleep_PackageEnable auto

GlobalVariable property aaslrResetVanillaFlagGlobal auto
GlobalVariable property aaslrAllowBeastsFlag auto
GlobalVariable property aaslrAllowChildrenFlag auto

FormList property AddedMerchantMessageFormList auto
FormList property RemovedMerchantMessageFormList auto
FormList property DeadMerchantRemovedMessageFormList auto
FormList property DisabledDeletedMerchantMessageFormList auto
Message property FailedAddMerchantMessage auto
Message property FullMerchantListMessage auto
Message property RemovedAllMerchantsMessage auto

FormList property JobTypesFactionList auto
FormList property MerchantChestList auto

;Used for identifing actors to add job type factions to
FormList property aaslrYoureHiredVoiceTypeJobFactionsFormList auto
FormLIst property aaslrPlayableRacesFormList auto
FormList property aaslrVoicesNPCsNOCHILD auto
FormList property aaslrAnimalVoiceTypes auto
FormList property aaslrVoicesApothecary auto
FormList property aaslrVoicesBlacksmith auto
FormList property aaslrVoicesFence auto
FormList property aaslrVoicesTownInnkeeper auto
FormList property aaslrVoicesJeweler auto
FormList property aaslrVoicesMisc auto
FormList property aaslrVoicesMagic auto
FormList property aaslrVoicesTailor auto

bool property IsManagedMerchantTrading auto
bool property LowCountReset auto
bool property RequireTwoKeys = true auto
bool property EnableHotKeyUse auto
bool property ResetOnMenuClose auto
float property DaysBeforeReset = 2.0 auto
int property Hotkey auto
int property SecondaryHotkey auto

string[] ChestTypeText
string[] VoiceTypeText
bool AtLeastOneMerchant
bool showDropMessage = true
bool MerchantsAreFull
bool DestroyOnRemoval = true
bool NeedToUpdateMerchantChests
bool ToggleBetweenMenuOrGametimeReset
bool updateVanillaMerchantFaction

int MerchantChestListSize
int NumMerchants



float _maxGoldValue
float property MaxGoldValue 
    Function Set(float maxGold)
        aaslrMaxGoldValueGlobal.SetValue(maxGold)
        _maxGoldValue = maxGold
    EndFunction 
    float Function Get()
        return _maxGoldValue
    EndFunction
endProperty

Event OnInit()
    AddLineBreakWithText(self + "In the OnInit")
    StallActivatorsCurrent = new ObjectReference[12]
    RugActivatorsCurrent = new ObjectReference[12]
    MerchantChestListSize = MerchantChestList.GetSize()
    MaxGoldValue = aaslrMaxGoldValueGlobal.GetValue()
    NumMerchants = 0
    int numFactions = JobTypesFactionList.GetSize()
    int numVoiceFactions = aaslrYoureHiredVoiceTypeJobFactionsFormList.GetSize()
    ChestTypeText = Utility.CreateStringArray(numFactions)
    VoiceTypeText = Utility.CreateStringArray(numVoiceFactions)
    while numVoiceFactions
        numFactions -= 1
        numVoiceFactions -= 1
        If numFactions >= 0
            ChestTypeText[numFactions] = JobTypesFactionList.GetAt(numFactions).GetName()
        EndIf
        VoiceTypeText[numVoiceFactions] = aaslrYoureHiredVoiceTypeJobFactionsFormList.GetAt(numVoiceFactions).GetName()
    endWhile
EndEvent

Function AddRugActivatorToList(ObjectReference thisActivator, BusinessScript owningMerchant)
    int index = owningMerchant.GetMerchantIndex()
    if index > -1
        If (RugActivatorsCurrent[index])
            if RugActivatorsCurrent[index] != thisActivator
                (RugActivatorsCurrent[index] as MerchantStallActivationScript).DestroyThisMerchantStand()
            endIf
        EndIf
        RugActivatorsCurrent[index] = thisActivator
    else
        Log(self + "No empty spaces found when trying to put rug activator into array.")
    endIf
EndFunction


Function RemoveRugActivatorFromList(ObjectReference thisActivator)
    int index = RugActivatorsCurrent.Find(thisActivator)
    if index > -1
        RugActivatorsCurrent[index] = none
    endIf
EndFunction

RugActivationScript Function GetRugActivatorAsScript(int index)
    return (RugActivatorsCurrent[index] as RugActivationScript)
EndFunction

Function AddStallActivatorToList(ObjectReference thisActivator, BusinessScript owningMerchant)
    int index = owningMerchant.GetMerchantIndex()
    if index > -1
        If (StallActivatorsCurrent[index])
            if StallActivatorsCurrent[index] != thisActivator
                (StallActivatorsCurrent[index] as MerchantStallActivationScript).DestroyThisMerchantStand()
            endIf
        EndIf
        StallActivatorsCurrent[index] = thisActivator
    else
        Log(self + "No empty spaces found when trying to put stall activator into array.")
    endIf
EndFunction

Function RemoveStallActivatorFromList(ObjectReference thisActivator)
    int index = StallActivatorsCurrent.Find(thisActivator)
    if index > -1
        StallActivatorsCurrent[index] = none
    endIf
EndFunction

MerchantStallActivationScript Function GetStallActivatorAsScript(int index)
    return (StallActivatorsCurrent[index] as MerchantStallActivationScript)
EndFunction

bool Function HasAtLeastOneMerchant()
    return AtLeastOneMerchant
EndFunction

ObjectReference Function GetInventoryStand()
    return InvMerchantStand.PlaceAtMe(InvMerchantStand.GetBaseObject(), 1, true, false)
EndFunction

ObjectReference Function GetInvRugSleepMarker()
    Log(self + " InvRugSleepMarker: " + InvRugSleepMarker)
    return InvRugSleepMarker.PlaceAtMe(InvRugSleepMarker.GetBaseObject(), 1, true, false)
EndFunction



Function SendListeningCommands()
    int index = StallActivatorsCurrent.Length
    while index
        index -= 1
        if StallActivatorsCurrent[index]
            (StallActivatorsCurrent[index] as MerchantStallActivationScript).ListenForModEvents()
        endIf
        if RugActivatorsCurrent[index]
            (RugActivatorsCurrent[index] as RugActivationScript).ListenForModEvents()
        endIf
    endWhile
EndFunction

string[] Function GetChestTypeText()
    return ChestTypeText
EndFunction

Function SetShowDropMessage(bool show)
    showDropMessage = show
EndFunction

bool Function GetShowDropMessage()
    return showDropMessage
EndFunction

bool Function IsDestroyOnRemoval()
    return DestroyOnRemoval
EndFunction

Function SetDestroyOnRemoval(bool destroy)
    DestroyOnRemoval = destroy
EndFunction

Faction Function GetFactionByString(string chestType)
    return JobTypesFactionList.GetAt(ChestTypeText.Find(chestType)) as Faction
EndFunction

Faction Function GetVoiceTypeFactionByString(string chestType)
    return aaslrYoureHiredVoiceTypeJobFactionsFormList.GetAt(VoiceTypeText.Find(chestType)) as Faction
EndFunction

int Function GetNumMerchantsGlobal()
    return NumMerchants
EndFunction

Function SetToggleBetweenMenuOrGametimeReset(bool reset = true)
    ToggleBetweenMenuOrGametimeReset = reset
EndFunction

bool Function GetToggleBetweenMenuOrGametimeReset()
    return ToggleBetweenMenuOrGametimeReset
EndFunction

Function SetNeedToUpdateMerchantChests(bool reset = true)
    NeedToUpdateMerchantChests = reset
EndFunction

bool Function GetNeedToUpdateMerchantChests()
    return NeedToUpdateMerchantChests
EndFunction

Function SetUpdateVanillaMerchantFaction(bool reset = true)
    updateVanillaMerchantFaction = reset
EndFunction

bool Function GetUpdateVanillaMerchantFaction()
    return updateVanillaMerchantFaction
EndFunction

Function SetNumMerchantsGlobal(float numDiff)
    ; int numMerchants = aaslrNumberOfMerchants.GetValueInt() + numDiff
    numMerchants = aaslrNumberOfMerchants.mod(numDiff) as int
    AtLeastOneMerchant = (numMerchants > 0)
    MerchantsAreFull = (numMerchants == aaslrMaxNumberMerchants.GetValue() as int)
EndFunction

;hellper function to get the appropriate chest from Formlist
Form Function getChestBase(string chestType)
    int index = MerchantChestListSize
    While (index)
        index -= 1
        If (chestType == MerchantChestList.GetAt(index).GetName())
            return MerchantChestList.GetAt(index)
        EndIf
    EndWhile
EndFunction



Form Function GetRandomChestType()
    int random = Utility.RandomInt(0, MerchantChestList.GetSize() - 1)
    return MerchantChestList.GetAt(random)
EndFunction



; aaslrYHMerchantChestRoomCell
; aaslrLayOffFlagGlobal
; aaslrNowHiringFlagGlobal
; aaslrNumberOfMerchants
; aaslrRepeatCustomerFlagGlobal