Scriptname YoureHiredMerchantChestScript extends ObjectReference  
{For manipulating the merchant chest}

YoureHiredMerchantPropertiesScript property FixedProperties auto
ObjectReference property ProxyActor auto
int property ResetHotKey auto
int property ResetSecondaryHotKey auto
bool property RequireSecondaryHotKey auto
bool isSecondaryKeyDown = false
bool isPrimaryKeyDown = false
bool listeningForGameTime = true

int goldReserves = 0
Form lastForm

Event OnInit()
    Logger(" In the OnInit ", logType = 2)
    RegisterForSingleUpdateGameTime((24*FixedProperties.DaysBeforeReset))
EndEvent

Event OnUpdateGameTime()
    self.ResetChest(false)
    Logger("Just reset the chest for: " + ProxyActor.GetBaseObject().GetName())
    RegisterForSingleUpdateGameTime(24*FixedProperties.DaysBeforeReset)
EndEvent

Event OnKeyDown(int keyCode)
    If (UI.IsTextInputEnabled())
        return
    EndIf
    Logger("In the onKeyDown event")
    If (UI.IsMenuOpen("BarterMenu"))
        Logger("The barter menu is open")
        If (Game.UsingGamepad())
            If (keyCode == ResetSecondaryHotKey)
                If (isPrimaryKeyDown)
                    Logger("About to reset!")
                    ResetChest()
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
                    ResetChest()
                    return
                EndIf
                If (isSecondaryKeyDown)
                    Logger("About to reset!")
                    ResetChest()
                    return
                EndIf
                isPrimaryKeyDown = true
            Else
                ResetChest()
                return
            EndIf
        EndIf
    EndIf
EndEvent

Event OnKeyUp(int keycode, float holdTime)
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
    Logger("The menu that was closed is: " + openMenu)
    if openMenu == "BarterMenu"
        Logger("UnRegistering")
        FixedProperties.IsManagedMerchantTrading = false
        If (FixedProperties.ResetOnMenuClose)
            Logger("About to reset the chest on menu close")
            self.ResetChest(false)
        EndIf
        UnregisterForAllKeys()
        UnregisterForMenu(openMenu)
    endIf
EndEvent

Function ListenForHotKeys()
    RegisterForMenu("BarterMenu")
    ResetHotKey = FixedProperties.Hotkey
    Logger("Registering for Hotkeys: " + ResetHotKey)
    RegisterForKey(ResetHotKey)
    RequireSecondaryHotKey = FixedProperties.RequireTwoKeys
    Logger("RequiresSecondaryKey: " + RequireSecondaryHotKey)
    If (RequireSecondaryHotKey)
        Logger("Registering for secondaryHotKey")
        ResetSecondaryHotKey = FixedProperties.SecondaryHotkey
        RegisterForKey(ResetSecondaryHotKey)
    EndIf
EndFunction 

Function StopListeningAll()
    UnregisterForAllKeys()
    UnregisterForAllMenus()
    UnregisterForUpdateGameTime()
EndFunction

Function ToggleOnMenuCloseOrGametime()
    if FixedProperties.ResetOnMenuClose
        Logger("ResetOnMenuClose is true!!")
        If (listeningForGameTime)
            UnregisterForUpdateGameTime()
            listeningForGameTime = false
        EndIf
    else
        if !listeningForGameTime
            Logger("Listening for gametime update: " + FixedProperties.DaysBeforeReset)
            RegisterForSingleUpdateGameTime(24*FixedProperties.DaysBeforeReset)
            listeningForGameTime = true
        endIf
    endIf
EndFunction

Function ResetChest(bool resetMenu = true)
    Logger("About to resest the chest")
    self.ResetInventory()
    int moreGold = 175 + Utility.RandomInt()
    AddItem(FixedProperties.gold, moreGold, true)
    If (GetItemCount(FixedProperties.gold) > FixedProperties.MaxGoldValue)
        int difference = GetItemCount(FixedProperties.gold) - FixedProperties.MaxGoldValue as int
        RemoveItem(FixedProperties.gold, difference, true)        
    EndIf
    if resetMenu
        UI.InvokeNumber("BarterMenu", "_root.Menu_mc.doTransaction", 0.0)
    endIf
    Logger("Just reset the chest for: " + ProxyActor.GetBaseObject().GetName())
EndFunction

Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("MerchantChest - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("MerchantChest - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    Logger("In the on item REMOVED event", false,  logType = 2)
    If (akDestContainer == Game.GetPlayer() && akBaseItem == FixedProperties.gold as Form)
        If (goldReserves > 0 && GetItemCount(FixedProperties.gold) + goldReserves <= FixedProperties.MaxGoldValue as int)
            Logger("GoldReservse: " + goldReserves + ", CurrentCount: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            ProxyActor.RemoveItem(FixedProperties.gold, goldReserves, true, self)
            Logger("GoldReservse: " + goldReserves + ", CurrentCount: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            goldReserves = 0
        ElseIf (GetItemCount(FixedProperties.gold) + goldReserves > FixedProperties.MaxGoldValue as int)
            int difference = (FixedProperties.MaxGoldValue as int) - GetItemCount(FixedProperties.gold)
            Logger("Difference: " + difference + ", currentGold: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            ProxyActor.RemoveItem(FixedProperties.gold, difference, true, self)
            Logger("Difference: " + difference + ", currentGold: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            goldReserves -= difference
        EndIf
    EndIf
    If (FixedProperties.LowCountReset)
        If self.GetNumItems() < 5
            Logger("Reseting chest due to low item count")
            ResetChest()
        EndIf
    EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    Logger("In item ADDED event", false, logType = 2)
    If (akSourceContainer == Game.GetPlayer() && akBaseItem == FixedProperties.gold as Form)
        If (GetItemCount(FixedProperties.gold) > (FixedProperties.MaxGoldValue as int)) 
            int difference = GetItemCount(FixedProperties.gold) - (FixedProperties.MaxGoldValue as int)
            Logger("Difference: " + difference + ", currentGold: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            RemoveItem(FixedProperties.gold, difference, true, ProxyActor)
            Logger("Difference: " + difference + ", currentGold: " + GetItemCount(FixedProperties.gold) + ", proxyactor (" + ProxyActor.GetBaseObject().GetName() + ") gold count: " + ProxyActor.GetItemCount(FixedProperties.gold))
            goldReserves += difference
        EndIf
    EndIf
    If (FixedProperties.LowCountReset)
        If self.GetItemCount(FixedProperties.gold) < 150
            Logger("Reseting chest due to low gold from On Item ADDED")
            ResetChest()
        EndIf
    EndIf
EndEvent


