Scriptname MerchantStandPlacementThread extends Quest Hidden 
{This is the base for the merchant stand placement threads}

ObjectReference future
bool thread_queued = false
bool isChild = false

; main parts
Activator stallActivator
Furniture merchantStallFurniture
Furniture childChairFurniture

static theMarker
; stand refs for getting length, needed for placing the activator correctly
ObjectReference merchantStallRef
; map marker
ObjectReference mapMarker
; idle marekers
ObjectReference browseIdle

ObjectReference sweepIdle
ObjectReference childPlayDirtIdle

ObjectReference wipeBrowIdle

ObjectReference writeLedgerIdle
ObjectReference readBookIdle


ObjectReference Function get_async(Activator akFuture, ObjectReference akAnchor, static xmarker, ObjectReference idleMarker)
    
EndFunction

;Allows the Thread Manager to determine if this thread is available
bool function queued()
	return thread_queued
endFunction

;For Thread Manager troubleshooting.
bool function has_future(ObjectReference akFuture)
    if akFuture == future
        return true
    else
        return false
    endif
endFunction

;For Thread Manager troubleshooting.
bool function force_unlock()
    clear_thread_vars()
    thread_queued = false
    return true
endFunction


;Another function that does things we want to multithread.
function MoveGuardMarkerNearPlayer(ObjectReference akMarker)
	;Expensive SetPosition, GetPosition, FindNearestRef, etc calls here (illustration only)
endFunction

function clear_thread_vars()
	;Reset all thread variables to default state
    merchantStallFurniture = NONE
    stallActivator = NONE
    childChairFurniture = NONE
    theMarker = NONE
    merchantStallRef = NONE
    mapMarker = NONE
    browseIdle = NONE
    sweepIdle = NONE
    wipeBrowIdle = NONE
    writeLedgerIdle = NONE
    readBookIdle = NONE
    childPlayDirtIdle = NONE
    isChild = false
endFunction