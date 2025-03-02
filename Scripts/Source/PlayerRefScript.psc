Scriptname PlayerRefScript extends ReferenceAlias  
{To handle OnPlayerLoadGame Events}

Import YHUtil

QuestMaintenanceScript property QuestScript auto
FormList property JunkFilterFormList auto
ObjectReference property BLANKCHEST auto
Perk property Haggling auto
Perk property Allure auto
float hagglingVal = 0.0
float allureVal = 0.0
int hagglingRank = 0
int[] aiCount
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
    Log(self + "allureVal: " + allureVal + ", " + hagglingVal + ", haggling rank " + hagglingRank)
    if allureVal == 0.0 || hagglingRank < 5
        RegisterForSingleUpdate(120.0)
    endIf
    GoToState("")
EndEvent



Event OnJunkFilterChange()
    junk = JunkFilterFormList.ToArray()
    int numItems = junk.Length
    if !aiCount
        aiCount = Utility.CreateIntArray(numItems, 0)
        baseValue = Utility.CreateIntArray(numItems, 0)
    elseIf numItems > 0
        aiCount = Utility.ResizeIntArray(aiCount, numItems, 0)
        baseValue = Utility.ResizeIntArray(baseValue, numItems, 0)
    else
        aiCount = NONE
        baseValue = NONE
    endIf
    
    while numItems
        numItems -= 1
        aiCount[numItems] = GetActorReference().GetItemCount(junk[numItems])
        baseValue[numItems] = junk[numItems].GetGoldValue()
    endWhile
    Log(self + "Finished updating junk filter")    
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    int junkIndex = junk.Find(akBaseItem)

    if junkIndex > -1
        aiCount[junkIndex] = (aiItemCount + aiCount[junkIndex])
        Log(self + "Player has " + aiCount[junkIndex] + " x " + junk[junkIndex])
    endIf

EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    int junkIndex = junk.Find(akBaseItem)

    if junkIndex > -1
        If (aiCount[junkIndex] < aiItemCount)
            aiCount[junkIndex] = 0
        else 
            aiCount[junkIndex] = (aiCount[junkIndex] - aiItemCount)
        EndIf
        Log(self + "Player has " + aiCount[junkIndex] + " x " + junk[junkIndex])
    endIf
EndEvent

State BusyState
    Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
        Log(self + "Item removed busy state")
    EndEvent
EndState



int Function GetSellCostOfJunk(bool hasAllure, ObjectReference merchantChest)
    GoToState("BusyState")
    Log(self + "Getting some values and returning a number")
    ActorValueInfo speechcraftMODAVID = ActorValueInfo.GetActorValueInfoById(107)
    Float speechValue = GetActorReference().GetActorValue("Speechcraft")
    float speechMODValue = speechcraftMODAVID.GetCurrentValue(GetActorReference())
    Log(self + "speachMODAVI: " + speechMODValue + ", speechValue: " + speechValue)
    
    int index = junk.length
    Log(self + "num items being filterd: " + index) 
    float sum = 0
    int mult = 0
    int maxCount = 0
    float allureProxy 
    if hasAllure
        allureProxy = allureVal
    else
        allureProxy = 0.0
    endIf
    float sellFactor =  (3.3 - 1.3 * speechValue/100) / ((1 + hagglingVal) * (1 + allureProxy) * (1 + speechMODValue/100))
    Log(self + "Current Time array loop: " + Utility.GetCurrentRealTime())
    while index
        index -= 1
        if maxCount < aiCount[index]
            maxCount = aiCount[index]
        endIf
        mult = aiCount[index] * baseValue[index]
        aiCount[index] = 0
        sum += (mult / sellFactor)
    endWhile
    if JunkFilterFormList.GetSize()
        GetActorReference().RemoveItem(JunkFilterFormList, maxCount, true, merchantChest)
    endIf
    Log(self + "Current Time array loop for " + maxCount + " items, (" + sum + ") after: " + Utility.GetCurrentRealTime())
    RegisterForSingleUpdate(5.0)
    return Math.Ceiling(sum) 
EndFunction

