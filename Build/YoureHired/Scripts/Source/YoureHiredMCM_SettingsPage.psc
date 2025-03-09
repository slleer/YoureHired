Scriptname YoureHiredMCM_SettingsPage  Hidden 
{Creates the Settings page for the MCM}

Import YHUtil

string Function GetPageName() global
    return "Settings"
EndFunction

Function RenderPage(YoureHiredMCM mcm, string page) global
    If (page == GetPageName())
        mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
        LEFT(mcm)
        mcm.SetCursorPosition(1)
        RIGHT(mcm)
    EndIf
EndFunction

Function LEFT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Merchant Recruitment")
    mcm.oid_SettingS_AllowChildren = mcm.AddToggleOption("Child Merchants", mcm.S_AllowChildren)
    mcm.oid_SettingS_AllowAnimals = mcm.AddToggleOption("Animal Merchants", mcm.S_AllowAnimals)
    
    mcm.AddEmptyOption()
    
    mcm.AddHeaderOption("Reset Options")
    int flag = mcm.OPTION_FLAG_NONE
    if mcm.S_ResetOnMenuClose
        flag = mcm.OPTION_FLAG_DISABLED
    endIf
    mcm.oid_Settings_DaysBetweenReset = mcm.AddSliderOption("Reset Merchant Inventory", mcm.S_NumDaysBetweenReset, "Every {1} Days", flag)
    mcm.oid_Settings_ResetOnMenuClose = mcm.AddToggleOption("Reset On Menu Close", mcm.S_ResetOnMenuClose)
    mcm.oid_Settings_LowCountReset = mcm.AddToggleOption("Low Count Reset", mcm.S_LowCountReset)
    mcm.oid_Settings_EnableHotKeyUse = mcm.AddToggleOption("Hotkey Reset", mcm.S_EnableHotKeyUse)
    int secondFlag
    If (mcm.S_EnableHotKeyUse)
        flag = mcm.OPTION_FLAG_NONE
        if(mcm.S_RequireTwoKeys)
            secondFlag = mcm.OPTION_FLAG_NONE
        else
            secondFlag = mcm.OPTION_FLAG_DISABLED
        endIf
    else
        flag = mcm.OPTION_FLAG_DISABLED
        secondFlag = flag
    EndIf
    ; mcm.oid_Settings_VanillaHotkeyEnabled = mcm.AddToggleOption("Enable Vanilla Hotkey Reset", mcm.S_VanillaHotkeyEnabled, flag)
    mcm.oid_Settings_ResetHotkey = mcm.AddKeyMapOption("Reset Hotkey:", mcm.S_Hotkey, flag)
    mcm.oid_Settings_RequireTwoKeys = mcm.AddToggleOption("Require Seconday Key", mcm.S_RequireTwoKeys, flag)
    mcm.oid_Settings_SecondaryResetHotkey = mcm.AddKeyMapOption("Secondary Hotkey:", mcm.S_SecondaryHotkey, secondFlag)
    
EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Dialogue & Messages")
    ; mcm.AddEmptyOption()
    mcm.oid_Settings_FenceEnabled = mcm.AddToggleOption("Make Fence", mcm.S_FenceDialogueEnabled)
    ; mcm.oid_Settings_RecruitmentEnabled = mcm.AddToggleOption("Add Merchant", mcm.S_recruitmentEnabled)
    mcm.oid_Settings_ResetVanillaEnabled = mcm.AddToggleOption("Reset Non Managed Merchants", mcm.S_resetVanillaEnabled)
    mcm.oid_Settings_ShowDropMessage = mcm.AddToggleOption("Show Drop Message", mcm.S_ShowDropMessage)
    
    mcm.AddEmptyOption()
    mcm.AddHeaderOption("General Merchant Settings")
    mcm.oid_Settings_OverStockedMerchants = mcm.AddToggleOption("Overstocked Merchant Inventory", mcm.S_OverStockedEnabled)
    mcm.oid_Settings_ExtraStartingGold = mcm.AddSliderOption("Increase Mechant Gold", mcm.S_ExtraStartingGold, "By {0}")
    ; mcm.oid_Settings_MaxGoldInChest = mcm.AddSliderOption("Merchant Keeps Gold", mcm.S_MaxGoldInChest, "When Above {0}")
    mcm.oid_Settings_DoubleMerchantEnabled = mcm.AddToggleOption("Double Merchant", mcm.S_DoubleMerchantEnabled)
    mcm.oid_Settings_AutoSellJunk = mcm.AddToggleOption("Automatically Sell Junk", mcm.S_AutoSellJunk)
    ; mcm.oid_Settings_DestroyOnRemoval = mcm.AddToggleOption("Destroy On Dismiss", mcm.S_DestroyOnRemoval)
EndFunction

Function OnSelect(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        mcm.S_FenceDialogueEnabled = !mcm.S_FenceDialogueEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_FenceEnabled, mcm.S_FenceDialogueEnabled)
        Log("MCM_SettingsPage - " + "Fence Enabled: " + mcm.S_FenceDialogueEnabled)
    ElseIf (optionId == mcm.oid_Settings_ResetOnMenuClose)
        mcm.S_ResetOnMenuClose = !mcm.S_ResetOnMenuClose
        mcm.FixedProperties.ResetOnMenuClose = mcm.S_ResetOnMenuClose
        mcm.FixedProperties.SetToggleBetweenMenuOrGametimeReset()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
        int flag
        If (mcm.S_ResetOnMenuClose)
            flag = mcm.OPTION_FLAG_DISABLED
        Else
            flag = mcm.OPTION_FLAG_NONE
        EndIf
        mcm.SetToggleOptionValue(optionId, mcm.S_ResetOnMenuClose, true)
        mcm.SetOptionFlags(mcm.oid_Settings_DaysBetweenReset, flag)
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        mcm.S_RecruitmentEnabled = !mcm.S_RecruitmentEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_RecruitmentEnabled, mcm.S_RecruitmentEnabled)
    ElseIf (optionId == mcm.oid_Settings_DoubleMerchantEnabled)
        mcm.S_DoubleMerchantEnabled = !mcm.S_DoubleMerchantEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_DoubleMerchantEnabled, mcm.S_DoubleMerchantEnabled)
        mcm.FixedProperties.SetUpdateVanillaMerchantFaction()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        If (!mcm.S_ResetVanillaEnabled)
            mcm.FixedProperties.aaslrResetVanillaFlagGlobal.SetValue(1.0)
        Else
            mcm.FixedProperties.aaslrResetVanillaFlagGlobal.SetValue(0.0)
        EndIf
        mcm.S_ResetVanillaEnabled = !mcm.S_ResetVanillaEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_ResetVanillaEnabled, mcm.S_ResetVanillaEnabled)
        Log("MCM_SettingsPage - "+ "Reset Vanilla: " + mcm.FixedProperties.aaslrResetVanillaFlagGlobal.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        If (mcm.S_AllowChildren)
            mcm.FixedProperties.aaslrAllowChildrenFlag.SetValue(2.0)
        Else
            mcm.FixedProperties.aaslrAllowChildrenFlag.SetValue(1.0)
        EndIf
        mcm.S_AllowChildren = !mcm.S_AllowChildren
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowChildren, mcm.S_AllowChildren)
        Log("MCM_SettingsPage - "+ "AllowChildrenFlag:" + mcm.FixedProperties.aaslrAllowChildrenFlag.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        If (mcm.S_AllowAnimals)
            mcm.FixedProperties.aaslrallowBeastsFlag.SetValue(2.0)
        Else
            mcm.FixedProperties.aaslrallowBeastsFlag.SetValue(1.0)
        EndIf     
        mcm.S_AllowAnimals = !mcm.S_AllowAnimals
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowAnimals, mcm.S_AllowAnimals)
        Log("MCM_SettingsPage - "+ "AllowAnimalFlag:" + mcm.FixedProperties.aaslrallowBeastsFlag.GetValue())
    ElseIf (optionId == mcm.oid_Settings_EnableHotKeyUse)
        mcm.S_EnableHotKeyUse = !mcm.S_EnableHotKeyUse
        mcm.SetToggleOptionValue(mcm.oid_Settings_EnableHotKeyUse, mcm.S_EnableHotKeyUse, true)
        mcm.FixedProperties.EnableHotKeyUse = mcm.S_EnableHotKeyUse
        ToggleHotKeyOptions(mcm)
    ElseIf (optionId == mcm.oid_Settings_RequireTwoKeys)
        mcm.S_RequireTwoKeys = !mcm.S_RequireTwoKeys
        mcm.SetToggleOptionValue(mcm.oid_Settings_RequireTwoKeys, mcm.S_RequireTwoKeys)
        mcm.FixedProperties.RequireTwoKeys = mcm.S_RequireTwoKeys
    ElseIf (optionId == mcm.oid_Settings_LowCountReset)
        mcm.S_LowCountReset = !mcm.S_LowCountReset
        mcm.SetToggleOptionValue(optionId, mcm.S_LowCountReset)
        mcm.FixedProperties.LowCountReset = mcm.S_LowCountReset
    ElseIf (optionId == mcm.oid_Settings_ShowDropMessage)
        mcm.S_ShowDropMessage = !mcm.S_ShowDropMessage
        mcm.SetToggleOptionValue(optionId, mcm.S_ShowDropMessage)
        mcm.FixedProperties.SetShowDropMessage(mcm.S_ShowDropMessage)
    ElseIf (optionId == mcm.oid_Settings_DestroyOnRemoval)
        mcm.S_DestroyOnRemoval = !mcm.S_DestroyOnRemoval
        mcm.SetToggleOptionValue(optionId, mcm.S_DestroyOnRemoval)
        mcm.FixedProperties.SetDestroyOnRemoval(mcm.S_DestroyOnRemoval)
    ElseIf (optionId == mcm.oid_Settings_OverStockedMerchants)
        mcm.S_OverStockedEnabled = !mcm.S_OverStockedEnabled
        mcm.SetToggleOptionValue(optionId, mcm.S_OverStockedEnabled)
        mcm.FixedProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    ElseIf (optionId == mcm.oid_Settings_AutoSellJunk)
        mcm.S_AutoSellJunk = !mcm.S_AutoSellJunk
        mcm.SetToggleOptionValue(optionId, mcm.S_AutoSellJunk)
    EndIf    
EndFunction ; OnSelect

Function OnKeyMapChanged(YoureHiredMCM mcm, int optionId, int keyCode, string conflictControl, string conflictName) global
    bool continue = true
    if (conflictControl != "")
        string msg
        if (conflictName != "")
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
        else
            msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
        endIf

        continue = mcm.ShowMessage(msg, true, "$Yes", "$No")
    endIf

    if (continue)
        If (optionId == mcm.oid_Settings_ResetHotkey)
            mcm.oid_Settings_ResetHotkey = keyCode
            mcm.FixedProperties.Hotkey = keyCode
        ElseIf (optionId == mcm.oid_Settings_SecondaryResetHotkey)
            mcm.oid_Settings_SecondaryResetHotkey = keyCode
            mcm.FixedProperties.SecondaryHotkey = keyCode
        EndIf
        mcm.SetKeymapOptionValue(optionId, keyCode)
    endIf
EndFunction

Function OnHighlight(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        mcm.SetInfoText("Adds dialogue to managed merchants to make them into a Fence (will buy stolen items). [Default off].")
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        mcm.SetInfoText("All NPC's that can be a merchant will have the 'Interested in becoming a merchant?' Dialogue option. This is an alternative to using the spell or wearing the Merchant Hat! [Default off]")
    ElseIf (optionId == mcm.oid_Settings_DoubleMerchantEnabled)
        mcm.SetInfoText("When adding existing merchants into merchant slot, if enabled, you will be able to access both the existing store (what have you got for sale) and the manged store (what else have you got for sale). When disabled, only the managed store is availbe. [Default off]")
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        mcm.SetInfoText("Adds dialogue to reset the inventory of all non managed merchants. NOTE: For non managed merchants with two inventories (example: Adrianne Avanicci), both are reset. [Default off]")
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        mcm.SetInfoText("Allows children to become merchants [Default off]")
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        mcm.SetInfoText("Allows certain animals to become merchants [Default off] - Supported animal types: dog, goat, fox, mudcrab, skeever, frostbite spider, rabbit, death hound")
    ElseIf (optionId == mcm.oid_Settings_EnableHotKeyUse)
        mcm.SetInfoText("Use the registerd hotkey/s to reset a managed merchant's inventory while in the bartering menu. [Default off]")
    ElseIf (optionId == mcm.oid_Settings_RequireTwoKeys)
        mcm.SetInfoText("Requires both hotkeys to reset a managed merchant's inventory while in the barter menu. If using a controller, the secondary hotkey must be pressed first. [Default on]")
    ElseIf (optionId == mcm.oid_Settings_ResetHotkey)
        string defaultKeyText
        If (Game.UsingGamepad())
            defaultKeyText = "[Default 'Right Trigger']"
        Else
            defaultKeyText = "[Default 'L']"
        EndIf
        mcm.SetInfoText("Use this key to reset a merchant's chest while in the barter menu. " + defaultKeyText)
    ElseIf (optionId == mcm.oid_Settings_SecondaryResetHotkey)
        string defaultKeyText
        If (Game.UsingGamepad())
            defaultKeyText = "NOTE: This key must be pressed before Reset Hotkey. [Default 'Left Trigger']"
        Else
            defaultKeyText = "[Default 'R-CRTL']"
        EndIf
        mcm.SetInfoText("If 'Require Secondary Key' is enabled, this key must be used in addition to the Reset Hotkey. " + defaultKeyText)
    ElseIf (optionId == mcm.oid_Settings_DaysBetweenReset)
        mcm.SetInfoText("How long it takes for a managed merchant's chest to reset. [Default 2]")
    ElseIf (optionId == mcm.oid_Settings_ResetOnMenuClose)
        mcm.SetInfoText("Enable to have a managed merchant's chest reset after exiting barter menu. Will also disable auto reset every " + mcm.S_NumDaysBetweenReset + " days. [Default off]")
    ElseIf (optionId == mcm.oid_Settings_LowCountReset)
        mcm.SetInfoText("When enabled, mangaged merchant's inventory will reset when they have fewer than 10% of the number of different items or less than 20% of gold. [Default off]")
    ElseIf (optionId == mcm.oid_Settings_ShowDropMessage)
        mcm.SetInfoText("When enabled, a warning message will show when trying to drop a merchant's stall from inventory. [Default on]")
    ElseIf (optionId == mcm.oid_Settings_DestroyOnRemoval)
        mcm.SetInfoText("When enabled, a merchant's stall will be destroyed when they are dimissed from a merchant slot. [Default on]")
    ElseIf (optionId == mcm.oid_Settings_OverStockedMerchants)
        mcm.SetInfoText("Adds a number of items to each managed merchant type [Default off]")
    ElseIf (optionId == mcm.oid_Settings_ExtraStartingGold)
        mcm.SetInfoText("Increase this merchants base gold amount by the selected amount. [Default 0]")
    ; ElseIf (optionId == mcm.oid_Settings_MaxGoldInChest)
    ;     mcm.SetInfoText("Any gold above this amount in a managed merchant's inventory will remain when reseting their inventory or changing merchant types. This also allows a merchant's gold to grow beyond 32000 without issue. [Default 6800]")
    ElseIf (optionId == mcm.oid_Settings_AutoSellJunk)
        mcm.SetInfoText("When Enabled, anything in your inventory that matches an item in the junk filter will automatically be sold when asking a managed merchant 'What have you got for sale?'. Not recommened for items you've added enchantments too or tempered as you'll only get the base value (pre enchantment/tempering). [Defualt off]")
    EndIf    
    
EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        mcm.S_FenceDialogueEnabled = false
        mcm.SetToggleOptionValue(mcm.oid_Settings_FenceEnabled, mcm.S_FenceDialogueEnabled)
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        mcm.S_RecruitmentEnabled = false
        mcm.SetToggleOptionValue(mcm.oid_Settings_RecruitmentEnabled, mcm.S_RecruitmentEnabled)
    ElseIf (optionId == mcm.oid_Settings_DoubleMerchantEnabled)
        mcm.S_DoubleMerchantEnabled = false
        mcm.SetToggleOptionValue(mcm.oid_Settings_DoubleMerchantEnabled, mcm.S_DoubleMerchantEnabled)
        mcm.FixedProperties.SetUpdateVanillaMerchantFaction()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        mcm.S_ResetVanillaEnabled = false
        mcm.FixedProperties.aaslrResetVanillaFlagGlobal.SetValue(0.0)
        mcm.SetToggleOptionValue(mcm.oid_Settings_ResetVanillaEnabled, mcm.S_ResetVanillaEnabled)
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        mcm.S_AllowChildren = false
        mcm.FixedProperties.aaslrAllowChildrenFlag.SetValue(2.0)
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowChildren, mcm.S_AllowChildren)
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        mcm.S_AllowAnimals = false
        mcm.FixedProperties.aaslrallowBeastsFlag.SetValue(2.0)
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowAnimals, mcm.S_AllowAnimals)
    ElseIf (optionId == mcm.oid_Settings_EnableHotKeyUse)
        mcm.S_EnableHotKeyUse = false
        mcm.SetToggleOptionValue(optionId, mcm.S_EnableHotKeyUse)
    ElseIf (optionId == mcm.oid_Settings_RequireTwoKeys)
        mcm.S_RequireTwoKeys = true
        mcm.SetToggleOptionValue(optionId, mcm.S_RequireTwoKeys)
    ElseIf (optionId == mcm.oid_Settings_ResetHotkey)
        If (Game.UsingGamepad())
            mcm.S_Hotkey = 281 ; Right-Trigger
        Else
            mcm.S_Hotkey = 38 ; 'L'
        EndIf
        mcm.SetKeyMapOptionValue(optionId, mcm.S_Hotkey)
        mcm.FixedProperties.Hotkey = mcm.S_Hotkey
    ElseIf (optionId == mcm.oid_Settings_SecondaryResetHotkey)
        If (Game.UsingGamepad())
            mcm.S_SecondaryHotkey = 180 ; Left-Trigger
        Else
            mcm.S_SecondaryHotkey = 157 ; Rifght-crtl
        EndIf
        mcm.SetKeyMapOptionValue(optionId, mcm.S_SecondaryHotkey)
        mcm.FixedProperties.SecondaryHotkey = mcm.S_SecondaryHotkey
    ElseIf (optionId == mcm.oid_Settings_DaysBetweenReset)
        mcm.S_NumDaysBetweenReset = 2.0
        mcm.FixedProperties.DaysBeforeReset = mcm.S_NumDaysBetweenReset
        mcm.SetSliderOptionValue(optionId, mcm.S_NumDaysBetweenReset, "Every {1} Days")
    ElseIf (optionId == mcm.oid_Settings_ResetOnMenuClose)
        If (mcm.S_ResetOnMenuClose)
            mcm.SetOptionFlags(mcm.oid_Settings_DaysBetweenReset, mcm.OPTION_FLAG_NONE, true)            
        EndIf
        mcm.S_ResetOnMenuClose = false
        mcm.FixedProperties.ResetOnMenuClose = false
        mcm.FixedProperties.SetToggleBetweenMenuOrGametimeReset()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
        mcm.SetToggleOptionValue(optionId, mcm.S_ResetOnMenuClose)
    ElseIf (optionId == mcm.oid_Settings_LowCountReset)
        mcm.S_LowCountReset = false
        mcm.FixedProperties.LowCountReset = false
        mcm.SetToggleOptionValue(optionId, mcm.S_LowCountReset)
    ElseIf (optionId == mcm.oid_Settings_ShowDropMessage)
        mcm.S_ShowDropMessage = true
        mcm.FixedProperties.SetShowDropMessage(true)
        mcm.SetToggleOptionValue(optionId, mcm.S_ShowDropMessage)
    ElseIf (optionId == mcm.oid_Settings_DestroyOnRemoval)
        mcm.S_DestroyOnRemoval = true
        mcm.SetToggleOptionValue(optionId, mcm.S_DestroyOnRemoval)
        mcm.FixedProperties.SetDestroyOnRemoval(mcm.S_DestroyOnRemoval)
    ElseIF (optionId == mcm.oid_Settings_OverStockedMerchants)
        mcm.S_OverStockedEnabled = false
        mcm.SetToggleOptionValue(optionId, mcm.S_OverStockedEnabled)
        mcm.FixedProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    ElseIf (optionId == mcm.oid_Settings_ExtraStartingGold)
        mcm.S_ExtraStartingGold = 0
        mcm.FixedProperties.MaxGoldValue = 1800.0 + mcm.S_ExtraStartingGold as float
        mcm.SetSliderOptionValue(optionId, mcm.S_ExtraStartingGold, "By {0}")
        mcm.FixedProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    ; ElseIf (optionId == mcm.oid_Settings_MaxGoldInChest)
    ;     mcm.S_MaxGoldInChest = 6800.0
    ;     mcm.FixedProperties.MaxGoldValue = mcm.S_MaxGoldInChest
    ;     mcm.SetSliderOptionValue(optionId, mcm.S_MaxGoldInChest, "When Above {0}")
    ElseIf (optionId == mcm.oid_Settings_AutoSellJunk)
        mcm.S_AutoSellJunk = false
        mcm.SetToggleOptionValue(optionId, mcm.S_AutoSellJunk)
    EndIf
EndFunction ; OnDefault

Function OnSliderOpen(YoureHiredMCM mcm, int optionId) global
    If optionId == mcm.oid_Settings_DaysBetweenReset
        mcm.SetSliderDialogStartValue(mcm.S_NumDaysBetweenReset)
        mcm.SetSliderDialogDefaultValue(2.0)
        mcm.SetSliderDialogRange(1.0, 7.0)
        mcm.SetSliderDialogInterval(0.5)
    ; elseif optionId == mcm.oid_Settings_MaxGoldInChest
    ;     mcm.SetSliderDialogStartValue(mcm.S_MaxGoldInChest)
    ;     mcm.SetSliderDialogDefaultValue(6800)
    ;     mcm.SetSliderDialogRange(mcm.S_MinGOldAmount,25000.0)
    ;     mcm.SetSliderDialogInterval(100.0)
    elseif optionId == mcm.oid_Settings_ExtraStartingGold
        mcm.SetSliderDialogStartValue(mcm.S_ExtraStartingGold)
        mcm.SetSliderDialogDefaultValue(0)
        mcm.SetSliderDialogRange(0, mcm.BonusMerchantGoldGlobals.Length*1000)
        mcm.SetSliderDialogInterval(1000)
    endIf
EndFunction

Function OnSliderAccept(YoureHiredMCM mcm, int optionId, float value) global
    if optionId == mcm.oid_Settings_DaysBetweenReset
        mcm.S_NumDaysBetweenReset = value
        mcm.FixedProperties.DaysBeforeReset = mcm.S_NumDaysBetweenReset
        mcm.SetSliderOptionValue(optionId, mcm.S_NumDaysBetweenReset, "Every {1} Days")
    ; elseif optionId == mcm.oid_Settings_MaxGoldInChest
    ;     mcm.S_MaxGoldInChest = value
    ;     mcm.FixedProperties.MaxGoldValue = value
    ;     mcm.SetSliderOptionValue(optionId, value, "When Above {0}")
    elseif optionId == mcm.oid_Settings_ExtraStartingGold
        mcm.S_ExtraStartingGold = (value as int)
        mcm.FixedProperties.MaxGoldValue = 1800.0 + mcm.S_ExtraStartingGold as float
        mcm.SetSliderOptionValue(optionId, value, "By {0}")
        mcm.FixedProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    endIf
EndFunction

Function ToggleHotKeyOptions(YoureHiredMCM mcm) global
    int flag
    If (mcm.S_EnableHotKeyUse)
        mcm.FixedProperties.YHVanillaManagerScript.ListenForMenuAndHotKeys()
        flag = mcm.OPTION_FLAG_NONE
        If (mcm.S_RequireTwoKeys)
            mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_NONE, true)
        else
            mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_DISABLED, true)
        EndIf
    Else
        mcm.FixedProperties.YHVanillaManagerScript.StopListenting()
        flag = mcm.OPTION_FLAG_DISABLED
        mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_DISABLED, true)
    EndIf    

    ; mcm.FixedProperties.SendModEvent("aaslrYH_UpdateResetCriteria")
    mcm.SetOptionFlags(mcm.oid_Settings_ResetHotkey, flag, true)
    mcm.SetOptionFlags(mcm.oid_Settings_RequireTwoKeys, flag)
EndFunction
