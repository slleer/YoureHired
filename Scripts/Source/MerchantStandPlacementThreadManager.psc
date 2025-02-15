Scriptname MerchantStandPlacementThreadManager extends Quest  

Quest property YoureHired auto
Actor property PlayerRef auto
Furniture property merchantStallFurniture auto
Furniture property ChildMerchantStallFurniture auto
; Furniture property ChildChairFurniture auto
ObjectReference property MerchantStandRef auto
ObjectReference property ChildMerchantStandRef auto

Static property XMarker auto

Furniture stallFurniture
ObjectReference stallRef

MerchantStandPlacementThread01 property thread01 auto
MerchantStandPlacementThread02 property thread02 auto
MerchantStandPlacementThread03 property thread03 auto
MerchantStandPlacementThread04 property thread04 auto
MerchantStandPlacementThread05 property thread05 auto
MerchantStandPlacementThread06 property thread06 auto
MerchantStandPlacementThread07 property thread07 auto

Event OnInit()
    thread01 = (YoureHired as MerchantStandPlacementThread01)
    thread02 = (YoureHired as MerchantStandPlacementThread02)
    thread03 = (YoureHired as MerchantStandPlacementThread03)
    thread04 = (YoureHired as MerchantStandPlacementThread04)
    thread05 = (YoureHired as MerchantStandPlacementThread05)
    thread06 = (YoureHired as MerchantStandPlacementThread06)
    thread07 = (YoureHired as MerchantStandPlacementThread07)
    stallFurniture = merchantStallFurniture
    stallRef = MerchantStandRef
EndEvent

Function ListenForModEvents()
    thread01.ListenForModEvents()
    thread02.ListenForModEvents()
    thread03.ListenForModEvents()
    thread04.ListenForModEvents()
    thread05.ListenForModEvents()
    thread06.ListenForModEvents()
    thread07.ListenForModEvents()
EndFunction

Function PlaceStallAsync(ObjectReference theActivator, bool isChild)
    if isChild
        stallFurniture = ChildMerchantStallFurniture
    endIf
    if !thread01.queued()
        thread01.get_async_stall(stallFurniture, theActivator)
    elseif !thread02.queued()
        thread02.get_async_stall(stallFurniture, theActivator)
    elseif !thread03.queued()
        thread03.get_async_stall(stallFurniture, theActivator)
    elseif !thread04.queued()
        thread04.get_async_stall(stallFurniture, theActivator)
    elseif !thread05.queued()
        thread05.get_async_stall(stallFurniture, theActivator)
    elseif !thread06.queued()
        thread06.get_async_stall(stallFurniture, theActivator)
    elseif !thread07.queued()
        thread07.get_async_stall(stallFurniture, theActivator)
    else
        wait_all()
        PlaceStallAsync(theActivator, isChild)
    endIf
EndFunction

; Function PlaceChairAsync()
;     if !thread01.queued()
;         thread01.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread02.queued()
;         thread02.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread03.queued()
;         thread03.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread04.queued()
;         thread04.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread05.queued()
;         thread05.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread06.queued()
;         thread06.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     elseif !thread07.queued()
;         thread07.get_async_chair(ChildChairFurniture, XMarker, PlayerRef)
;     else
;         wait_all()
;         PlaceChairAsync()
;     endIf
; EndFunction

Function PlaceMapMarkerAsync(ObjectReference mapMarker, bool isChild)
    if isChild
        stallRef = ChildMerchantStandRef
    endIf
    if !thread01.queued()
        thread01.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread02.queued()
        thread02.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread03.queued()
        thread03.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread04.queued()
        thread04.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread05.queued()
        thread05.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread06.queued()
        thread06.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    elseif !thread07.queued()
        thread07.get_async_mapMarker(mapMarker, XMarker, PlayerRef, stallRef)
    else
        wait_all()
        PlaceMapMarkerAsync(mapMarker, isChild)
    endIf
EndFunction

Function PlaceIdleMarkerAsync(ObjectReference idleMarker, float distance, float angle, float rotation, bool useStallWidth, bool invert)
    ObjectReference tempStallRef = NONE
    If useStallWidth
        tempStallRef = stallRef
    EndIf
    if !thread01.queued()
        thread01.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread02.queued()
        thread02.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread03.queued()
        thread03.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread04.queued()
        thread04.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread05.queued()
        thread05.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread06.queued()
        thread06.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    elseif !thread07.queued()
        thread07.get_async_Idle(idleMarker, XMarker, PlayerRef, distance, angle, rotation, tempStallRef, invert)
    else
        wait_all()
        PlaceIdleMarkerAsync(idleMarker, distance, angle, rotation, useStallWidth, invert)
    endIf
EndFunction

function wait_all()
    stallFurniture = merchantStallFurniture
    stallRef = MerchantStandRef
    RaiseEvent_OnPlaceStallObj()
    begin_waiting()
endFunction

function begin_waiting()
    bool waiting = true
    int i = 0
    while waiting
        if thread01.queued() || thread02.queued() || thread03.queued() || thread04.queued() || thread05.queued() || \
           thread06.queued() || thread07.queued() 
            i += 1
            Utility.WaitMenuMode(0.02)
            if i >= 100
                debug.trace("Error: A catastrophic error has occurred. All threads have become unresponsive. Please debug this issue or notify the author.")
                i = 0
                ;Fail by returning None. The mod needs to be fixed.
                return
            endif
        else
            waiting = false
        endif
    endWhile
endFunction

;Create the ModEvent that will start this thread
function RaiseEvent_OnPlaceStallObj()
    int handle = ModEvent.Create("aaslrYH_PlaceStallObjects")
    if handle
        ModEvent.Send(handle)
    else
        ;pass
    endif
endFunction