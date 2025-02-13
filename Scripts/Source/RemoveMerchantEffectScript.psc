Scriptname RemoveMerchantEffectScript extends activemagiceffect  
MerchantScript property MainScript auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    ;Hire/Fire Merchant
    MainScript.RemoveMerchant(akTarget)   
EndEvent