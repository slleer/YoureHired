Scriptname MerchantStandPlacementThread extends Quest Hidden 
{This is the base for the merchant stand placement threads}

Import YHUtil

bool thread_queued = false

; main parts
Furniture merchantStallFurniture
Furniture childChairFurniture

Actor PlayerRef



static theMarker
; stand refs for getting length, needed for placing the activator correctly
ObjectReference merchantStallRef
ObjectReference theActivator
; map marker
ObjectReference mapMarker
; idle marekers
ObjectReference idleMarker

float offsetDistance
float offsetAngle
float offsetRotaion
bool invertCardinality

Event OnInit()
    Log(self + "We are in the thread on init")
    RegisterForModEvent("aaslrYH_PlaceStallObjects", "OnPlaceStallObj")
EndEvent

Function ListenForModEvents()
    RegisterForModEvent("aaslrYH_PlaceStallObjects", "OnPlaceStallObj")
EndFunction

Function get_async_stall(Furniture stall, ObjectReference activatorRef)
    Log(self + "In the getasync stall")
    thread_queued = true
    merchantStallFurniture = stall
    theActivator = activatorRef
    GoToState("StallState")
EndFunction

; Function get_async_chair(Furniture chair, static xmarker, Actor player)
;     Log(self + "In the getasync chair")
;     thread_queued = true
;     childChairFurniture = chair
;     theMarker = xmarker
;     PlayerRef = player
;     GoToState("ChairState")
; EndFunction

Function get_async_mapMarker(ObjectReference map, static xmarker, Actor player, ObjectReference stallRef)
    Log(self + "In the getasync mapMarker")
    thread_queued = true
    merchantStallRef = stallRef
    mapMarker = map
    theMarker = xmarker
    PlayerRef = player
    GoToState("MapMarkerState")
EndFunction

Function get_async_Idle(ObjectReference idleRef, static xmarker, Actor player, float distance, float angle, float rotation, ObjectReference stallRef = NONE, bool invert = false)
    Log(self + "In the getasync idle")
    thread_queued = true
    idleMarker = idleRef
    theMarker = xmarker
    PlayerRef = player
    merchantStallRef = stallRef
    offsetDistance = distance
    offsetAngle = angle
    offsetRotaion = rotation
    invertCardinality = invert
    GoToState("IdleState")
EndFunction

;Allows the Thread Manager to determine if this thread is available
bool function queued()
	return thread_queued
endFunction

;For Thread Manager troubleshooting.
bool function force_unlock()
    clear_thread_vars()
    thread_queued = false
    return true
endFunction

; empty state 
Event OnPlaceStallObj()
EndEvent

State StallState
    Event OnPlaceStallObj()
        Log(self + "In the OnPlaceStallObj Event")
        
        ObjectReference resultObj = theActivator.PlaceAtMe(merchantStallFurniture, 1, true, true)
        resultObj.SetAngle(0,0,resultObj.GetAngleZ())
        RaiseEvent_StallObjCallBack(resultObj)
        clear_thread_vars()
        thread_queued = false
        GoToState("")
    EndEvent
EndState

; State ChairState
;     Event OnPlaceStallObj()
;         Log(self + "In the OnPlaceChairObj Event")
;         ObjectReference tempRef = PlayerRef.PlaceAtMe(theMarker, 1)
;         tempRef.SetAngle(0,0,(tempRef.GetAngleZ() + 145))
;         tempRef.MoveTo(tempRef, 40 * Math.Sin(tempRef.GetAngleZ()), 40 * Math.Cos(tempRef.GetAngleZ()), 0, false)
;         ObjectReference resultObj = tempRef.PlaceAtMe(childChairFurniture, 1, true, false)
;         resultObj.SetAngle(0,0,(resultObj.GetAngleZ() - 180))
;         RaiseEvent_StallObjCallBack(resultObj)
        
;         tempRef.Disable()
;         tempRef.Delete()

;         clear_thread_vars()
;         thread_queued = false
;         GoToState("")
;     EndEvent
; EndState

State MapMarkerState
    Event OnPlaceStallObj()
        Log(self + "In the OnPlaceMapMarkerObj Event")
        
        ObjectReference tempRef = PlayerRef.PlaceAtMe(theMarker, 1)
        
        mapMarker.MoveTo(tempRef, (125 + merchantStallRef.GetWidth()) * Math.Sin(tempRef.GetAngleZ()), (125 + merchantStallRef.GetWidth()) * Math.Cos(tempRef.GetAngleZ()), 40.0, true)
        mapMarker.SetAngle(0.0,0.0, (tempRef.GetAngleZ() - 180))
        mapMarker.Enable()
        If (!tempRef.GetParentCell().IsInterior())
            mapMarker.AddToMap()
            mapMarker.EnableFastTravel()
            Log(self + "Map Marker has been placed!!")
        EndIf
        tempRef.Disable()
        tempRef.Delete()

        clear_thread_vars()
        thread_queued = false
        GoToState("")
    EndEvent
EndState

State IdleState
    Event OnPlaceStallObj()
        Log(self + "In the OnPlaceIdleObj Event")
        ObjectReference tempRef = PlayerRef.PlaceAtMe(theMarker, 1)
        tempRef.SetAngle(0.0, 0.0, PlayerRef.GetAngleZ())
        Log(self + "distance: " + offsetDistance + ", angle: " + offsetAngle + ", rotation: " + offsetRotaion)
        if merchantStallRef
            offsetDistance += merchantStallRef.GetWidth()
        endIf

        float x
        float y
        
        if offsetAngle != 0
            tempRef.SetAngle(0.0,0.0, (tempRef.GetAngleZ() + offsetAngle))
        endIf
        if invertCardinality
            x = Math.Cos(tempRef.GetAngleZ())
            y = Math.Sin(tempRef.GetAngleZ())
        else
            x = Math.Sin(tempRef.GetAngleZ())
            y = Math.Cos(tempRef.GetAngleZ())
        endIf
        tempRef.MoveTo(tempRef, offsetDistance * x, offsetDistance * y, 40.0, true)
        ObjectReference resultObj = tempRef.PlaceAtMe(idleMarker.GetBaseObject(), 1, true, false)
        
        if offsetRotaion != 0
            resultObj.SetAngle(0.0,0.0, resultObj.GetAngleZ() + offsetRotaion)
        endIf

        RaiseEvent_StallObjCallBack(resultObj)
        
        tempRef.Disable()
        tempRef.Delete()
        
        clear_thread_vars()
        thread_queued = false
        GoToState("")
    EndEvent
EndState

function clear_thread_vars()
	;Reset all thread variables to default state
    merchantStallFurniture = NONE
    PlayerRef = NONE
    childChairFurniture = NONE
    theMarker = NONE
    merchantStallRef = NONE
    mapMarker = NONE
    idleMarker = NONE
    theActivator = NONE
    offsetDistance = 0.0
    offsetAngle = 0.0
    offsetRotaion = 0.0
    invertCardinality = false
endFunction

function RaiseEvent_StallObjCallBack(ObjectReference stallObj)
    int handle = ModEvent.Create("aaslrYH_CollectStallObjects")
    if handle
        ModEvent.PushForm(handle, stallObj)
        ModEvent.Send(handle)
    else
        RetryRaiseEvent(stallObj)
    endIf
EndFunction

Function RetryRaiseEvent(ObjectReference stallObj)
    int anotherHandle = ModEvent.Create("aaslrYH_CollectStallObjects")
    if anotherHandle
        ModEvent.PushForm(anotherHandle, stallObj)
        ModEvent.Send(anotherHandle)
    else
        Log(self + "We had to delete the placed object after retry: " + GetState())
        stallObj.Disable()
        stallObj.Delete()
    endIf
EndFunction

