Scriptname MerchantStallActivationScript extends ObjectReference  



Event OnActivate(ObjectReference akActionRef)
    YHUtil.Log("In the activate script!!!")

    
    
    ; USE BELOW FOR CHANGING THE ACTIVATION TEXT DYNAMICALLY 


    ; prompt = "<font color='#808080'>" + prompt + "</font>"
    ; string label = UI.GetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.text")
    ; label = StringUtil.Substring(label, StringUtil.Find(label,StringUtil.AsChar(13)))
    ; UI.SetString("HUD Menu", "_root.HUDMovieBaseInstance.RolloverText.htmlText", prompt + label)
EndEvent