Scriptname YoureHiredMCM extends SKI_ConfigBase

YoureHiredMerchantPropertiesScript property FixedProperties auto
Quest property YoureHired auto


GlobalVariable property aaslrBonusStockGlobal auto
GlobalVariable property aaslrFenceWantedFlag auto
GlobalVariable property aaslrRepeatCustomerFlagGlobal auto
GlobalVariable property aaslrNowHiringFlagGlobal auto
GlobalVariable[] property BonusMerchantGoldGlobals auto

Import YHUtil

; Merchant Manager properties
string property MM_NuberOfMerchantsText auto
string property MM_SelectedMerchantName auto
string property MM_SelectedJobType auto
string property MM_ClickHereText auto
string[] property MM_MerchantNames auto
string[] property MM_JobTypes auto
BusinessScript property MM_ThisMerchant auto
BusinessScript[] property MM_MerchantsList auto
bool property MM_OptionsEnabled auto
bool property MM_FenceFlag auto

int _merchantsObjectiveStage
int property MM_MerchantsObjectiveStage
    int Function Get()
        If (MM_ThisMerchant)
            _merchantsObjectiveStage = (MM_ThisMerchant.GetMerchantIndex() + 1) * 10
        else
            _merchantsObjectiveStage = 0
        EndIf
        return _merchantsObjectiveStage
    EndFunction
EndProperty 

bool _sleepAtHome 
bool property MM_LiveAtHome 
    Function Set(bool live)
        if MM_ThisMerchant
            RugActivationScript rugScript = FixedProperties.GetRugActivatorAsScript(MM_ThisMerchant.GetMerchantIndex())
            if live && rugScript
                rugScript.EnableSleepPackage()
            elseIf rugScript
                rugScript.DisableSleepPackage()
            else
                live = false
            endIF
        else
            live = false
        endIf
        _sleepAtHome = live
    EndFunction
    bool Function Get()
        if MM_ThisMerchant
            RugActivationScript rugScript = FixedProperties.GetRugActivatorAsScript(MM_ThisMerchant.GetMerchantIndex())
            if rugScript
                _sleepAtHome = rugScript.IsSleepPackageEnabled()
            endIf
        endIf
        return _sleepAtHome
    EndFunction
EndProperty

bool _workAtStall
bool property MM_WorkAtStall
    Function Set(bool work)
        if MM_ThisMerchant
            MerchantStallActivationScript stallScript = FixedProperties.GetStallActivatorAsScript(MM_ThisMerchant.GetMerchantIndex())
            if work && stallScript
                stallScript.EnableStallPackage()
            elseIf stallScript
                stallScript.DisableStallPackage()
            else
                work = false
            endIf
        else 
            work = false
        endIf
        _workAtStall = work
    EndFunction
    bool Function Get()
        if MM_ThisMerchant
            MerchantStallActivationScript stallScript = FixedProperties.GetStallActivatorAsScript(MM_ThisMerchant.GetMerchantIndex())
            if stallScript
                _workAtStall = stallScript.IsMerchantStallPackageEnabled()
            endIf
        endIf
        return _workAtStall
    EndFunction
EndProperty

bool _locateMerchant
bool property MM_LocateMerchant 
    Function Set(bool locate)
        _locateMerchant = locate
        if  locate
            MM_ThisMerchant.LocateMerchant()            
        else
            MM_ThisMerchant.LocateMerchant(false)
        endIf
    EndFunction
    bool Function Get()
        return _locateMerchant
    EndFunction
EndProperty

; Merchant Manger ids
int property oid_MerchantManager_NumberOfMerchantsText auto
int property oid_MerchantManager_MerchantsList auto
int property oid_MerchantManager_JobTypesList auto
int property oid_MerchantManager_FenceToggle auto
int property oid_MerchantManager_ClearMerchant auto
int property oid_MerchantManager_ClearAllMerchants auto
int property oid_MerchantManager_LocateMerchant auto
int property oid_MerchantManager_EnableWorkAtStall auto
int property oid_MerchantManager_EnableLiveAtHome auto


; Settings properties
bool property S_AllowChildren auto
bool property S_AllowAnimals auto
bool property S_ResetVanillaEnabled auto
bool property S_RequireTwoKeys auto
bool property S_EnableHotKeyUse auto
bool property S_ResetOnMenuClose auto
bool property S_LowCountReset auto
bool property S_ShowDropMessage auto
bool property S_DestroyOnRemoval auto
bool property S_AutoSellJunk auto
; bool property S_VanillaHotkeyEnabled auto
float property S_NumDaysBetweenReset auto
float property S_MaxGoldInChest auto
int property S_Hotkey auto
int property S_SecondaryHotkey auto
int property S_MinGOldAmount auto




bool _enableDoubleMerchant
bool property S_DoubleMerchantEnabled
    Function Set(bool enable)
        if enable
            aaslrRepeatCustomerFlagGlobal.SetValueInt(1)
        else
            aaslrRepeatCustomerFlagGlobal.SetValueInt(0)
        endIf
        _enableDoubleMerchant = enable
    EndFunction
    bool Function Get()
        return _enableDoubleMerchant
    EndFunction 
endProperty

bool _recruitementDialogueEnabled
bool property S_RecruitmentEnabled
    Function Set(bool enable)
        if enable
            aaslrNowHiringFlagGlobal.SetValueInt(1)
        else
            aaslrNowHiringFlagGlobal.SetValueInt(0)
        endIf
        _recruitementDialogueEnabled = enable
    endFunction
    bool Function Get()
        return _recruitementDialogueEnabled
    endFunction
endProperty

bool _overStockedMerchant 
bool property S_OverStockedEnabled
    Function Set(bool stocked)
        _overStockedMerchant = stocked
        If (stocked)
            aaslrBonusStockGlobal.SetValue(0.0)
        else
            aaslrBonusStockGlobal.SetValue(100.0)
        EndIf
    EndFunction
    bool Function Get()
        return _overStockedMerchant
    EndFunction
EndProperty

int _extraGoldAmount
int property S_ExtraStartingGold
    Function Set(int extra)
        _extraGoldAmount = extra
        extra /= 1000
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

bool _fenceDialogueEnabled 
bool property S_FenceDialogueEnabled 
    Function Set(bool enable)
        if enable
            aaslrFenceWantedFlag.SetValue(1.0)
        else
            aaslrFenceWantedFlag.SetValue(0.0)
        endIf
        _fenceDialogueEnabled = enable
    EndFunction
    bool Function Get()
        return _fenceDialogueEnabled
    endFunction
endProperty


; Settings ids
int property oid_Settings_AllowChildren auto
int property oid_Settings_AllowAnimals auto
int property oid_Settings_FenceEnabled auto
int property oid_Settings_RecruitmentEnabled auto
int property oid_Settings_DoubleMerchantEnabled auto
int property oid_Settings_ResetVanillaEnabled auto
int property oid_Settings_DaysBetweenReset auto
int property oid_Settings_ResetOnMenuClose auto
int property oid_Settings_ShowDropMessage auto
int property oid_Settings_AutoSellJunk auto
; int property oid_Settings_VanillaHotkeyEnabled auto
int property oid_Settings_EnableHotKeyUse auto
int property oid_Settings_RequireTwoKeys auto
int property oid_Settings_ResetHotkey auto
int property oid_Settings_SecondaryResetHotkey auto
int property oid_Settings_LowCountReset auto
int property oid_Settings_DestroyOnRemoval auto 
int property oid_Settings_OverStockedMerchants auto
int property oid_Settings_ExtraStartingGold auto
int property oid_Settings_MaxGoldInChest auto

int function GetVersion()
    return 1
endFunction

Event OnConfigInit()
    S_AllowAnimals = false
    S_AllowChildren = false
    S_FenceDialogueEnabled = false
    S_RecruitmentEnabled = false
    S_DoubleMerchantEnabled = false
    S_ResetVanillaEnabled = false
    S_ShowDropMessage = FixedProperties.GetShowDropMessage()
    S_EnableHotKeyUse = FixedProperties.EnableHotKeyUse
    S_RequireTwoKeys = FixedProperties.RequireTwoKeys
    S_MaxGoldInChest = FixedProperties.MaxGoldValue ;6800.0
    S_MinGOldAmount = 1800
    S_NumDaysBetweenReset = FixedProperties.DaysBeforeReset
    S_ResetOnMenuClose = FixedProperties.ResetOnMenuClose
    S_LowCountReset = FixedProperties.LowCountReset
    S_DestroyOnRemoval = FixedProperties.IsDestroyOnRemoval()
    S_ExtraStartingGold = 0
    S_OverStockedEnabled = false
    If (Game.UsingGamepad())
        S_Hotkey = 281 ; R-Trigger
        S_SecondaryHotkey = 280 ; L-Trigger
    Else
        S_Hotkey = 38 ; L
        S_SecondaryHotkey = 157 ; R crtl
    EndIf
    FixedProperties.Hotkey = S_Hotkey
    FixedProperties.SecondaryHotkey = S_SecondaryHotkey
    MM_FenceFlag = false
    MM_OptionsEnabled = false
    MM_SelectedMerchantName = "Select A Merchant"
    MM_SelectedJobType = "Current Merchant Type"
    MM_ClickHereText = "Click Here"
    MM_LocateMerchant = false
    
    ModName = "You're Hired!"
    Pages = new string[3]
    Pages[0] = YoureHiredMCM_SettingsPage.GetPageName()
    Pages[1] = YoureHiredMCM_MerchantManagementPage.GetPageName()
    Pages[2] = YoureHiredMCM_StoreManagerPage.GetPageName()
EndEvent


Event OnPageReset(string page)
    RenderHomePage()
    if page == YoureHiredMCM_HomePage.GetPageName()
        YoureHiredMCM_HomePage.RenderPage(self, page)
    elseif page == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.RenderPage(self, page)
    elseif page == YoureHiredMCM_MerchantManagementPage.GetPageName()
        if !MM_MerchantsList
            MM_MerchantsList = FixedProperties.MerchantManager.GetMerchantAliasScripts()
        endIf
        If !MM_JobTypes
            MM_JobTypes = FixedProperties.GetChestTypeText()
        EndIf
        MM_MerchantNames = FixedProperties.MerchantManager.GetMerchantNames()
        YoureHiredMCM_MerchantManagementPage.RenderPage(self, page)
    elseif page == YoureHiredMCM_StoreManagerPage.GetPageName()
        YoureHiredMCM_StoreManagerPage.RenderPage(self, page)
    endIf
EndEvent

Function RenderHomePage()
    If (CurrentPage == "")
        LoadCustomContent("YoureHired!/YoureHiredMCM.dds")
    else
        UnloadCustomContent()
    EndIf
EndFunction

Event OnOptionHighlight(int optionId)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnHighlight(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()        
        YoureHiredMCM_MerchantManagementPage.OnHighlight(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_StoreManagerPage.GetPageName()
        YoureHiredMCM_StoreManagerPage.OnHighlight(self, optionId)
    endIf
EndEvent

Event OnOptionSelect(int optionId)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnSelect(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()        
        YoureHiredMCM_MerchantManagementPage.OnSelect(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_StoreManagerPage.GetPageName()
        YoureHiredMCM_StoreManagerPage.OnSelect(self, optionId)
    endIf
EndEvent

Event OnOptionDefault(int optionId)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnDefault(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()        
        YoureHiredMCM_MerchantManagementPage.OnDefault(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_StoreManagerPage.GetPageName()
        YoureHiredMCM_StoreManagerPage.OnDefault(self, optionId)
    endIf
EndEvent

Event OnOptionMenuOpen(int option)
    if CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()        
        YoureHiredMCM_MerchantManagementPage.OnMenuOpen(self, option)
    elseIf CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
    endIf
EndEvent

Event OnOptionMenuAccept(int option, int index)
    if CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()
        YoureHiredMCM_MerchantManagementPage.OnMenuAccept(self, option, index)
    ; elseIf CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
    endIf
EndEvent

Event OnOptionSliderOpen(int optionId)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnSliderOpen(self, optionId)
    elseIf CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()
        YoureHiredMCM_MerchantManagementPage.OnSliderOpen(self, optionId)
    endIf
EndEvent

Event OnOptionSliderAccept(int optionId, float value)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnSliderAccept(self, optionId, value)
    elseIf CurrentPage == YoureHiredMCM_MerchantManagementPage.GetPageName()
        YoureHiredMCM_MerchantManagementPage.OnSliderAccept(self, optionId, value)
    endIf
EndEvent

event OnOptionKeyMapChange(int optionId, int keyCode, string conflictControl, string conflictName)
    if CurrentPage == YoureHiredMCM_SettingsPage.GetPageName()
        YoureHiredMCM_SettingsPage.OnKeyMapChanged(self, optionId, keyCode, conflictControl, conflictName)
    endIf
EndEvent


; toggle inventory lists
GlobalVariable property aaslrYH1HMaceAAOGlobal auto
int property oid_Inventory_Mace_AAO auto
bool _maceAAO 
bool property I_MaceAllAtOnce
    Function Set(bool aao)
        _maceAAO = aao
        If (aao)
            aaslrYH1HMaceAAOGlobal.SetValueInt(0)
        else
            aaslrYH1HMaceAAOGlobal.SetValueInt(100)
        EndIf
        Log(Self + " global value is now: " + aaslrYH1HMaceAAOGlobal.GetValueInt())
    EndFunction
    bool Function Get()
        return _maceAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH1HMaceLVLLGlobal auto
int property oid_Inventory_Mace_LVLL auto
bool _maceLVLL 
bool property I_MaceLevelList
    Function Set(bool lvll)
        _maceLVLL = lvll
        If (lvll)
            aaslrYH1HMaceLVLLGlobal.SetValueInt(0)
        else
            aaslrYH1HMaceLVLLGlobal.SetValueInt(100)
        EndIf
        Log(Self + " global value is now: " + aaslrYH1HMaceLVLLGlobal.GetValueInt())
    EndFunction
    bool Function Get()
        return _maceLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYH1HSwordAAOGlobal auto
int property oid_Inventory_Sword_AAO auto
bool _swordAAO 
bool property I_SwordAllAtOnce
    Function Set(bool aao)
        _swordAAO = aao
        If (aao)
            aaslrYH1HSwordAAOGlobal.SetValueInt(0)
        else
            aaslrYH1HSwordAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _swordAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH1HSwordLVLLGlobal auto
int property oid_Inventory_Sword_LVLL auto
bool _swordLVLL
bool property I_SwordLevelList
    Function Set(bool lvll)
        _swordLVLL = lvll
        If (lvll)
            aaslrYH1HSwordLVLLGlobal.SetValueInt(0)
        else
            aaslrYH1HSwordLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _swordLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYH1HWarAxeAAOGlobal auto
int property oid_Inventory_Waraxe_AAO auto
bool _warAxeAAO 
bool property I_WarAxeAllAtOnce
    Function Set(bool aao)
        _warAxeAAO = aao
        If (aao)
            aaslrYH1HWarAxeAAOGlobal.SetValueInt(0)
        else
            aaslrYH1HWarAxeAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _warAxeAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH1HWarAxeLVLLGlobal auto
int property oid_Inventory_Waraxe_LVLL auto
bool _warAxeLVLL
bool property I_WarAxeLevelList
    Function Set(bool lvll)
        _warAxeLVLL = lvll
        If (lvll)
            aaslrYH1HWarAxeLVLLGlobal.SetValueInt(0)
        else
            aaslrYH1HWarAxeLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _warAxeLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HBattleAxeAAOGlobal auto
int property oid_Inventory_Battleaxe_AAO auto
bool _battleAxeAAO 
bool property I_BattleAxeAllAtOnce
    Function Set(bool aao)
        _battleAxeAAO = aao
        If (aao)
            aaslrYH2HBattleAxeAAOGlobal.SetValueInt(0)
        else
            aaslrYH2HBattleAxeAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _battleAxeAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HBattleAxeLVLLGlobal auto
int property oid_Inventory_Battleaxe_LVLL auto
bool _battleAxeLVLL
bool property I_BattleAxeLevelList
    Function Set(bool lvll)
        _battleAxeLVLL = lvll
        If (lvll)
            aaslrYH2HBattleAxeLVLLGlobal.SetValueInt(0)
        else
            aaslrYH2HBattleAxeLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _battleAxeLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HGreatSwordAAOGlobal auto
int property oid_Inventory_Greatsword_AAO auto
bool _greatSwordAAO 
bool property I_GreatSwordAllAtOnce
    Function Set(bool aao)
        _greatSwordAAO = aao
        If (aao)
            aaslrYH2HGreatSwordAAOGlobal.SetValueInt(0)
        else
            aaslrYH2HGreatSwordAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _greatSwordAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HGreatSwordLVLLGlobal auto
int property oid_Inventory_Greatsword_LVLL auto
bool _greatSwordLVLL
bool property I_GreatSwordLevelList
    Function Set(bool lvll)
        _greatSwordLVLL = lvll
        If (lvll)
            aaslrYH2HGreatSwordLVLLGlobal.SetValueInt(0)
        else
            aaslrYH2HGreatSwordLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _greatSwordLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HWarHammerAAOGlobal auto
int property oid_Inventory_Warhammer_AAO auto
bool _warHammerAAO 
bool property I_WarHammerAllAtOnce
    Function Set(bool aao)
        _warHammerAAO = aao
        If (aao)
            aaslrYH2HWarHammerAAOGlobal.SetValueInt(0)
        else
            aaslrYH2HWarHammerAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _warHammerAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYH2HWarHammerLVLLGlobal auto
int property oid_Inventory_Warhammer_LVLL auto
bool _warHammerLVLL
bool property I_WarHammerLevelList
    Function Set(bool lvll)
        _warHammerLVLL = lvll
        If (lvll)
            aaslrYH2HWarHammerLVLLGlobal.SetValueInt(0)
        else
            aaslrYH2HWarHammerLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _warHammerLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationSpellTomesAAOGlobal auto
int property oid_Inventory_AlterationSpellTomes_AAO auto
bool _alterationSpellTomesAAO 
bool property I_AlterationSpellTomesAllAtOnce
    Function Set(bool aao)
        _alterationSpellTomesAAO = aao
        If (aao)
            aaslrYHAlterationSpellTomesAAOGlobal.SetValueInt(0)
        else
            aaslrYHAlterationSpellTomesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationSpellTomesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationSpellTomesLVLLGlobal auto
int property oid_Inventory_AlterationSpellTomes_LVLL auto
bool _alterationSpellTomesLVLL
bool property I_AlterationSpellTomesLevelList
    Function Set(bool lvll)
        _alterationSpellTomesLVLL = lvll
        If (lvll)
            aaslrYHAlterationSpellTomesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHAlterationSpellTomesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationSpellTomesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationStavesAAOGlobal auto
int property oid_Inventory_AlterationStaves_AAO auto
bool _alterationStavesAAO 
bool property I_AlterationStavesAllAtOnce
    Function Set(bool aao)
        _alterationStavesAAO = aao
        If (aao)
            aaslrYHAlterationStavesAAOGlobal.SetValueInt(0)
        else
            aaslrYHAlterationStavesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationStavesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationStavesLVLLGlobal auto
int property oid_Inventory_AlterationStaves_LVLL auto
bool _alterationStavesLVLL
bool property I_AlterationStavesLevelList
    Function Set(bool lvll)
        _alterationStavesLVLL = lvll
        If (lvll)
            aaslrYHAlterationStavesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHAlterationStavesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationStavesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationRobesAAOGlobal auto
int property oid_Inventory_AlterationRobes_AAO auto
bool _alterationRobesAAO 
bool property I_AlterationRobesAllAtOnce
    Function Set(bool aao)
        _alterationRobesAAO = aao
        If (aao)
            aaslrYHAlterationRobesAAOGlobal.SetValueInt(0)
        else
            aaslrYHAlterationRobesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationRobesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHAlterationRobesLVLLGlobal auto
int property oid_Inventory_AlterationRobes_LVLL auto
bool _alterationRobesLVLL
bool property I_AlterationRobesLevelList
    Function Set(bool lvll)
        _alterationRobesLVLL = lvll
        If (lvll)
            aaslrYHAlterationRobesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHAlterationRobesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _alterationRobesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHBowAAOGlobal auto
int property oid_Inventory_Bow_AAO auto
bool _bowAAO 
bool property I_BowAllAtOnce
    Function Set(bool aao)
        _bowAAO = aao
        If (aao)
            aaslrYHBowAAOGlobal.SetValueInt(0)
        else
            aaslrYHBowAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _bowAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHBowLVLLGlobal auto
int property oid_Inventory_Bow_LVLL auto
bool _bowLVLL
bool property I_BowLevelList
    Function Set(bool lvll)
        _bowLVLL = lvll
        If (lvll)
            aaslrYHBowLVLLGlobal.SetValueInt(0)
        else
            aaslrYHBowLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _bowLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationSpellTomesAAOGlobal auto
int property oid_Inventory_ConjurationSpellTomes_AAO auto
bool _conjurationSpellTomesAAO 
bool property I_ConjurationSpellTomesAllAtOnce
    Function Set(bool aao)
        _conjurationSpellTomesAAO = aao
        If (aao)
            aaslrYHConjurationSpellTomesAAOGlobal.SetValueInt(0)
        else
            aaslrYHConjurationSpellTomesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationSpellTomesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationSpellTomesLVLLGlobal auto
int property oid_Inventory_ConjurationSpellTomes_LVLL auto
bool _conjurationSpellTomesLVLL
bool property I_ConjurationSpellTomesLevelList
    Function Set(bool lvll)
        _conjurationSpellTomesLVLL = lvll
        If (lvll)
            aaslrYHConjurationSpellTomesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHConjurationSpellTomesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationSpellTomesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationStavesAAOGlobal auto
int property oid_Inventory_ConjurationStaves_AAO auto
bool _conjurationStavesAAO 
bool property I_ConjurationStavesAllAtOnce
    Function Set(bool aao)
        _conjurationStavesAAO = aao
        If (aao)
            aaslrYHConjurationStavesAAOGlobal.SetValueInt(0)
        else
            aaslrYHConjurationStavesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationStavesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationStavesLVLLGlobal auto
int property oid_Inventory_ConjurationStaves_LVLL auto
bool _conjurationStavesLVLL
bool property I_ConjurationStavesLevelList
    Function Set(bool lvll)
        _conjurationStavesLVLL = lvll
        If (lvll)
            aaslrYHConjurationStavesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHConjurationStavesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationStavesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationRobesAAOGlobal auto
int property oid_Inventory_ConjurationRobes_AAO auto
bool _conjurationRobesAAO 
bool property I_ConjurationRobesAllAtOnce
    Function Set(bool aao)
        _conjurationRobesAAO = aao
        If (aao)
            aaslrYHConjurationRobesAAOGlobal.SetValueInt(0)
        else
            aaslrYHConjurationRobesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationRobesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHConjurationRobesLVLLGlobal auto
int property oid_Inventory_ConjurationRobes_LVLL auto
bool _conjurationRobesLVLL
bool property I_ConjurationRobesLevelList
    Function Set(bool lvll)
        _conjurationRobesLVLL = lvll
        If (lvll)
            aaslrYHConjurationRobesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHConjurationRobesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _conjurationRobesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHCrossbowAAOGlobal auto
int property oid_Inventory_Crossbow_AAO auto
bool _crossbowAAO 
bool property I_CrossbowAllAtOnce
    Function Set(bool aao)
        _crossbowAAO = aao
        If (aao)
            aaslrYHCrossbowAAOGlobal.SetValueInt(0)
        else
            aaslrYHCrossbowAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _crossbowAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHCrossbowLVLLGlobal auto
int property oid_Inventory_Crossbow_LVLL auto
bool _crossbowLVLL
bool property I_CrossbowLevelList
    Function Set(bool lvll)
        _crossbowLVLL = lvll
        If (lvll)
            aaslrYHCrossbowLVLLGlobal.SetValueInt(0)
        else
            aaslrYHCrossbowLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _crossbowLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHDaggerAAOGlobal auto
int property oid_Inventory_Dagger_AAO auto
bool _daggerAAO 
bool property I_DaggerAllAtOnce
    Function Set(bool aao)
        _daggerAAO = aao
        If (aao)
            aaslrYHDaggerAAOGlobal.SetValueInt(0)
        else
            aaslrYHDaggerAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _daggerAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHDaggerLVLLGlobal auto
int property oid_Inventory_Dagger_LVLL auto
bool _daggerLVLL
bool property I_DaggerLevelList
    Function Set(bool lvll)
        _daggerLVLL = lvll
        If (lvll)
            aaslrYHDaggerLVLLGlobal.SetValueInt(0)
        else
            aaslrYHDaggerLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _daggerLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionSpellTomesAAOGlobal auto
int property oid_Inventory_DestructionSpellTomes_AAO auto
bool _destructionSpellTomesAAO 
bool property I_DestructionSpellTomesAllAtOnce
    Function Set(bool aao)
        _destructionSpellTomesAAO = aao
        If (aao)
            aaslrYHDestructionSpellTomesAAOGlobal.SetValueInt(0)
        else
            aaslrYHDestructionSpellTomesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionSpellTomesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionSpellTomesLVLLGlobal auto
int property oid_Inventory_DestructionSpellTomes_LVLL auto
bool _destructionSpellTomesLVLL
bool property I_DestructionSpellTomesLevelList
    Function Set(bool lvll)
        _destructionSpellTomesLVLL = lvll
        If (lvll)
            aaslrYHDestructionSpellTomesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHDestructionSpellTomesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionSpellTomesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionRobesAAOGlobal auto
int property oid_Inventory_DestructionRobes_AAO auto
bool _destructionRobesAAO 
bool property I_DestructionRobesAllAtOnce
    Function Set(bool aao)
        _destructionRobesAAO = aao
        If (aao)
            aaslrYHDestructionRobesAAOGlobal.SetValueInt(0)
        else
            aaslrYHDestructionRobesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionRobesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionRobesLVLLGlobal auto
int property oid_Inventory_DestructionRobes_LVLL auto
bool _destructionRobesLVLL
bool property I_DestructionRobesLevelList
    Function Set(bool lvll)
        _destructionRobesLVLL = lvll
        If (lvll)
            aaslrYHDestructionRobesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHDestructionRobesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionRobesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionStavesAAOGlobal auto
int property oid_Inventory_DestructionStaves_AAO auto
bool _destructionStavesAAO 
bool property I_DestructionStavesAllAtOnce
    Function Set(bool aao)
        _destructionStavesAAO = aao
        If (aao)
            aaslrYHDestructionStavesAAOGlobal.SetValueInt(0)
        else
            aaslrYHDestructionStavesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionStavesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHDestructionStavesLVLLGlobal auto
int property oid_Inventory_DestructionStaves_LVLL auto
bool _destructionStavesLVLL
bool property I_DestructionStavesLevelList
    Function Set(bool lvll)
        _destructionStavesLVLL = lvll
        If (lvll)
            aaslrYHDestructionStavesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHDestructionStavesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _destructionStavesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachArrowsGlobal auto
int property oid_Inventory_ArrowsEach auto
bool _arrowsEach
bool property I_ArrowsEach
    Function Set(bool each)
        _arrowsEach = each
        If (each)
            aaslrYHEachArrowsGlobal.SetValueInt(0)
        else
            aaslrYHEachArrowsGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _arrowsEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachBloodPotionGlobal auto
int property oid_Inventory_BloodPotionEach auto
bool _bloodPotionEach
bool property I_BloodPotionEach
    Function Set(bool each)
        _bloodPotionEach = each
        If (each)
            aaslrYHEachBloodPotionGlobal.SetValueInt(0)
        else
            aaslrYHEachBloodPotionGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _bloodPotionEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachBoltsGlobal auto
int property oid_Inventory_BoltsEach auto
bool _boltsEach
bool property I_BoltsEach
    Function Set(bool each)
        _boltsEach = each
        If (each)
            aaslrYHEachBoltsGlobal.SetValueInt(0)
        else
            aaslrYHEachBoltsGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _boltsEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachEnchantmentsGlobal auto
int property oid_Inventory_EnchantmentsEach auto
bool _enchantmentsEach
bool property I_EnchantmentsEach
    Function Set(bool each)
        _enchantmentsEach = each
        If (each)
            aaslrYHEachEnchantmentsGlobal.SetValueInt(0)
        else
            aaslrYHEachEnchantmentsGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _enchantmentsEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachIngotsGlobal auto
int property oid_Inventory_IngotsEach auto
bool _ingotsEach
bool property I_IngotsEach
    Function Set(bool each)
        _ingotsEach = each
        If (each)
            aaslrYHEachIngotsGlobal.SetValueInt(0)
        else
            aaslrYHEachIngotsGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _ingotsEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachIngredientsGlobal auto
int property oid_Inventory_IngredientsEach auto
bool _ingredientsEach
bool property I_IngredientsEach
    Function Set(bool each)
        _ingredientsEach = each
        If (each)
            aaslrYHEachIngredientsGlobal.SetValueInt(0)
        else
            aaslrYHEachIngredientsGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _ingredientsEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachOresGlobal auto
int property oid_Inventory_OresEach auto
bool _oresEach
bool property I_OresEach
    Function Set(bool each)
        _oresEach = each
        If (each)
            aaslrYHEachOresGlobal.SetValueInt(0)
        else
            aaslrYHEachOresGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _oresEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachSoulGemsEmptyGlobal auto
int property oid_Inventory_SoulGemsEmptyEach auto
bool _soulGemsEmptyEach
bool property I_SoulGemsEmptyEach
    Function Set(bool each)
        _soulGemsEmptyEach = each
        If (each)
            aaslrYHEachSoulGemsEmptyGlobal.SetValueInt(0)
        else
            aaslrYHEachSoulGemsEmptyGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _soulGemsEmptyEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHEachSoulGemsFilledGlobal auto
int property oid_Inventory_SoulGemsFilledEach auto
bool _soulGemsFilledEach
bool property I_SoulGemsFilledEach
    Function Set(bool each)
        _soulGemsFilledEach = each
        If (each)
            aaslrYHEachSoulGemsFilledGlobal.SetValueInt(0)
        else
            aaslrYHEachSoulGemsFilledGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _soulGemsFilledEach
    EndFunction
EndProperty
GlobalVariable property aaslrYHHeavyArmorAAOGlobal auto
int property oid_Inventory_HeavyArmor_AAO auto
bool _heavyArmorAAO 
bool property I_HeavyArmorAllAtOnce
    Function Set(bool aao)
        _heavyArmorAAO = aao
        If (aao)
            aaslrYHHeavyArmorAAOGlobal.SetValueInt(0)
        else
            aaslrYHHeavyArmorAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _heavyArmorAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHHeavyArmorLVLLGlobal auto
int property oid_Inventory_HeavyArmor_LVLL auto
bool _heavyArmorLVLL
bool property I_HeavyArmorLevelList
    Function Set(bool lvll)
        _heavyArmorLVLL = lvll
        If (lvll)
            aaslrYHHeavyArmorLVLLGlobal.SetValueInt(0)
        else
            aaslrYHHeavyArmorLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _heavyArmorLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHHeavyShieldsAAOGlobal auto
int property oid_Inventory_HeavyShields_AAO auto
bool _heavyShieldsAAO 
bool property I_HeavyShieldsAllAtOnce
    Function Set(bool aao)
        _heavyShieldsAAO = aao
        If (aao)
            aaslrYHHeavyShieldsAAOGlobal.SetValueInt(0)
        else
            aaslrYHHeavyShieldsAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _heavyShieldsAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHHeavyShieldsLVLLGlobal auto
int property oid_Inventory_HeavyShields_LVLL auto
bool _heavyShieldsLVLL
bool property I_HeavyShieldsLevelList
    Function Set(bool lvll)
        _heavyShieldsLVLL = lvll
        If (lvll)
            aaslrYHHeavyShieldsLVLLGlobal.SetValueInt(0)
        else
            aaslrYHHeavyShieldsLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _heavyShieldsLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionSpellTomesAAOGlobal auto
int property oid_Inventory_IllusionSpellTomes_AAO auto
bool _illusionSpellTomesAAO 
bool property I_IllusionSpellTomesAllAtOnce
    Function Set(bool aao)
        _illusionSpellTomesAAO = aao
        If (aao)
            aaslrYHIllusionSpellTomesAAOGlobal.SetValueInt(0)
        else
            aaslrYHIllusionSpellTomesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionSpellTomesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionSpellTomesLVLLGlobal auto
int property oid_Inventory_IllusionSpellTomes_LVLL auto
bool _illusionSpellTomesLVLL
bool property I_IllusionSpellTomesLevelList
    Function Set(bool lvll)
        _illusionSpellTomesLVLL = lvll
        If (lvll)
            aaslrYHIllusionSpellTomesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHIllusionSpellTomesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionSpellTomesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionStavesAAOGlobal auto
int property oid_Inventory_IllusionStaves_AAO auto
bool _illusionStavesAAO 
bool property I_IllusionStavesAllAtOnce
    Function Set(bool aao)
        _illusionStavesAAO = aao
        If (aao)
            aaslrYHIllusionStavesAAOGlobal.SetValueInt(0)
        else
            aaslrYHIllusionStavesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionStavesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionStavesLVLLGlobal auto
int property oid_Inventory_IllusionStaves_LVLL auto
bool _illusionStavesLVLL
bool property I_IllusionStavesLevelList
    Function Set(bool lvll)
        _illusionStavesLVLL = lvll
        If (lvll)
            aaslrYHIllusionStavesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHIllusionStavesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionStavesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionRobesAAOGlobal auto
int property oid_Inventory_IllusionRobes_AAO auto
bool _illusionRobesAAO 
bool property I_IllusionRobesAllAtOnce
    Function Set(bool aao)
        _illusionRobesAAO = aao
        If (aao)
            aaslrYHIllusionRobesAAOGlobal.SetValueInt(0)
        else
            aaslrYHIllusionRobesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionRobesAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHIllusionRobesLVLLGlobal auto
int property oid_Inventory_IllusionRobes_LVLL auto
bool _illusionRobesLVLL
bool property I_IllusionRobesLevelList
    Function Set(bool lvll)
        _illusionRobesLVLL = lvll
        If (lvll)
            aaslrYHIllusionRobesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHIllusionRobesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _illusionRobesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHLightArmorAAOGlobal auto
int property oid_Inventory_LightArmor_AAO auto
bool _lightArmorAAO 
bool property I_LightArmorAllAtOnce
    Function Set(bool aao)
        _lightArmorAAO = aao
        If (aao)
            aaslrYHLightArmorAAOGlobal.SetValueInt(0)
        else
            aaslrYHLightArmorAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _lightArmorAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHLightArmorLVLLGlobal auto
int property oid_Inventory_LightArmor_LVLL auto
bool _lightArmorLVLL
bool property I_LightArmorLevelList
    Function Set(bool lvll)
        _lightArmorLVLL = lvll
        If (lvll)
            aaslrYHLightArmorLVLLGlobal.SetValueInt(0)
        else
            aaslrYHLightArmorLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _lightArmorLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHLightShieldsAAOGlobal auto
int property oid_Inventory_LightShields_AAO auto
bool _lightShieldsAAO 
bool property I_LightShieldsAllAtOnce
    Function Set(bool aao)
        _lightShieldsAAO = aao
        If (aao)
            aaslrYHLightShieldsAAOGlobal.SetValueInt(0)
        else
            aaslrYHLightShieldsAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _lightShieldsAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHLightShieldsLVLLGlobal auto
int property oid_Inventory_LightShields_LVLL auto
bool _lightShieldsLVLL
bool property I_LightShieldsLevelList
    Function Set(bool lvll)
        _lightShieldsLVLL = lvll
        If (lvll)
            aaslrYHLightShieldsLVLLGlobal.SetValueInt(0)
        else
            aaslrYHLightShieldsLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _lightShieldsLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorAllAAOGlobal auto
int property oid_Inventory_RestorAll_AAO auto
bool _restorAllAAO 
bool property I_RestorAllAllAtOnce
    Function Set(bool aao)
        _restorAllAAO = aao
        If (aao)
            aaslrYHRestorAllAAOGlobal.SetValueInt(0)
        else
            aaslrYHRestorAllAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorAllAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorAllLVLLGlobal auto
int property oid_Inventory_RestorAll_LVLL auto
bool _restorAllLVLL
bool property I_RestorAllLevelList
    Function Set(bool lvll)
        _restorAllLVLL = lvll
        If (lvll)
            aaslrYHRestorAllLVLLGlobal.SetValueInt(0)
        else
            aaslrYHRestorAllLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorAllLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationSpellTomesAAOGlobal auto
int property oid_Inventory_RestorationSpellTomes_AAO auto
bool _restorationSpellTomesAllAAO 
bool property I_RestorationSpellTomesAllAtOnce
    Function Set(bool aao)
        _restorationSpellTomesAllAAO = aao
        If (aao)
            aaslrYHRestorationSpellTomesAAOGlobal.SetValueInt(0)
        else
            aaslrYHRestorationSpellTomesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationSpellTomesAllAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationSpellTomesLVLLGlobal auto
int property oid_Inventory_RestorationSpellTomes_LVLL auto
bool _restorationSpellTomesLVLL
bool property I_RestorationSpellTomesLevelList
    Function Set(bool lvll)
        _restorationSpellTomesLVLL = lvll
        If (lvll)
            aaslrYHRestorationSpellTomesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHRestorationSpellTomesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationSpellTomesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationStavesAAOGlobal auto
int property oid_Inventory_RestorationStaves_AAO auto
bool _restorationStavesAllAAO 
bool property I_RestorationStavesAllAtOnce
    Function Set(bool aao)
        _restorationStavesAllAAO = aao
        If (aao)
            aaslrYHRestorationStavesAAOGlobal.SetValueInt(0)
        else
            aaslrYHRestorationStavesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationStavesAllAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationStavesLVLLGlobal auto
int property oid_Inventory_RestorationStaves_LVLL auto
bool _restorationStavesLVLL
bool property I_RestorationStavesLevelList
    Function Set(bool lvll)
        _restorationStavesLVLL = lvll
        If (lvll)
            aaslrYHRestorationStavesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHRestorationStavesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationStavesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationRobesAAOGlobal auto
int property oid_Inventory_RestorationRobes_AAO auto
bool _restorationRobesAllAAO 
bool property I_RestorationRobesAllAtOnce
    Function Set(bool aao)
        _restorationRobesAllAAO = aao
        If (aao)
            aaslrYHRestorationRobesAAOGlobal.SetValueInt(0)
        else
            aaslrYHRestorationRobesAAOGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationRobesAllAAO
    EndFunction
EndProperty
GlobalVariable property aaslrYHRestorationRobesLVLLGlobal auto
int property oid_Inventory_RestorationRobes_LVLL auto
bool _restorationRobesLVLL
bool property I_RestorationRobesLevelList
    Function Set(bool lvll)
        _restorationRobesLVLL = lvll
        If (lvll)
            aaslrYHRestorationRobesLVLLGlobal.SetValueInt(0)
        else
            aaslrYHRestorationRobesLVLLGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _restorationRobesLVLL
    EndFunction
EndProperty
GlobalVariable property aaslrYHDLC01LItemBonusStockGlobal auto
int property oid_Inventory_DawnguardDLC01 auto
bool _dawnguardDLC01
bool property I_DawnguardDLC01
    Function Set(bool dlc)
        _dawnguardDLC01 = dlc
        If (dlc)
            aaslrYHDLC01LItemBonusStockGlobal.SetValueInt(0)
        else 
            aaslrYHDLC01LItemBonusStockGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _dawnguardDLC01
    EndFunction
EndProperty
GlobalVariable property aaslrYHDLC2LItemBonusStockGlobal auto
int property oid_Inventory_DragonbornDLC2 auto
bool _dragonbornDLC2
bool property I_DragonbornDLC2
    Function Set(bool dlc)
        _dragonbornDLC2 = dlc
        If (dlc)
            aaslrYHDLC2LItemBonusStockGlobal.SetValueInt(0)
        else 
            aaslrYHDLC2LItemBonusStockGlobal.SetValueInt(100)
        EndIf
    EndFunction
    bool Function Get()
        return _dragonbornDLC2
    EndFunction
EndProperty