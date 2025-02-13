Scriptname AddMerchantEffectScript extends activemagiceffect  
MerchantScript property MainScript auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    ;Hire/Fire Merchant
    MainScript.AddMerchant(akTarget)   
EndEvent