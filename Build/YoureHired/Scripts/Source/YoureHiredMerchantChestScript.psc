Scriptname YoureHiredMerchantChestScript extends ObjectReference  
{For manipulating the merchant chest}

Import YHUtil

YoureHiredMerchantPropertiesScript property FixedProperties auto
ObjectReference property ProxyActor auto
int property ResetHotKey auto
int property ResetSecondaryHotKey auto
bool property RequireSecondaryHotKey auto
bool isSecondaryKeyDown = false
bool isPrimaryKeyDown = false
bool listeningForGameTime = true
int itemCountCutOff 
int goldCountCutOff

int goldReserves = 0
Form lastForm

Event OnInit()
    AddLineBreakWithText(self + " In the OnInit ")
    RegisterForSingleUpdateGameTime((24*FixedProperties.DaysBeforeReset))
    itemCountCutOff = (self.GetNumItems() * 0.1) as int
    goldCountCutOff = (self.GetItemCount(FixedProperties.gold) * 0.2) as int
EndEvent

Event OnUpdateGameTime()
    self.ResetChest(false)
    Log(self + "Just reset the chest for: " + ProxyActor.GetBaseObject().GetName())
    RegisterForSingleUpdateGameTime(24*FixedProperties.DaysBeforeReset)
EndEvent

Event OnKeyDown(int keyCode)
    If (UI.IsTextInputEnabled())
        return
    EndIf
    Log(self + "In the onKeyDown event")
    If (UI.IsMenuOpen("BarterMenu"))
        Log(self + "The barter menu is open")
        If (Game.UsingGamepad())
            If (keyCode == ResetSecondaryHotKey)
                If (isPrimaryKeyDown)
                    Log(self + "About to reset!")
                    ResetChest()
                    return
                EndIf
                isSecondaryKeyDown = true
            EndIf
        EndIf
        If (keyCode == ResetHotKey)
            Log(self + "It is our keycode: " + keyCode + ", " + ResetHotKey)
            If (RequireSecondaryHotKey)
                Log(self + "In required secondary ")
                If (Input.IsKeyPressed(ResetSecondaryHotKey))
                    Log(self + "in is key pressed")
                    ResetChest()
                    return
                EndIf
                If (isSecondaryKeyDown)
                    Log(self + "About to reset!")
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
    Log(self + "We are in the key up event with: " + keycode + ", reset key: " + ResetHotKey + ", reset secondary key: " + ResetSecondaryHotKey)
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
    Log(self + "The menu that was closed is: " + openMenu)
    if openMenu == "BarterMenu"
        Log(self + "UnRegistering")
        FixedProperties.IsManagedMerchantTrading = false
        If (FixedProperties.ResetOnMenuClose)
            Log(self + "About to reset the chest on menu close")
            self.ResetChest(false)
        EndIf
        UnregisterForAllKeys()
        UnregisterForMenu(openMenu)
    endIf
EndEvent

Function ListenForHotKeys()
    RegisterForMenu("BarterMenu")
    ResetHotKey = FixedProperties.Hotkey
    Log(self + "Registering for Hotkeys: " + ResetHotKey)
    RegisterForKey(ResetHotKey)
    RequireSecondaryHotKey = FixedProperties.RequireTwoKeys
    Log(self + "RequiresSecondaryKey: " + RequireSecondaryHotKey)
    If (RequireSecondaryHotKey)
        Log(self + "Registering for secondaryHotKey")
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
        Log(self + "ResetOnMenuClose is true!!")
        If (listeningForGameTime)
            UnregisterForUpdateGameTime()
            listeningForGameTime = false
        EndIf
    else
        if !listeningForGameTime
            Log(self + "Listening for gametime update: " + FixedProperties.DaysBeforeReset)
            RegisterForSingleUpdateGameTime(24*FixedProperties.DaysBeforeReset)
            listeningForGameTime = true
        endIf
    endIf
EndFunction

Function ResetChest(bool resetMenu = true)
    Log(self + "About to resest the chest")
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
    itemCountCutOff = (self.GetNumItems() * 0.1) as int
    goldCountCutOff = (self.GetItemCount(FixedProperties.gold) * 0.2) as int
EndFunction

Function BuyJunk(int amount)
    int chestGold = GetItemCount(FixedProperties.gold)
    if amount <= chestGold
        RemoveItem(FixedProperties.gold, amount)
        return
    endIf
    ProxyActor.RemoveItem(FixedProperties.gold, amount-chestGold)
    RemoveItem(FixedProperties.gold, chestGold)
EndFunction

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    AddLineBreakWithText("In the on item REMOVED event", false)
    If (akDestContainer == Game.GetPlayer() && akBaseItem == FixedProperties.gold as Form)
        If (goldReserves > 0 && GetItemCount(FixedProperties.gold) + goldReserves <= FixedProperties.MaxGoldValue as int)
            ProxyActor.RemoveItem(FixedProperties.gold, goldReserves, true, self)
            goldReserves = 0
        ElseIf (GetItemCount(FixedProperties.gold) + goldReserves > FixedProperties.MaxGoldValue as int)
            int difference = (FixedProperties.MaxGoldValue as int) - GetItemCount(FixedProperties.gold)
            ProxyActor.RemoveItem(FixedProperties.gold, difference, true, self)
            goldReserves -= difference
        EndIf
    EndIf
    If (FixedProperties.LowCountReset)
        If self.GetNumItems() < itemCountCutOff
            Log(self + "Reseting chest due to low item count: " + itemCountCutOff)
            ResetChest()
        EndIf
    EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    AddLineBreakWithText("In item ADDED event", false)
    If (akSourceContainer == Game.GetPlayer() && akBaseItem == FixedProperties.gold as Form)
        If (GetItemCount(FixedProperties.gold) > (FixedProperties.MaxGoldValue as int)) 
            int difference = GetItemCount(FixedProperties.gold) - (FixedProperties.MaxGoldValue as int)
            RemoveItem(FixedProperties.gold, difference, true, ProxyActor)
            goldReserves += difference
        EndIf
    EndIf
    If (FixedProperties.LowCountReset)
        If self.GetItemCount(FixedProperties.gold) < goldCountCutOff
            Log(self + "Reseting chest due to low gold from On Item ADDED: " + goldCountCutOff)
            ResetChest()
        EndIf
    EndIf
EndEvent


