Scriptname QuestMaintenanceScript extends Quest  

Quest property YoureHiredQuest auto

float fVersion

Event OnInit()
    Maintenance()
EndEvent


Function Maintenance()
    If (fVersion < 1.0)
        fVersion = 1.0
    EndIf
    ; Used for version conrtoll 
    ; (YoureHiredQuest as YoureHiredVanillaManagerScript).ListenForModEvents()
    (YoureHiredQuest as MerchantStandPlacementThreadManager).ListenForModEvents()
    (YoureHiredQuest as YoureHiredMerchantPropertiesScript).SendListeningCommands()
EndFunction 