Scriptname ResetOnActivate extends ObjectReference  

Import YHUtil

Event OnActivate(ObjectReference akActionRef)
    Log(self + " We are about to reset the test chest!")
    self.Reset()
    Log(self + " We just reset the test chset")
EndEvent