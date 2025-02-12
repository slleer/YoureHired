Scriptname YoureHiredMerchantPropertiesScript extends Quest  
{This is a helper script that holds properties needed by the BusinessManager script to avoid having multiple references to the same static properties}
Actor property PlayerRef auto
Faction property JobMerchantFaction auto
Faction property YoureHiredFenceFaction auto
ObjectReference property BlankChestRef auto
MerchantScript property MerchantManager auto
YoureHiredVanillaManagerScript property YHVanillaManagerScript auto

ObjectReference property MerchantStand auto
ObjectReference property InvMerchantStand auto
ObjectReference property CounterLeanIdleRef auto
ObjectReference[] property ActivatorsCurrent auto
ObjectReference property xmarker auto
Furniture property StallIdleFurniture auto
Static property MarketStallStaic auto
Activator property StallManagementActivator auto

GlobalVariable property aaslrNumberOfMerchants auto
GlobalVariable property aaslrMaxNumberMerchants auto
GlobalVariable property aaslrResetVanillaFlagGlobal auto
GlobalVariable property aaslrAllowBeastsFlag auto
GlobalVariable property aaslrAllowChildrenFlag auto
GlobalVariable property aaslrFenceWantedFlag auto
GlobalVariable property aaslrNowHiringFlagGlobal auto
GlobalVariable property aaslrRepeatCustomerFlagGlobal auto
GlobalVariable property aaslrBonusStockGlobal auto
GlobalVariable property aaslrResetAllActorsChestsFlagGlobal auto
GlobalVariable property aaslrMaxGoldValueGlobal auto
GlobalVariable[] property BonusMerchantGoldGlobals auto
GlobalVariable[] property Merchant_PackageEnable auto


FormList property AddedMerchantMessageFormList auto
FormList property RemovedMerchantMessageFormList auto
FormList property DeadMerchantRemovedMessageFormList auto
FormList property DisabledDeletedMerchantMessageFormList auto
Message property FailedAddMerchantMessage auto
Message property FullMerchantListMessage auto
Message property RemovedAllMerchantsMessage auto

string[] property ChestTypeText auto
string[] property VoiceTypeText auto
FormList property JobTypesFactionList auto
FormList property MerchantChestList auto

;Used for identifing actors to add job type factions to
FormList property aaslrYoureHiredVoiceTypeJobFactionsFormList auto
FormList property aaslrVoicesNPCsNOCHILD auto
FormList property aaslrVoicesNPCsCHILD auto
FormList property aaslrAnimalVoiceTypes auto
FormList property aaslrVoicesApothecary auto
FormList property aaslrVoicesBlacksmith auto
FormList property aaslrVoicesFence auto
FormList property aaslrVoicesTownInnkeeper auto
FormList property aaslrVoicesJeweler auto
FormList property aaslrVoicesMisc auto
FormList property aaslrVoicesMagic auto
FormList property aaslrVoicesTailor auto

bool property ShowDropMessage = true auto
bool property IsManagedMerchantTrading auto
bool property AtLeastOneMerchant auto
bool property MerchantsAreFull auto 
bool property LowCountReset auto
bool property RequireTwoKeys = true auto
bool property EnableHotKeyUse auto
bool property ResetOnMenuClose auto
float property DaysBeforeReset = 2.0 auto
int property Hotkey auto
int property SecondaryHotkey auto
int property UpdateNeeded auto
int property NeedToUpdateMerchantChests auto
int property ToggleBetweenMenuOrGametimeReset auto

MiscObject property gold auto

int MerchantChestListSize
int NumMerchants
bool ListeningForModEvent = false

int _extraGoldAmount
int property ExtraGoldAmount
    Function Set(int extra)
        _extraGoldAmount = extra
        if extra > 0
            extra /= 1000
        endIf
        extra -= 1
        int index = 0
        while index < BonusMerchantGoldGlobals.Length
            if index <= extra
                BonusMerchantGoldGlobals[index].SetValue(0.0)
            else
                BonusMerchantGoldGlobals[index].SetValue(100.0)
            endIf
            index += 1
        endWhile
    EndFunction
    int Function Get()
        return _extraGoldAmount
    EndFunction
EndProperty

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

bool _overStockedMerchant
bool property OverStockedcMerchant
    Function Set(bool stocked)
        _overStockedMerchant = stocked
        If (stocked)
            aaslrBonusStockGlobal.SetValue(0.0)
            Logger("Merchants are now overstocked")
        else
            aaslrBonusStockGlobal.SetValue(100.0)
            Logger("Merchants are no longer overstocked")
        EndIf
    EndFunction
    bool Function Get()
        return _overStockedMerchant
    EndFunction
EndProperty



Event OnInit()
    Logger("In the OnInit", logType = 2)
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
    ListenForModEvent(true)
EndEvent

Function AddActivatorToList(ObjectReference thisActivator)
    int index = ActivatorsCurrent.Find(NONE)
    if index > -1
        ActivatorsCurrent[index] = thisActivator
    else
        Logger("No empty spaces found when trying to put activator into array.")
    ;     index = ActivatorsCurrent.Find(thisActivator)
    ;     If index < 0
    ;         index = ActivatorsCurrent.Length
    ;         while index
    ;             index -= 1
    ;             if (ActivatorsCurrent[index] as MerchantStallActivationScript).GetOwningMerchant() == (thisActivator as MerchantStallActivationScript).GetOwningMerchant()
                    
    ;             endIf
    ;         endWhile
            
    ;     EndIf
    endIf
EndFunction

Function RemoveActivatorFromList(ObjectReference thisActivator)
    int index = ActivatorsCurrent.Find(thisActivator)
    if index > -1
        ActivatorsCurrent[index] = none
    endIf
EndFunction

Event PlaceMerchantStand(string eventName, string strArg, float numArg, Form sender)
    Logger("We are in the custom event: " + eventName + ", strArg: " + strArg + ", numArg: " + numArg + ", Sender: " + sender)
EndEvent

ObjectReference Function GetInventoryStand()
    return InvMerchantStand.PlaceAtMe(InvMerchantStand.GetBaseObject(), 1, true, false)
    ; ObjectReference temp = InvMerchantStand
    ; InvMerchantStand = temp.PlaceAtMe(temp.GetBaseObject(), 1, true, false)
    ; return temp
EndFunction

Function SendListeningCommands()
    int index = ActivatorsCurrent.Length
    while index
        index -= 1
        if ActivatorsCurrent[index]
            (ActivatorsCurrent[index] as MerchantStallActivationScript).ListenForModEvents()
        endIf
    endWhile
EndFunction

Function ListenForModEvent(bool listen)
    If (ListeningForModEvent == listen)
        return
    EndIf
    If (ListeningForModEvent)
        UnregisterForModEvent("aaslrYH_PlaceMerchantStand")
        ListeningForModEvent = listen
        return
    EndIf
    Logger("We are now listening")
    RegisterForModEvent("aaslrYH_PlaceMerchantStand", "PlaceMerchantStand")
    ListeningForModEvent = listen
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("MerchantProperties - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MerchantProperties - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
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

Function SetUpdateNeeded()
    Logger("UpdateNeeded before: " + UpdateNeeded)
    UpdateNeeded += 1
    Logger("UpdateNeeded After: " + UpdateNeeded)
EndFunction

Function SetToggleBetweenMenuOrGametimeReset()
    Logger("Toggle between menu or gametime, Before inc: " + ToggleBetweenMenuOrGametimeReset)
    ToggleBetweenMenuOrGametimeReset += 1
    Logger("Toggle between menu or gametime, After inc: " + ToggleBetweenMenuOrGametimeReset)
EndFunction

Function SetNeedToUpdateMerchantChests()
    Logger("Need to update merchant chests Before increment: " + NeedToUpdateMerchantChests)
    NeedToUpdateMerchantChests += 1
    Logger("Need to update merchant chests After increment: " + NeedToUpdateMerchantChests)
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