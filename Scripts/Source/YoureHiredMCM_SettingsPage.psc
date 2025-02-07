Scriptname YoureHiredMCM_SettingsPage  Hidden 
{Creates the Settings page for the MCM}

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
    
    mcm.AddHeaderOption("Merchant Options")
    mcm.oid_Settings_MaxGoldInChest = mcm.AddSliderOption("Merchant Keeps Gold", mcm.S_MaxGoldInChest, "When Above {0}")
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
    mcm.AddHeaderOption("Merchant Dialogue")
    ; mcm.AddEmptyOption()
    mcm.oid_Settings_FenceEnabled = mcm.AddToggleOption("Make Fence", mcm.S_fenceEnabled)
    mcm.oid_Settings_RecruitmentEnabled = mcm.AddToggleOption("Add Merchant", mcm.S_recruitmentEnabled)
    mcm.oid_Settings_RepeatEnabled = mcm.AddToggleOption("Same Merchant Type", mcm.S_repeatEnabled)
    mcm.oid_Settings_ResetVanillaEnabled = mcm.AddToggleOption("Reset Non Managed Merchants", mcm.S_resetVanillaEnabled)
EndFunction

Function OnSelect(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        If (!mcm.S_fenceEnabled)
            mcm.FixedMerchantProperties.aaslrFenceWantedFlag.SetValue(1.0)
        Else
            mcm.FixedMerchantProperties.aaslrFenceWantedFlag.SetValue(0.0)
        EndIf
        mcm.S_fenceEnabled = !mcm.S_fenceEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_FenceEnabled, mcm.S_fenceEnabled)
        Logger("Fence Enabled: " + mcm.FixedMerchantProperties.aaslrFenceWantedFlag.GetValue())
    ElseIf (optionId == mcm.oid_Settings_ResetOnMenuClose)
        mcm.S_ResetOnMenuClose = !mcm.S_ResetOnMenuClose
        mcm.FixedMerchantProperties.ResetOnMenuClose = mcm.S_ResetOnMenuClose
        mcm.FixedMerchantProperties.SetToggleBetweenMenuOrGametimeReset()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
        int flag
        If (mcm.S_ResetOnMenuClose)
            flag = mcm.OPTION_FLAG_DISABLED
        Else
            flag = mcm.OPTION_FLAG_NONE
        EndIf
        mcm.SetToggleOptionValue(optionId, mcm.S_ResetOnMenuClose, true)
        mcm.SetOptionFlags(mcm.oid_Settings_DaysBetweenReset, flag)
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        If (!mcm.S_RecruitmentEnabled)
            mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.SetValue(1.0)
            mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.SetValue(0.0)
        EndIf
        mcm.S_RecruitmentEnabled = !mcm.S_RecruitmentEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_RecruitmentEnabled, mcm.S_RecruitmentEnabled)
        Logger("Now Hiring!: " + mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.GetValue())
    ElseIf (optionId == mcm.oid_Settings_RepeatEnabled)
        If (!mcm.S_RepeatEnabled)
            mcm.FixedMerchantProperties.aaslrRepeatCustomerFlagGlobal.SetValueInt(1)
        Else
            mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.SetValueInt(0)
        EndIf
        mcm.S_RepeatEnabled = !mcm.S_RepeatEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_RepeatEnabled, mcm.S_RepeatEnabled)
        Logger("Repeat Customer: " + mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.GetValueInt())
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        If (!mcm.S_ResetVanillaEnabled)
            mcm.FixedMerchantProperties.aaslrResetVanillaFlagGlobal.SetValue(1.0)
        Else
            mcm.FixedMerchantProperties.aaslrResetVanillaFlagGlobal.SetValue(0.0)
        EndIf
        mcm.S_ResetVanillaEnabled = !mcm.S_ResetVanillaEnabled
        mcm.SetToggleOptionValue(mcm.oid_Settings_ResetVanillaEnabled, mcm.S_ResetVanillaEnabled)
        Logger("Reset Vanilla: " + mcm.FixedMerchantProperties.aaslrResetVanillaFlagGlobal.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        If (mcm.S_AllowChildren)
            mcm.FixedMerchantProperties.aaslrAllowChildrenFlag.SetValue(2.0)
        Else
            mcm.FixedMerchantProperties.aaslrAllowChildrenFlag.SetValue(1.0)
        EndIf
        mcm.S_AllowChildren = !mcm.S_AllowChildren
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowChildren, mcm.S_AllowChildren)
        Logger("AllowChildrenFlag:" + mcm.FixedMerchantProperties.aaslrAllowChildrenFlag.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        If (mcm.S_AllowAnimals)
            mcm.FixedMerchantProperties.aaslrallowBeastsFlag.SetValue(2.0)
        Else
            mcm.FixedMerchantProperties.aaslrallowBeastsFlag.SetValue(1.0)
        EndIf     
        mcm.S_AllowAnimals = !mcm.S_AllowAnimals
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowAnimals, mcm.S_AllowAnimals)
        Logger("AllowAnimalFlag:" + mcm.FixedMerchantProperties.aaslrallowBeastsFlag.GetValue())
    ElseIf (optionId == mcm.oid_Settings_EnableHotKeyUse)
        mcm.S_EnableHotKeyUse = !mcm.S_EnableHotKeyUse
        mcm.SetToggleOptionValue(mcm.oid_Settings_EnableHotKeyUse, mcm.S_EnableHotKeyUse, true)
        mcm.FixedMerchantProperties.EnableHotKeyUse = mcm.S_EnableHotKeyUse
        ToggleHotKeyOptions(mcm)
    ElseIf (optionId == mcm.oid_Settings_RequireTwoKeys)
        mcm.S_RequireTwoKeys = !mcm.S_RequireTwoKeys
        mcm.SetToggleOptionValue(mcm.oid_Settings_RequireTwoKeys, mcm.S_RequireTwoKeys)
        mcm.FixedMerchantProperties.RequireTwoKeys = mcm.S_RequireTwoKeys
    ElseIf (optionId == mcm.oid_Settings_LowCountReset)
        mcm.S_LowCountReset = !mcm.S_LowCountReset
        mcm.SetToggleOptionValue(optionId, mcm.S_LowCountReset)
        mcm.FixedMerchantProperties.LowCountReset = mcm.S_LowCountReset
    EndIf    
EndFunction

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
            mcm.FixedMerchantProperties.Hotkey = keyCode
        ElseIf (optionId == mcm.oid_Settings_SecondaryResetHotkey)
            mcm.oid_Settings_SecondaryResetHotkey = keyCode
            mcm.FixedMerchantProperties.SecondaryHotkey = keyCode
        EndIf
        mcm.SetKeymapOptionValue(optionId, keyCode)
    endIf
EndFunction

Function OnHighlight(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        mcm.SetInfoText("When enabled, this merchant will buy stolen items. [Default off].")
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        mcm.SetInfoText("All NPC's that can be a merchant will have the 'Interested in becoming a merchant?' Dialogue option. This is an alternative to using the spell or wearing the Merchant Hat! [Default off]")
    ElseIf (optionId == mcm.oid_Settings_RepeatEnabled)
        mcm.SetInfoText("When managing existing merchants, this option will display the existing merchant's store type as a choice for it's managed store. Example: would allow Adrianne Avenicci to sell blacksmith supplies through this mod. [Default off]")
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        mcm.SetInfoText("Adds dialogue to reset the inventory of all non managed merchants. NOTE: For non managed merchants with two inventories (Adrianne Avanicci), both are reset. [Default off]")
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        mcm.SetInfoText("Allows children to become merchants [Default off]")
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        mcm.SetInfoText("Allows certain animals to become merchants [Default off] - Supported animal types: dog, goat, horse, fox, mudcrab, skeever, frostbite spider, rabbit, death hound")
    ElseIf (optionId == mcm.oid_Settings_MaxGoldInChest)
        mcm.SetInfoText("Any gold above this amount in a managed merchant's inventory will remain when reseting their inventory or changing merchant types. This also allows a merchant's gold to grow beyond 32000 without issue. [Default 6800]")
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
        mcm.SetInfoText("When enabled, mangaged merchant's inventory will reset when they have fewer than 6 items or less than 150 gold. [Default off]")
    EndIf    
    
EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Settings_FenceEnabled)
        mcm.S_FenceEnabled = false
        mcm.FixedMerchantProperties.aaslrFenceWantedFlag.SetValue(0.0)
        mcm.SetToggleOptionValue(mcm.oid_Settings_FenceEnabled, mcm.S_FenceEnabled)
        Logger("Fence Enabled: " + mcm.FixedMerchantProperties.aaslrFenceWantedFlag.GetValue())
    ElseIf (optionId == mcm.oid_Settings_RecruitmentEnabled)
        mcm.S_RecruitmentEnabled = false
        mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.SetValue(0.0)
        mcm.SetToggleOptionValue(mcm.oid_Settings_RecruitmentEnabled, mcm.S_RecruitmentEnabled)
        Logger("Now Hiring!: " + mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.GetValue())
    ElseIf (optionId == mcm.oid_Settings_RepeatEnabled)
        mcm.S_RepeatEnabled = false
        mcm.FixedMerchantProperties.aaslrRepeatCustomerFlagGlobal.SetValueInt(0)
        mcm.SetToggleOptionValue(mcm.oid_Settings_RepeatEnabled, mcm.S_RepeatEnabled)
        Logger("Repeat Customer: " + mcm.FixedMerchantProperties.aaslrNowHiringFlagGlobal.GetValueInt())
    ElseIf (optionId == mcm.oid_Settings_ResetVanillaEnabled)
        mcm.S_ResetVanillaEnabled = false
        mcm.FixedMerchantProperties.aaslrResetVanillaFlagGlobal.SetValue(0.0)
        mcm.SetToggleOptionValue(mcm.oid_Settings_ResetVanillaEnabled, mcm.S_ResetVanillaEnabled)
        Logger("Reset Vanilla: " + mcm.FixedMerchantProperties.aaslrResetVanillaFlagGlobal.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowChildren)
        mcm.S_AllowChildren = false
        mcm.FixedMerchantProperties.aaslrAllowChildrenFlag.SetValue(2.0)
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowChildren, mcm.S_AllowChildren)
        Logger("AllowChildrenFlag:" + mcm.FixedMerchantProperties.aaslrAllowChildrenFlag.GetValue())
    ElseIf (optionId == mcm.oid_SettingS_AllowAnimals)
        mcm.S_AllowAnimals = false
        mcm.FixedMerchantProperties.aaslrallowBeastsFlag.SetValue(2.0)
        mcm.SetToggleOptionValue(mcm.oid_SettingS_AllowAnimals, mcm.S_AllowAnimals)
        Logger("allowAnimalsFlag:" + mcm.FixedMerchantProperties.aaslrallowBeastsFlag.GetValue())
    ElseIf (optionId == mcm.oid_Settings_MaxGoldInChest)
        mcm.S_MaxGoldInChest = 6800.0
        mcm.FixedMerchantProperties.MaxGoldValue = mcm.S_MaxGoldInChest
        mcm.SetSliderOptionValue(optionId, mcm.S_MaxGoldInChest, "When Above {0}")
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
        mcm.FixedMerchantProperties.Hotkey = mcm.S_Hotkey
    ElseIf (optionId == mcm.oid_Settings_SecondaryResetHotkey)
        If (Game.UsingGamepad())
            mcm.S_SecondaryHotkey = 180 ; Left-Trigger
        Else
            mcm.S_SecondaryHotkey = 157 ; Rifght-crtl
        EndIf
        mcm.SetKeyMapOptionValue(optionId, mcm.S_SecondaryHotkey)
        mcm.FixedMerchantProperties.SecondaryHotkey = mcm.S_SecondaryHotkey
    ElseIf (optionId == mcm.oid_Settings_DaysBetweenReset)
        mcm.S_NumDaysBetweenReset = 2.0
        mcm.FixedMerchantProperties.DaysBeforeReset = mcm.S_NumDaysBetweenReset
        mcm.SetSliderOptionValue(optionId, mcm.S_NumDaysBetweenReset, "Every {1} Days")
    ElseIf (optionId == mcm.oid_Settings_ResetOnMenuClose)
        If (mcm.S_ResetOnMenuClose)
            mcm.SetOptionFlags(mcm.oid_Settings_DaysBetweenReset, mcm.OPTION_FLAG_NONE, true)            
        EndIf
        mcm.S_ResetOnMenuClose = false
        mcm.FixedMerchantProperties.ResetOnMenuClose = false
        mcm.FixedMerchantProperties.SetToggleBetweenMenuOrGametimeReset()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
        mcm.SetToggleOptionValue(optionId, mcm.S_ResetOnMenuClose)
    ElseIf (optionId == mcm.oid_Settings_LowCountReset)
        mcm.S_LowCountReset = false
        mcm.FixedMerchantProperties.LowCountReset = false
        mcm.SetToggleOptionValue(optionId, mcm.S_LowCountReset)
    EndIf 
EndFunction ; OnDefault

Function OnSliderOpen(YoureHiredMCM mcm, int optionId) global
    if optionId == mcm.oid_Settings_MaxGoldInChest
        mcm.SetSliderDialogStartValue(mcm.S_MaxGoldInChest)
        mcm.SetSliderDialogDefaultValue(6800)
        mcm.SetSliderDialogRange(mcm.S_MinGOldAmount,25000.0)
        mcm.SetSliderDialogInterval(100.0)
    elseIf optionId == mcm.oid_Settings_DaysBetweenReset
        mcm.SetSliderDialogStartValue(mcm.S_NumDaysBetweenReset)
        mcm.SetSliderDialogDefaultValue(2.0)
        mcm.SetSliderDialogRange(1.0, 7.0)
        mcm.SetSliderDialogInterval(0.5)
    endIf
EndFunction

Function OnSliderAccept(YoureHiredMCM mcm, int optionId, float value) global
    if optionId == mcm.oid_Settings_MaxGoldInChest
        mcm.S_MaxGoldInChest = value
        mcm.FixedMerchantProperties.MaxGoldValue = value
        mcm.SetSliderOptionValue(optionId, value, "When Above {0}")
    elseif optionId == mcm.oid_Settings_DaysBetweenReset
        mcm.S_NumDaysBetweenReset = value
        mcm.FixedMerchantProperties.DaysBeforeReset = mcm.S_NumDaysBetweenReset
        mcm.SetSliderOptionValue(optionId, mcm.S_NumDaysBetweenReset, "Every {1} Days")
    endIf
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1) global
    if logType == 1
        YHUtil.Log("MCM SettingsPage - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MCM SettingsPage - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

Function ToggleHotKeyOptions(YoureHiredMCM mcm) global
    int flag
    If (mcm.S_EnableHotKeyUse)
        mcm.FixedMerchantProperties.YHVanillaManagerScript.ListenForMenuAndHotKeys()
        flag = mcm.OPTION_FLAG_NONE
        If (mcm.S_RequireTwoKeys)
            mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_NONE, true)
        else
            mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_DISABLED, true)
        EndIf
    Else
        mcm.FixedMerchantProperties.YHVanillaManagerScript.StopListenting()
        flag = mcm.OPTION_FLAG_DISABLED
        mcm.SetOptionFlags(mcm.oid_Settings_SecondaryResetHotkey, mcm.OPTION_FLAG_DISABLED, true)
    EndIf
    mcm.SetOptionFlags(mcm.oid_Settings_ResetHotkey, flag, true)
    mcm.SetOptionFlags(mcm.oid_Settings_RequireTwoKeys, flag)
EndFunction
