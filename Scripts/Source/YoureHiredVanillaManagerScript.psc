Scriptname YoureHiredVanillaManagerScript extends Quest  
{Used for any/all vanilla merchants that aren't currently You're Hired merchants}

YoureHiredMerchantPropertiesScript property FixedProperties auto
int property ResetHotKey auto
int property ResetSecondaryHotKey auto
bool property RequireSecondaryHotKey auto


Actor CurrentMerchant
bool weAreListening
bool isSecondaryKeyDown
bool isPrimaryKeyDown
bool vanillaResetFlag = false
int MAXGOLDAMOUNT = 25000
Faction[] vanillaFactions

Event OnInit()
    RegisterForModEvent("aaslrYH_UpdateResetCriteria", "OnResetUpdateCriteria")
EndEvent

Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_UpdateResetCriteria", "OnResetUpdateCriteria")
EndFunction

Event OnResetUpdateCriteria()
    if weAreListening
        StopListenting()
    else
        ListenForMenuAndHotKeys()
    endIf
    weAreListening = !weAreListening
EndEvent

Event OnMenuOpen(string openMenu)
    if openMenu == "BarterMenu"
        If (!FixedProperties.IsManagedMerchantTrading)
            If FixedProperties.EnableHotKeyUse
                CurrentMerchant = Game.GetCurrentCrosshairRef() as Actor
                If !FixedProperties.MerchantManager.IsManagedMerchant(CurrentMerchant)
                    vanillaResetFlag = true
                    vanillaFactions = CurrentMerchant.GetFactions(-120,120)
                    ResetHotKey = FixedProperties.Hotkey
                    Logger("Registering for Hotkeys: " + ResetHotKey)
                    RegisterForKey(ResetHotKey)
                    If (FixedProperties.RequireTwoKeys)
                        Logger("Registering for secondaryHotKey")
                        ResetSecondaryHotKey = FixedProperties.SecondaryHotkey
                        RegisterForKey(ResetSecondaryHotKey)
                    EndIf
                EndIf
                ; If FixedProperties.ResetVanillaMerchant
                ; EndIf
            EndIf    
        EndIf
    EndIf
EndEvent

Event OnKeyDown(int keyCode)
    Logger("In the onKeyDown event")
    If (vanillaResetFlag)
        Logger("The barter menu is open")
        If (Game.UsingGamepad())
            If (keyCode == ResetSecondaryHotKey)
                If (isPrimaryKeyDown)
                    Logger("About to reset!")
                    ResetChest(CurrentMerchant)
                    return
                EndIf
                isSecondaryKeyDown = true
            EndIf
        EndIf
        If (keyCode == ResetHotKey)
            Logger("It is our keycode: " + keyCode + ", " + ResetHotKey)
            If (RequireSecondaryHotKey)
                Logger("In required secondary ")
                If (Input.IsKeyPressed(ResetSecondaryHotKey))
                    Logger("in is key pressed")
                    ResetChest(CurrentMerchant)
                EndIf
                If (isSecondaryKeyDown)
                    ResetChest(CurrentMerchant)
                EndIf
            Else
                ResetChest(CurrentMerchant)
            EndIf
        EndIf
    EndIf
EndEvent

Event OnKeyUP(int keycode, float holdTime)
    Logger("We are in the key up event with: " + keycode + ", reset key: " + ResetHotKey + ", reset secondary key: " + ResetSecondaryHotKey)
    If (UI.IsMenuOpen("BarterMenu"))
        If (keyCode == ResetSecondaryHotKey)
            isSecondaryKeyDown = false
        EndIf
        If (keycode == ResetHotKey)
            isPrimaryKeyDown = false
        EndIf
    EndIf
EndEvent

Event OnMenuClose(string openMenu)
    if openMenu == "BarterMenu"
        Logger("UnRegistering")
        FixedProperties.IsManagedMerchantTrading = false
        vanillaResetFlag = false
        If (FixedProperties.ResetOnMenuClose && FixedProperties.aaslrResetVanillaFlagGlobal.GetValue() > 0)
            ResetChest(CurrentMerchant)
        EndIf
        CurrentMerchant = NONE
        UnregisterForAllKeys()
        ; UnregisterForMenu(openMenu)
    endIf
EndEvent

Function ListenForMenuAndHotKeys()
    RegisterForMenu("BarterMenu")
    Logger("Listening for menu")
EndFunction

Function StopListenting()
    UnregisterForMenu("BarterMenu")
EndFunction

Function ResetChest(Actor akMerchant)
    int numFactions = vanillaFactions.Length
    YHUtil.AddLineBreakWithText(" Attempting to reset merchant: " + akMerchant.GetBaseObject().GetName())
    Faction thisFaction
    Logger("Num factions: " + numFactions + ", factions array: " + vanillaFactions)
    while numFactions
        numFactions -= 1
        thisFaction = vanillaFactions[numFactions]
        If (thisFaction.GetMerchantContainer())
            Logger("Merchant chest is not null, resting...")
            int goldInChest = thisFaction.GetMerchantContainer().GetItemCount(FixedProperties.gold)
            thisFaction.GetMerchantContainer().Reset()
            If (vanillaResetFlag)
                UI.InvokeFloat("BarterMenu", "_root.Menu_mc.doTransaction", 0.0)
            EndIf
            If (goldInChest <= MAXGOLDAMOUNT)
                Logger("Chest had less than max. goldInChest: " + goldInChest + ", merchnat has: " + akMerchant.GetItemCount(FixedProperties.gold) + " gold!")
                int currentGold = thisFaction.GetMerchantContainer().GetItemCount(FixedProperties.gold)
                If (goldInChest > currentGold)
                    goldInChest -= currentGold
                    thisFaction.GetMerchantContainer().AddItem(FixedProperties.gold, goldInChest, true)
                EndIf
                Logger("After reset. actual gold in chest: " + thisFaction.GetMerchantContainer().GetItemCount(FixedProperties.gold) + ", merchnat has: " + akMerchant.GetItemCount(FixedProperties.gold) + " gold!")
            Else
                Logger("Chest had more than max. goldInChest: " + goldInChest + ", merchnat has: " + akMerchant.GetItemCount(FixedProperties.gold) + " gold!")
                goldInChest = MAXGOLDAMOUNT
                goldInChest -= thisFaction.GetMerchantContainer().GetItemCount(FixedProperties.gold)
                thisFaction.GetMerchantContainer().AddItem(FixedProperties.gold, goldInChest, true)
                Logger("After reset. actual gold in chest: " + thisFaction.GetMerchantContainer().GetItemCount(FixedProperties.gold) + ", merchnat has: " + akMerchant.GetItemCount(FixedProperties.gold) + " gold!")
            EndIf
        EndIf
    endWhile
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("VanillaManager - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("VanillaManager - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction