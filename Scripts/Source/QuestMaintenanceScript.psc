Scriptname QuestMaintenanceScript extends Quest  

Import YHUtil

Quest property YoureHiredQuest auto


float fVersion = 1.0

Event OnInit()
    FormList childGiftFemale = (Game.GetFormFromFile(0x007B75, "HearthFires.esm") as FormList)
    FormList childGiftMale = (Game.GetFormFromFile(0x007B74, "HearthFires.esm") as FormList)
    MiscObject toyMerchantStall = (Game.GetFormFromFile(0x415A9C, "You'reHired!.esp") as MiscObject)
    
    Log(self + "We didn't find the toy!!! Male: " + childGiftMale + ", Female: " + childGiftFemale + ", Toy: " + toyMerchantStall)
    if toyMerchantStall
        if childGiftFemale
            (childGiftFemale as FormList).AddForm(toyMerchantStall)
            Log(self + "we added to the female list: " + (childGiftFemale as FormList).HasForm(toyMerchantStall))
        endIf
        if childGiftMale
            (childGiftMale as FormList).AddForm(toyMerchantStall)
            Log(self + "we added to the male list: " + (childGiftMale as FormList).HasForm(toyMerchantStall))
        endIf
    else
        Log(self + "We didn't find the toy!!! Male: " + childGiftMale + ", Female: " + childGiftFemale)
    endIf
EndEvent


Function Maintenance()
    ; Used for version conrtoll 

    Log(self + "In the mainenance function about to start lisenting for mod events.")

    ; (YoureHiredQuest as YoureHiredVanillaManagerScript).ListenForModEvents()
    (YoureHiredQuest as MerchantStandPlacementThreadManager).ListenForModEvents()
    (YoureHiredQuest as YoureHiredMerchantPropertiesScript).SendListeningCommands()
    (YoureHiredQuest as YoureHiredVanillaManagerScript).ListenForModEvents()
    (YoureHiredQuest as MerchantScript).LoadGameMaintenance()
    Log(self + " We are now listening for all the mod events.")
EndFunction 