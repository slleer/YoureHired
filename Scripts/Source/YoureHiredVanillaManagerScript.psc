Scriptname YoureHiredVanillaManagerScript extends Quest  
{Used for any/all vanilla merchants that aren't currently You're Hired merchants}

YoureHiredMerchantPropertiesScript property FixedMerchantProperties auto
int property ResetHotKey auto
int property ResetSecondaryHotKey auto
bool property RequireSecondaryHotKey auto
Actor property CurrentMerchant auto
bool isSecondaryKeyDown
bool vanillaResetFlag = false
int MAXGOLDAMOUNT = 25000

Event OnMenuOpen(string openMenu)
    if openMenu == "BarterMenu"
        If (!FixedMerchantProperties.IsManagedMerchantTrading)
            If FixedMerchantProperties.EnableHotKeyUse
                CurrentMerchant = Game.GetCurrentCrosshairRef() as Actor
                If !FixedMerchantProperties.YHMerchantManagerScript.Merchants.HasForm(CurrentMerchant)
                    vanillaResetFlag = true
                    ResetHotKey = FixedMerchantProperties.Hotkey
                    Logger("Registering for Hotkeys: " + ResetHotKey)
                    RegisterForKey(ResetHotKey)
                    RequireSecondaryHotKey = FixedMerchantProperties.RequireTwoKeys
                    Logger("RequiresSecondaryKey: " + RequireSecondaryHotKey)
                    If (RequireSecondaryHotKey)
                        Logger("Registering for secondaryHotKey")
                        ResetSecondaryHotKey = FixedMerchantProperties.SecondaryHotkey
                        RegisterForKey(ResetSecondaryHotKey)
                    EndIf
                EndIf
                ; If FixedMerchantProperties.ResetVanillaMerchant
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
    EndIf
EndEvent

Event OnMenuClose(string openMenu)
    if openMenu == "BarterMenu"
        Logger("UnRegistering")
        FixedMerchantProperties.IsManagedMerchantTrading = false
        vanillaResetFlag = false
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
    Faction[] vanillaFactions = akMerchant.GetFactions(-120,120)
    int numFactions = vanillaFactions.Length
    YHUtil.AddLineBreakWithText(" Attempting to reset merchant: " + akMerchant.GetBaseObject().GetName())
    Faction thisFaction
    Logger("Num factions: " + numFactions + ", factions array: " + vanillaFactions)
    while numFactions
        numFactions -= 1
        thisFaction = vanillaFactions[numFactions]
        If (thisFaction.GetMerchantContainer())
            Logger("Merchant chest is not null, resting...")
            int goldInChest = thisFaction.GetMerchantContainer().GetItemCount(FixedMerchantProperties.gold)
            thisFaction.GetMerchantContainer().Reset()
            If (vanillaResetFlag)
                UI.InvokeFloat("BarterMenu", "_root.Menu_mc.doTransaction", 0.0)
                thisFaction.GetMerchantContainer().addItem(FixedMerchantProperties.gold, 1, true)
            EndIf
            If (goldInChest <= MAXGOLDAMOUNT)
                Logger("Chest had less than max. goldInChest: " + goldInChest + ", merchnat has: " + akMerchant.GetItemCount(FixedMerchantProperties.gold) + " gold!")
                int currentGold = thisFaction.GetMerchantContainer().GetItemCount(FixedMerchantProperties.gold)
                If (goldInChest > currentGold)
                    goldInChest -= currentGold
                    thisFaction.GetMerchantContainer().AddItem(FixedMerchantProperties.gold, goldInChest, true)
                EndIf
                Logger("After reset. actual gold in chest: " + thisFaction.GetMerchantContainer().GetItemCount(FixedMerchantProperties.gold) + ", merchnat has: " + akMerchant.GetItemCount(FixedMerchantProperties.gold) + " gold!")
            Else
                Logger("Chest had more than max. goldInChest: " + goldInChest + ", merchnat has: " + akMerchant.GetItemCount(FixedMerchantProperties.gold) + " gold!")
                goldInChest = MAXGOLDAMOUNT
                goldInChest -= thisFaction.GetMerchantContainer().GetItemCount(FixedMerchantProperties.gold)
                thisFaction.GetMerchantContainer().AddItem(FixedMerchantProperties.gold, goldInChest, true)
                Logger("After reset. actual gold in chest: " + thisFaction.GetMerchantContainer().GetItemCount(FixedMerchantProperties.gold) + ", merchnat has: " + akMerchant.GetItemCount(FixedMerchantProperties.gold) + " gold!")
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