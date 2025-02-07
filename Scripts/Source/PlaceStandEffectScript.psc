Scriptname PlaceStandEffectScript extends ActiveMagicEffect  

YoureHiredMerchantPropertiesScript property FixedMerchantProperties auto

Activator property MerchantStandActivator auto
Furniture property MerchantStandFurniture auto
ObjectReference property xmarker auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    If (akCaster == Game.GetPlayer())
        YHUtil.Log("We are in effect event")
        ; xmarker.MoveTo(akCaster)
        ; xmarker.SetAngle(0.0,0.0,xmarker.GetAngleZ())
        ; YHUtil.Log("Moved the xmarker")

        ; xmarker.MoveTo(akCaster, FixedMerchantProperties.MerchantStand.GetLength() * Math.Sin(akCaster.GetAngleZ()), FixedMerchantProperties.MerchantStand.GetLength() * Math.Cos(akCaster.GetAngleZ()), - 5.0, false)
        ; ; ObjectReference newStand = xmarker.PlaceAtMe(FixedMerchantProperties.MrkMarketStall01, 1, true, false)
        ; ; YHUtil.Log("Here's the navcut stand: " + newStand)
        ; ObjectReference newFurniture = xmarker.PlaceAtMe(MerchantStandFurniture, 1, true, false)
        ; YHUtil.Log("Here's the navcut furniture: " + newFurniture)
        ; ObjectReference newActivator = xmarker.PlaceAtMe(MerchantStandActivator, 1, true, false)
        ; YHUtil.Log("Here's the activator: " + newActivator)       
        

    EndIf
EndEvent