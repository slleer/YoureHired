Scriptname YHUtil
;Logs to Debug Trace.
Function Log(string txt, bool trace = true) global
    ;My logger fucntion
    Debug.TraceConditional("[You're Hired!] : " + txt, trace)
EndFunction

Function AddLineBreakGameTimeOptional(bool useTimeBreak = true) global
    string txt = "*****************"
    if useTimeBreak
        txt +=  Utility.GameTimeToString(Utility.GetCurrentGameTime())
    endIf
    txt += "*****************"
    Debug.Trace("[You're Hired!] : " + txt)
EndFunction

Function AddLineBreakWithText(string txt, bool trace = true) global
    txt = "***************** " + txt + " *****************"
    Debug.TraceConditional("[You're Hired!] : " + txt, trace)
EndFunction