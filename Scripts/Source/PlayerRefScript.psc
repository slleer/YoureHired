Scriptname PlayerRefScript extends ReferenceAlias  
{To handle OnPlayerLoadGame Events}

QuestMaintenanceScript property QuestScript auto
FormList property JunkFilterFormList auto
Perk property Haggling auto
Perk property Allure auto
float hagglingVal = 0.0
float allureVal = 0.0
int hagglingRank = 0
int[] count
Form[] junk
int[] baseValue

Event OnInit()
    AddInventoryEventFilter(JunkFilterFormList)
    RegisterForModEvent("aaslrYH_JunkFilterEvent", "OnJunkFilterChange")
    RegisterForSingleUpdate(120.0)
EndEvent

Event OnPlayerLoadGame()
    RegisterForModEvent("aaslrYH_JunkFilterEvent", "OnJunkFilterChange")
    QuestScript.Maintenance()
EndEvent

Event OnUpdate()
    If (allureVal == 0.0 && GetActorReference().HasPerk(Allure))
        allureVal = 0.1
    EndIf
    if (hagglingRank < 5 && GetActorReference().HasPerk(Haggling))
        hagglingRank += 1
        if hagglingRank < 5
            Haggling = Haggling.GetNextPerk()
        endIf
        if hagglingRank == 1
            hagglingVal = 0.1
        Else
            hagglingVal += 0.05
        endIf
    endIf
    Logger("allureVal: " + allureVal + ", " + hagglingVal + ", haggling rank " + hagglingRank)
    if allureVal == 0.0 || hagglingRank < 5
        RegisterForSingleUpdate(120.0)
    endIf
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

State BusyState
    Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
        Logger("Item added busy state")
    EndEvent
    
    Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
        Logger("Item removed busy state")
    EndEvent
EndState


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


int Function GetSellCostOfJunk(bool hasAllure, ObjectReference merchantChest)
    GoToState("BusyState")
    Logger("Getting some values and returning a number")
    ActorValueInfo speechcraftMODAVID = ActorValueInfo.GetActorValueInfoById(107)
    Float speechValue = GetActorReference().GetActorValue("Speechcraft")
    float speechMODValue = speechcraftMODAVID.GetCurrentValue(GetActorReference())
    Logger("speachMODAVI: " + speechMODValue + ", speechValue: " + speechValue)
    
    int index = junk.length
    Logger("num items being filterd: " + index)
    float sum = 0
    int mult = 0
    float allureProxy 
    if hasAllure
        allureProxy = allureVal
    else
        allureProxy = 0.0
    endIf
    float sellFactor =  (3.3 - 1.3 * speechValue/100) / ((1 + hagglingVal) * (1 + allureProxy) * (1 + speechMODValue/100))
    while index 
        index -= 1
        int thisMany = count[index]
        count[index] = 0
        mult = thisMany * baseValue[index]
        Logger("Sell Factor: " + sellFactor)
        sum += (mult / sellFactor)
        Logger("count (" + thisMany + ") x base (" + baseValue[index] + ") = " + mult)
        Form thisJunk = junk[index]
        GetActorReference().RemoveItem(JunkFilterFormList, thisMany, true, merchantChest)

    endWhile
    GoToState("")
    return Math.Ceiling(sum) 
EndFunction