Scriptname PlayerRefScript extends ReferenceAlias  
{To handle OnPlayerLoadGame Events}

QuestMaintenanceScript property QuestScript auto
FormList property JunkFilterFormList auto
int[] count
Form[] junk
int[] baseValue

Event OnInit()
    AddInventoryEventFilter(JunkFilterFormList)
    RegisterForModEvent("aaslrYH_JunkFilterEvent", "OnJunkFilterChange")
EndEvent

Event OnPlayerLoadGame()
    RegisterForModEvent("aaslrYH_JunkFilterEvent", "OnJunkFilterChange")
    QuestScript.Maintenance()
EndEvent

Event OnJunkFilterChange()
    junk = JunkFilterFormList.ToArray()
    int numItems = junk.Length
    if !count
        count = Utility.CreateIntArray(numItems, 0)
        baseValue = Utility.CreateIntArray(numItems, 0)
    else
        count = Utility.ResizeIntArray(count, numItems, 0)
        baseValue = Utility.ResizeIntArray(baseValue, numItems, 0)
    endIf
    while numItems
        numItems -= 1
        count[numItems] = GetActorReference().GetItemCount(junk[numItems])
        baseValue[numItems] = junk[numItems].GetGoldValue()
        Logger("Player has " + count[numItems] + " x " + junk[numItems] + " which has base value of " + baseValue[numItems])
    endWhile
    
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    int junkIndex = junk.Find(akBaseItem)
    if junkIndex > -1
        count[junkIndex] = (aiItemCount + count[junkIndex])
        Logger("Player has " + count[junkIndex] + " x " + junk[junkIndex])
    endIf
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    int junkIndex = junk.Find(akBaseItem)
    if junkIndex > -1
        int newNum = (count[junkIndex] - aiItemCount) 
        If (newNum > -1)
            count[junkIndex] = newNum
        else 
            count[junkIndex] = 0
        EndIf
        Logger("Player has " + count[junkIndex] + " x " + junk[junkIndex])
    endIf   
EndEvent


Function Logger(string textToLog = "", bool logFlag = true, int logType = 1)
    if logType == 1
        YHUtil.Log("PlayerRefScript - " + textToLog, logFlag)
    endIf
    If logType == 2
        YHUtil.AddLineBreakWithText("PlayerRefScript - " + textToLog, logFlag)
    EndIf
    If logType == 3
        YHUtil.AddLineBreakGameTimeOptional(logFlag)
    EndIf
EndFunction