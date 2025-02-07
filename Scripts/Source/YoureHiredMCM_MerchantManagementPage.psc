Scriptname YoureHiredMCM_MerchantManagementPage  Hidden 
{For managing merchants managed by this mod.}



string Function GetPageName() global
    return "Merchant Management"
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
    mcm.AddHeaderOption("Managed Merchants")
    mcm.oid_MerchantManager_NumberOfMerchantsText = mcm.AddTextOption("Merchant count", mcm.FixedMerchantProperties.GetNumMerchantsGlobal())
    mcm.oid_MerchantManager_OverStockedMerchants = mcm.AddToggleOption("Overstocked Merchant Inventory", mcm.MM_OverStockedEnabled)
    mcm.oid_MerchantManager_ExtraStartingGold = mcm.AddSliderOption("Increase Mechant Gold", mcm.MM_ExtraStartingGold, "By {0}")
    mcm.AddEmptyOption()
    int flag = mcm.OPTION_FLAG_NONE
    if mcm.FixedMerchantProperties.GetNumMerchantsGlobal() == 0
        flag = mcm.OPTION_FLAG_DISABLED
    endIf
    mcm.oid_MerchantManager_ClearAllMerchants = mcm.AddTextOption("Remove All Merchants", mcm.MM_ClickHereText, flag)
EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Managed Merchant Options")
    mcm.oid_MerchantManager_MerchantsList = mcm.AddMenuOption("Merchant: ", mcm.MM_SelectedMerchantName)
    int flag
    if mcm.MM_OptionsEnabled
        flag = mcm.OPTION_FLAG_NONE
    else
        flag = mcm.OPTION_FLAG_DISABLED
    endIf
    mcm.oid_MerchantManager_FenceToggle = mcm.AddToggleOption("Make Fence", mcm.MM_FenceFlag, flag)
    mcm.oid_MerchantManager_JobTypesList = mcm.AddMenuOption("Merchant Type: ", mcm.MM_SelectedJobType, flag)
    mcm.oid_MerchantManager_ClearMerchant = mcm.AddTextOption("Remove Selected Merchant", mcm.MM_ClickHereText, flag)
EndFunction


Function OnSelect(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_FenceToggle)
        mcm.MM_FenceFlag = !mcm.MM_FenceFlag
        mcm.MM_ThisMerchant.PromoteToFence()
        mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag)
    ElseIf (optionId == mcm.oid_MerchantManager_ClearMerchant)
        string msg = "Are you sure you want to remove selected merchant?"
        bool continue = mcm.ShowMessage(msg, true, "$Yes", "$No")
        If (continue)
            mcm.FixedMerchantProperties.YHMerchantManagerScript.RemoveThisMerchant(mcm.MM_ThisMerchant)
            mcm.SetTextOptionValue(mcm.oid_MerchantManager_NumberOfMerchantsText, mcm.FixedMerchantProperties.GetNumMerchantsGlobal(), true)
            OnDefault(mcm, mcm.oid_MerchantManager_MerchantsList)
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_ClearAllMerchants)
        string msg = "Are you sure you want to remove all merchants?"
        bool continue = mcm.ShowMessage(msg, true, "$Yes", "$No")
        If (continue)
            mcm.FixedMerchantProperties.YHMerchantManagerScript.RemoveAllMerchants()
            mcm.SetTextOptionValue(mcm.oid_MerchantManager_NumberOfMerchantsText, mcm.FixedMerchantProperties.GetNumMerchantsGlobal(), true)
            mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearAllMerchants, mcm.OPTION_FLAG_DISABLED, true)
            OnDefault(mcm, mcm.oid_MerchantManager_MerchantsList)
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_OverStockedMerchants)
        mcm.MM_OverStockedEnabled = !mcm.MM_OverStockedEnabled
        mcm.SetToggleOptionValue(optionId, mcm.MM_OverStockedEnabled)
        mcm.FixedMerchantProperties.OverStockedcMerchant = mcm.MM_OverStockedEnabled
        mcm.FixedMerchantProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
        ; int numMerchants = mcm.FixedMerchantProperties.GetNumMerchantsGlobal()
        ; YoureHiredBusinessManagerScript thisMerchant
        ; while numMerchants
        ;     numMerchants -= 1
        ;     thisMerchant = mcm.MM_MerchantsList[numMerchants]
        ;     if(thisMerchant.MerchantChestScript)
        ;         thisMerchant.MerchantChestScript.ResetChest(false)
        ;     endIf
        ; endWhile
    EndIf
EndFunction ; On Select

Function OnMenuOpen(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        Logger("About to instantiate the menu")
        int index = GetIndexOfMerchant(mcm,mcm.MM_SelectedMerchantName)
        mcm.SetMenuDialogStartIndex(index)
        mcm.SetMenuDialogDefaultIndex(index)
        mcm.SetMenuDialogOptions(mcm.MM_MerchantNames)
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        int index = GetIndexOfJobType(mcm)
        mcm.SetMenuDialogStartIndex(index)
        mcm.SetMenuDialogDefaultIndex(index)
        mcm.SetMenuDialogOptions(mcm.MM_JobTypes)
    EndIf
EndFunction

Function OnMenuAccept(YoureHiredMCM mcm, int optionId, int index) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        If (mcm.FixedMerchantProperties.AtLeastOneMerchant)
            mcm.MM_ThisMerchant = GetMerchant(mcm, mcm.MM_MerchantNames[index])
            If mcm.MM_ThisMerchant
                mcm.SetMenuOptionValue(optionId, mcm.MM_ThisMerchant.GetActorName())
                mcm.MM_SelectedMerchantName = mcm.MM_ThisMerchant.GetActorName()
                mcm.SetMenuDialogDefaultIndex(index)
                mcm.SetMenuDialogStartIndex(index)
                mcm.SetMenuOptionValue(optionId, mcm.MM_ThisMerchant.GetActorName(), true)
                EnableMerchantSettings(mcm)
            EndIf
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        Logger("In the Job Types option about to accept")
        mcm.MM_SelectedJobType = mcm.MM_JobTypes[index]
        mcm.SetMenuOptionValue(optionId, mcm.MM_SelectedJobType)
        mcm.SetMenuDialogDefaultIndex(index)
        mcm.SetMenuDialogStartIndex(index)
        mcm.MM_ThisMerchant.ChangeChestType(mcm.MM_SelectedJobType)
    EndIf    
EndFunction

Function OnHighlight(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        mcm.SetInfoText("List of all current merchants - select merchant to change settings")
    ElseIf (optionId == mcm.oid_MerchantManager_FenceToggle)
        mcm.SetInfoText("Select to allow/stop " + mcm.MM_SelectedMerchantName + " from buying stolen items. [Default off] This can also be done through the 'Let's talk about your business' dialogue if the Fence dialogue option is enabled")
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        mcm.SetInfoText("Choose this merchant's type.")
    ElseIf (OptionId == mcm.oid_MerchantManager_ClearMerchant)
        mcm.SetInfoText("The selected merchant will be removed from mod control and will no longer be a managed merchant.")
    ElseIf (optionId == mcm.oid_MerchantManager_ClearAllMerchants)
        mcm.SetInfoText("Removes all merchants from mod control, emptying all managed merchant positions.")
    ElseIf (optionId == mcm.oid_MerchantManager_OverStockedMerchants)
        mcm.SetInfoText("Adds a number of items to each managed merchant type [Default off]")
    ElseIf (optionId == mcm.oid_MerchantManager_ExtraStartingGold)
        mcm.SetInfoText("Increase this merchants base gold amount by the selected amount. [Default 0]")
    EndIf
EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        mcm.SetMenuDialogDefaultIndex(0)
        mcm.SetMenuDialogStartIndex(0)
        mcm.MM_SelectedMerchantName = "Selected Merchant"
        mcm.SetMenuOptionValue(optionId, mcm.MM_SelectedMerchantName, true)
        Logger("in the default section")
        mcm.MM_ThisMerchant = NONE
        DisableMerchantSettings(mcm)
    ElseIf (optionId == mcm.oid_MerchantManager_FenceToggle)
        mcm.MM_FenceFlag = false
        mcm.MM_ThisMerchant.PromoteToFence(true)
        mcm.SetToggleOptionValue(optionId, mcm.MM_FenceFlag)
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        int index = GetIndexOfJobType(mcm)
        mcm.SetMenuDialogDefaultIndex(index)
        mcm.SetMenuDialogStartIndex(index)
        mcm.SetMenuOptionValue(mcm.oid_MerchantManager_JobTypesList, mcm.MM_SelectedJobType)
    ElseIF (optionId == mcm.oid_MerchantManager_OverStockedMerchants)
        mcm.MM_OverStockedEnabled = false
        mcm.FixedMerchantProperties.OverStockedcMerchant = false
        mcm.SetToggleOptionValue(optionId, mcm.MM_OverStockedEnabled)
        mcm.FixedMerchantProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
    ElseIf (optionId == mcm.oid_MerchantManager_ExtraStartingGold)
        mcm.MM_ExtraStartingGold = 0
        mcm.FixedMerchantProperties.ExtraGoldAmount = 0
        mcm.SetSliderOptionValue(optionId, mcm.MM_ExtraStartingGold, "By {0}")
        mcm.FixedMerchantProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
        ; int numMerchants = mcm.FixedMerchantProperties.GetNumMerchantsGlobal()
        ; YoureHiredBusinessManagerScript thisMerchant
        ; while numMerchants
        ;     numMerchants -= 1
        ;     thisMerchant = mcm.MM_MerchantsList[numMerchants]
        ;     if(thisMerchant.MerchantChestScript)
        ;         thisMerchant.MerchantChestScript.ResetChest(false)
        ;     endIf
        ; endWhile
    EndIf
EndFunction ; On Default

Function OnSliderOpen(YoureHiredMCM mcm, int optionId) global
    if optionId == mcm.oid_MerchantManager_ExtraStartingGold
        mcm.SetSliderDialogStartValue(mcm.MM_ExtraStartingGold)
        mcm.SetSliderDialogDefaultValue(0)
        mcm.SetSliderDialogRange(0, 5000)
        mcm.SetSliderDialogInterval(1000)
    endIf
EndFunction

Function OnSliderAccept(YoureHiredMCM mcm, int optionId, float value) global
    Logger("We are in slider accept")
    if optionId == mcm.oid_MerchantManager_ExtraStartingGold
        Logger("we have the right option id")
        mcm.MM_ExtraStartingGold = (value as int)
        Logger("we just set the extrastartinggold mcm property")
        mcm.FixedMerchantProperties.ExtraGoldAmount = (value as int)
        Logger("Just set the extra gold proeprty from fixedMerchantProperties")
        mcm.SetSliderOptionValue(optionId, value, "By {0}")
        Logger(" just set the option value")
        mcm.FixedMerchantProperties.SetNeedToUpdateMerchantChests()
        mcm.FixedMerchantProperties.SetUpdateNeeded()
        ; int numMerchants = mcm.FixedMerchantProperties.GetNumMerchantsGlobal()
        ; YoureHiredBusinessManagerScript thisMerchant
        ; while numMerchants
        ;     numMerchants -= 1
        ;     thisMerchant = mcm.MM_MerchantsList[numMerchants]
        ;     if(thisMerchant.MerchantChestScript)
        ;         thisMerchant.MerchantChestScript.ResetChest(false)
        ;     endIf
        ; endWhile
    endIf
EndFunction

int Function GetIndexOfMerchant(YoureHiredMCM mcm, string merchantName) global
    int index = 0
    YoureHiredBusinessManagerScript foundMerchant
    While (index < mcm.MM_MerchantsList.Length)
        foundMerchant = mcm.MM_MerchantsList[index]
        If (foundMerchant.GetActorReference() && foundMerchant.GetActorName() == merchantName)
            return index
        EndIf
        index += 1
    EndWhile
    return -1
EndFunction

YoureHiredBusinessManagerScript Function GetMerchant(YoureHiredMCM mcm, string merchantName) global
    int index = 0
    YoureHiredBusinessManagerScript foundMerchant
    While (index < mcm.MM_MerchantsList.Length)
        foundMerchant = mcm.MM_MerchantsList[index]
        If (foundMerchant.GetActorReference() && foundMerchant.GetActorName() == merchantName)
            return foundMerchant
        EndIf
        index += 1
    EndWhile
    return none
EndFunction

Function DisableMerchantSettings(YoureHiredMCM mcm) global
    Logger(" in the disable merchant settings fuction")
    mcm.MM_OptionsEnabled = false
    mcm.MM_SelectedJobType = "Current Merchant Type"
    mcm.SetMenuOptionValue(mcm.oid_MerchantManager_JobTypesList, mcm.MM_SelectedJobType, true)
    mcm.MM_FenceFlag = false
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_FenceToggle, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearMerchant, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_JobTypesList, mcm.OPTION_FLAG_DISABLED)
EndFunction

Function EnableMerchantSettings(YoureHiredMCM mcm) global
    If !mcm.MM_OptionsEnabled
        mcm.SetOptionFlags(mcm.oid_MerchantManager_FenceToggle,mcm.OPTION_FLAG_NONE, true)
        mcm.SetOptionFlags(mcm.oid_MerchantManager_JobTypesList, mcm.OPTION_FLAG_NONE, true)
        mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearMerchant, mcm.OPTION_FLAG_NONE, true)
        mcm.MM_OptionsEnabled = true
    EndIf
    mcm.MM_FenceFlag = mcm.MM_ThisMerchant.YoureHiredFaction.OnlyBuysStolenItems()
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag, true)
    mcm.MM_SelectedJobType = mcm.MM_ThisMerchant.GetChestType()
    mcm.SetMenuOptionValue(mcm.oid_MerchantManager_JobTypesList, mcm.MM_SelectedJobType, true)
EndFunction

int Function GetIndexOfJobType(YoureHiredMCM mcm) global
    int index = mcm.MM_JobTypes.Length
    While index
        index -= 1
        if mcm.MM_JobTypes[index] == mcm.MM_ThisMerchant.MerchantChestScript.GetBaseObject().GetName()
            return index
        endIf
    EndWhile
    return -1
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1) global
    if logType == 1
        YHUtil.Log("MCM MerchantManager - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MCM MerchantManager - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction