Scriptname YoureHiredMCM_MerchantManagementPage  Hidden 
{For managing merchants managed by this mod.}

Import YHUtil


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
    mcm.AddHeaderOption("Merchants")
    mcm.oid_MerchantManager_NumberOfMerchantsText = mcm.AddTextOption("Merchant Count:", mcm.FixedProperties.GetNumMerchantsGlobal() + "/" + mcm.FixedProperties.aaslrMaxNumberMerchants.GetValueInt())
    mcm.oid_MerchantManager_MerchantsList = mcm.AddMenuOption("Merchant: ", mcm.MM_SelectedMerchantName)
    mcm.AddEmptyOption()
    int flag = mcm.OPTION_FLAG_NONE
    if mcm.FixedProperties.GetNumMerchantsGlobal() == 0
        flag = mcm.OPTION_FLAG_DISABLED
    endIf
    mcm.oid_MerchantManager_ClearAllMerchants = mcm.AddTextOption("Dismiss All Merchants", mcm.MM_ClickHereText, flag)

EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Merchant Settings")
    int flag
    int workFlag
    int liveFlag
    if mcm.MM_OptionsEnabled
        flag = mcm.OPTION_FLAG_NONE
        If (mcm.FixedProperties.GetRugActivatorAsScript(mcm.MM_ThisMerchant.GetMerchantIndex()))
            liveFlag = mcm.OPTION_FLAG_NONE
        EndIf
        If (mcm.FixedProperties.GetStallActivatorAsScript(mcm.MM_ThisMerchant.GetMerchantIndex()))
            workFlag = mcm.OPTION_FLAG_NONE
        EndIf
    else
        flag = mcm.OPTION_FLAG_DISABLED
        liveFlag = flag
        workFlag = flag
    endIf
    mcm.oid_MerchantManager_FenceToggle = mcm.AddToggleOption("Make Fence", mcm.MM_FenceFlag, flag)
    mcm.oid_MerchantManager_EnableWorkAtStall = mcm.AddToggleOption("Work At Stall", mcm.MM_WorkAtStall, workFlag)
    mcm.oid_MerchantManager_EnableLiveAtHome = mcm.AddToggleOption("Live At Home", mcm.MM_LiveAtHome, liveFlag)
    mcm.oid_MerchantManager_JobTypesList = mcm.AddMenuOption("Merchant Type: ", mcm.MM_SelectedJobType, flag)
    mcm.AddEmptyOption()
    mcm.oid_MerchantManager_LocateMerchant = mcm.AddToggleOption("Locate Selected Merchant", mcm.MM_LocateMerchant, flag)
    mcm.oid_MerchantManager_ClearMerchant = mcm.AddTextOption("Dismiss Selected Merchant", mcm.MM_ClickHereText, flag)
EndFunction


Function OnSelect(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_FenceToggle)
        mcm.MM_FenceFlag = !mcm.MM_FenceFlag
        mcm.MM_ThisMerchant.PromoteToFence()
        mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag)
    ElseIf (optionId == mcm.oid_MerchantManager_ClearMerchant)
        string msg = "Are you sure you want to dismiss the selected merchant?"
        bool continue = mcm.ShowMessage(msg, true, "$Yes", "$No")
        If (continue)
            mcm.FixedProperties.MerchantManager.RemoveThisMerchant(mcm.MM_ThisMerchant)
            mcm.SetTextOptionValue(mcm.oid_MerchantManager_NumberOfMerchantsText, mcm.FixedProperties.GetNumMerchantsGlobal(), true)
            OnDefault(mcm, mcm.oid_MerchantManager_MerchantsList)
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_ClearAllMerchants)
        string msg = "Are you sure you want to dismiss all merchants?"
        bool continue = mcm.ShowMessage(msg, true, "$Yes", "$No")
        If (continue)
            mcm.FixedProperties.MerchantManager.RemoveAllMerchants()
            mcm.SetTextOptionValue(mcm.oid_MerchantManager_NumberOfMerchantsText, mcm.FixedProperties.GetNumMerchantsGlobal() + "/" + mcm.FixedProperties.aaslrMaxNumberMerchants.GetValueInt(), true)
            mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearAllMerchants, mcm.OPTION_FLAG_DISABLED, true)
            OnDefault(mcm, mcm.oid_MerchantManager_MerchantsList)
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_LocateMerchant)
        mcm.MM_LocateMerchant = !mcm.MM_LocateMerchant
        mcm.SetToggleOptionValue(optionId, mcm.MM_LocateMerchant)
        ; int stage = (mcm.MM_ThisMerchant.GetMerchantIndex() + 1) * 10
        ; mcm.MM_CurrentObjectiveStage = stage
        ; if mcm.MM_LocateMerchant
        ;     mcm.SetObjectiveDisplayed(stage, true, true)
        ;     mcm.YoureHired.SetStage(stage)
        ;     mcm.MM_ThisMerchant.LocateMerchant()
        ; else
        ;     mcm.SetObjectiveDisplayed(stage, false)
        ;     mcm.YoureHired.SetStage(0)
        ; endIf
    ElseIf (optionId == mcm.oid_MerchantManager_EnableWorkAtStall)
        mcm.MM_WorkAtStall = !mcm.MM_WorkAtStall
        mcm.SetToggleOptionValue(optionId, mcm.MM_WorkAtStall)
    ElseIf (optionId == mcm.oid_MerchantManager_EnableLiveAtHome)
        mcm.MM_LiveAtHome = !mcm.MM_LiveAtHome
        mcm.SetToggleOptionValue(optionId, mcm.MM_LiveAtHome)
    EndIf
EndFunction ; On Select

Function OnMenuOpen(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        Log("MCM_MerchantManager - About to instantiate the menu")
        int index = GetIndexOfMerchant(mcm,mcm.MM_SelectedMerchantName)
        mcm.SetMenuDialogOptions(mcm.MM_MerchantNames)
        mcm.SetMenuDialogStartIndex(index)
        mcm.SetMenuDialogDefaultIndex(index)
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        int index = GetIndexOfJobType(mcm)
        mcm.SetMenuDialogStartIndex(index)
        mcm.SetMenuDialogDefaultIndex(index)
        mcm.SetMenuDialogOptions(mcm.MM_JobTypes)
    EndIf
EndFunction

Function OnMenuAccept(YoureHiredMCM mcm, int optionId, int index) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        Log("MCM_MerchantManager - We accepted the menu")
        If (mcm.FixedProperties.HasAtLeastOneMerchant())
            mcm.MM_ThisMerchant = GetMerchant(mcm, mcm.MM_MerchantNames[index])
            If mcm.MM_ThisMerchant
                mcm.SetMenuOptionValue(optionId, mcm.MM_ThisMerchant.GetActorName())
                mcm.MM_SelectedMerchantName = mcm.MM_ThisMerchant.GetActorName()
                mcm.SetMenuDialogDefaultIndex(index)
                mcm.SetMenuDialogStartIndex(index)
                mcm.SetMenuOptionValue(optionId, mcm.MM_ThisMerchant.GetActorName(), true)
                EnableMerchantSettings(mcm)
                Log("MCM_MerchantManager - Just enabled teh settings")
            EndIf
        EndIf
    ElseIf (optionId == mcm.oid_MerchantManager_JobTypesList)
        Log("MCM_MerchantManager - In the Job Types option about to accept")
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
        mcm.SetInfoText("The selected merchant will be dismissed from mod control and will no longer be a managed merchant.")
    ElseIf (optionId == mcm.oid_MerchantManager_ClearAllMerchants)
        mcm.SetInfoText("Dismisses all merchants from mod control, emptying all managed merchant positions.")
    ElseIf (optionId == mcm.oid_MerchantManager_LocateMerchant)
        mcm.SetInfoText("Adds a quest objective that points to the selected merchant. [Default off]")
    ElseIf (optionId == mcm.oid_MerchantManager_EnableWorkAtStall)
        mcm.SetInfoText("When enabled, selected merchant will work at thier merhcant stall (stall must be purchased from merchant and placed). Disable if the merchant is needed for a quest. [Default on (when a stall is palced)]")
    ElseIf (optionId == mcm.oid_MerchantManager_EnableLiveAtHome)
        mcm.SetInfoText("When enabled, selected merchant will live/sleep where the merhcant rug is placed (rug must be purchased from merchant and placed). Disable if the merchant is needed for a quest. [Default on (when a rug is palced)]")
    EndIf
EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_MerchantManager_MerchantsList)
        mcm.SetMenuDialogDefaultIndex(-1)
        mcm.SetMenuDialogStartIndex(-1)
        mcm.MM_SelectedMerchantName = "Selected Merchant"
        mcm.SetMenuOptionValue(optionId, mcm.MM_SelectedMerchantName, true)
        Log("MCM_MerchantManager - in the default section")
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
    ElseIf (optionId == mcm.oid_MerchantManager_LocateMerchant)
        if mcm.MM_LocateMerchant
            ; int stage = (mcm.MM_ThisMerchant.GetMerchantIndex() + 1) * 10
            ; mcm.SetObjectiveDisplayed(stage, false)
            ; mcm.YoureHired.SetStage(0)
            mcm.MM_LocateMerchant = false
        endIf
        mcm.SetToggleOptionValue(optionId, mcm.MM_LocateMerchant)
    ElseIf (optionId == mcm.oid_MerchantManager_EnableWorkAtStall)
        mcm.MM_WorkAtStall = false
        mcm.SetToggleOptionValue(optionId, mcm.MM_WorkAtStall)
    ElseIf (optionId == mcm.oid_MerchantManager_EnableLiveAtHome)
        mcm.MM_LiveAtHome = false
        mcm.SetToggleOptionValue(optionId, mcm.MM_LiveAtHome)
    EndIf
EndFunction ; On Default

Function OnSliderOpen(YoureHiredMCM mcm, int optionId) global
EndFunction

Function OnSliderAccept(YoureHiredMCM mcm, int optionId, float value) global
    Log("MCM_MerchantManager - We are in slider accept")
EndFunction

int Function GetIndexOfMerchant(YoureHiredMCM mcm, string merchantName) global
    int index = 0
    BusinessScript foundMerchant
    While (index < mcm.MM_MerchantsList.Length)
        foundMerchant = mcm.MM_MerchantsList[index]
        If (foundMerchant.GetActorReference() && foundMerchant.GetActorName() == merchantName)
            return index
        EndIf
        index += 1
    EndWhile
    return -1
EndFunction

BusinessScript Function GetMerchant(YoureHiredMCM mcm, string merchantName) global
    int index = 0
    BusinessScript foundMerchant
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
    Log("MCM_MerchantManager -  in the disable merchant settings fuction")
    mcm.MM_OptionsEnabled = false
    mcm.MM_SelectedJobType = "Current Merchant Type"
    mcm.SetMenuOptionValue(mcm.oid_MerchantManager_JobTypesList, mcm.MM_SelectedJobType, true)
    mcm.MM_FenceFlag = false
    mcm.MM_LocateMerchant = false
    mcm.MM_WorkAtStall = false
    mcm.MM_LiveAtHome = false
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_LocateMerchant, mcm.MM_LocateMerchant, true)
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_EnableWorkAtStall, mcm.MM_WorkAtStall, true)
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_EnableLiveAtHome, mcm.MM_LiveAtHome, true)
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_FenceToggle, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearMerchant, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableWorkAtStall, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableLiveAtHome, mcm.OPTION_FLAG_DISABLED, true)
    mcm.SetOptionFlags(mcm.oid_MerchantManager_JobTypesList, mcm.OPTION_FLAG_DISABLED)
EndFunction

Function EnableMerchantSettings(YoureHiredMCM mcm) global
    If !mcm.MM_OptionsEnabled
        mcm.SetOptionFlags(mcm.oid_MerchantManager_FenceToggle, mcm.OPTION_FLAG_NONE, true)
        mcm.SetOptionFlags(mcm.oid_MerchantManager_JobTypesList, mcm.OPTION_FLAG_NONE, true)
        mcm.SetOptionFlags(mcm.oid_MerchantManager_ClearMerchant, mcm.OPTION_FLAG_NONE, true)
        mcm.SetOptionFlags(mcm.oid_MerchantManager_LocateMerchant, mcm.OPTION_FLAG_NONE, true)
        mcm.MM_OptionsEnabled = true
    EndIf
    If (mcm.FixedProperties.GetRugActivatorAsScript(mcm.MM_ThisMerchant.GetMerchantIndex()))
        mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableLiveAtHome, mcm.OPTION_FLAG_NONE, true)
    Else
        mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableLiveAtHome, mcm.OPTION_FLAG_DISABLED, true)
    EndIf
    If (mcm.FixedProperties.GetStallActivatorAsScript(mcm.MM_ThisMerchant.GetMerchantIndex()))
        mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableWorkAtStall, mcm.OPTION_FLAG_NONE, true)
    Else
        mcm.SetOptionFlags(mcm.oid_MerchantManager_EnableWorkAtStall, mcm.OPTION_FLAG_DISABLED, true)
    EndIf
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_EnableWorkAtStall, mcm.MM_WorkAtStall, true)
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_EnableLiveAtHome, mcm.MM_LiveAtHome, true)
    mcm.MM_LocateMerchant = (mcm.YoureHired.GetStage() > 0 && (mcm.YoureHired.GetStage() == mcm.MM_MerchantsObjectiveStage))
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_LocateMerchant, mcm.MM_LocateMerchant, true)
    mcm.MM_FenceFlag = mcm.MM_ThisMerchant.YoureHiredFaction.OnlyBuysStolenItems()
    mcm.SetToggleOptionValue(mcm.oid_MerchantManager_FenceToggle, mcm.MM_FenceFlag, true)
    mcm.MM_SelectedJobType = mcm.MM_ThisMerchant.GetChestType()
    mcm.SetMenuOptionValue(mcm.oid_MerchantManager_JobTypesList, mcm.MM_SelectedJobType)
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
