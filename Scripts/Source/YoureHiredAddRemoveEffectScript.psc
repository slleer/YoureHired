Scriptname YoureHiredAddRemoveEffectScript extends activemagiceffect  
{Allows player to add or remove Actor to Merchant system using spell}
MerchantScript property MainScript auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    ;Hire/Fire Merchant
    MainScript.HandleMerchant(akTarget)   
EndEvent