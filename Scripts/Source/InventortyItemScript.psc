Scriptname InventortyItemScript extends ObjectReference  
YoureHiredMCM property mcm auto


Message property DropStallMessage auto
bool property ShowDropMessage = true auto
string teststring

Event OnInit()
    
    YHUtil.Log("INVENTORY: We are in the inventory items on init")
    teststring = " we are the test string "
EndEvent

Event OnEquipped(Actor akActor)
    If (akActor == Game.GetPlayer())
        ; code
        YHUtil.Log("We are in teh On Equipped for the misc item with: " + Self.GetName())
    EndIf
    YHUtil.Log("Someone else is trying to equip our merchant stand!! GET THEM~" + akActor.GetBaseObject().GetName())
EndEvent

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)

    YHUtil.Log("We are in teh change container event." + teststring)
    if akOldContainer && !akNewContainer
        if ShowDropMessage
            int answer = DropStallMessage.Show()
            YHUtil.Log("answer: " + answer + ", answer % 2: " + (answer % 2))
            if answer > 0
                YHUtil.Log("You decided to keep the item.")
                akOldContainer.AddItem(self as form, 1, true)
            endIf
        endIf
    elseif akNewContainer && !akOldContainer
      Debug.Trace("We have been picked up!")
    else
      Debug.Trace("We have switched containers!")
    endIf
endEvent