Scriptname YoureHiredSetUpStandEffectScript extends ActiveMagicEffect  
{Used for placing a merchant stand. TEST}

YoureHiredMerchantPropertiesScript property FixedProperties auto
ReferenceAlias property thisMerchant auto
ObjectReference property xmarker auto
Furniture property StallIdleFurniture auto
Furniture property ChildStallIdleFurniture auto
Static property MarketStallStaic auto
Activator property StallManagementActivator auto
Activator property ChildStallManagementActivator auto
GlobalVariable property Merchant_01_PackageEnable auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    YHUtil.Log("We are in the effect start")
    if akCaster == Game.GetPlayer()
        if Merchant_01_PackageEnable.GetValueInt() == 0
            xmarker.MoveTo(akCaster)
            xmarker.SetAngle(0.0,0.0,xmarker.GetAngleZ())
            YHUtil.Log("Moved the xmarker")
            float x = (FixedProperties.MerchantStand.GetLength() * Math.Sin(akCaster.GetAngleZ()))
            float y = (FixedProperties.MerchantStand.GetLength() * Math.Cos(akCaster.GetAngleZ()))
            YHUtil.Log("X:" + x + ", Y:" + y)
            YHUtil.Log("Length: " + FixedProperties.MerchantStand.GetLength())
            YHUtil.Log("Width: " + FixedProperties.MerchantStand.GetWidth())
            if FixedProperties.CounterLeanIdleRef
                YHUtil.Log("Getting rid of old idle markers")
                FixedProperties.CounterLeanIdleRef.Disable()
                FixedProperties.CounterLeanIdleRef.Delete()
            endIf
            If FixedProperties.MerchantStand
                YHUtil.Log("getting rid of old mechant stall")
                FixedProperties.MerchantStand.Disable()
                FixedProperties.MerchantStand.Delete()
            EndIf
            
            ; Set the marker and place the counterLeanIdle
            xmarker.MoveTo(akCaster, x, y, -5.0, false)
            Furniture stallToUse
            If thisMerchant.GetActorReference().IsChild()
               stallToUse = ChildStallIdleFurniture
            Else
                stallToUse = StallIdleFurniture
            EndIf

            ObjectReference newStall = xmarker.PlaceAtMe(StallIdleFurniture, 1, true, false)
            FixedProperties.CounterLeanIdleRef = newStall
            newStall.SetAngle(0,0,newStall.GetAngleZ())
            YHUtil.Log("Idle Length: " + newStall.GetLength())
            YHUtil.Log("Idle Width: " + newStall.GetWidth())
            ; Check to make sure counterLeanIdel is not none and update global
            If (newStall)
                YHUtil.Log("The newIdleMarker = " + newStall)
                Merchant_01_PackageEnable.SetValueInt(1)
                Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal(Merchant_01_PackageEnable)
                YHUtil.Log("The global is: " + Merchant_01_PackageEnable.GetValueInt())
            EndIf
            ; Set the marker and place the merchant stand
            
            float x2 = (newStall.GetLength() * Math.Sin(akCaster.GetAngleZ()))
            float y2 = (newStall.GetLength() * Math.Cos(akCaster.GetAngleZ()))
            float diffX = (x2 - x) / 2
            float diffY = (y2 - y) / 2
            xmarker.MoveTo(akCaster, (FixedProperties.MerchantStand.GetLength() + diffX) * Math.Sin(akCaster.GetAngleZ()), (FixedProperties.MerchantStand.GetLength() + diffY) * Math.Cos(akCaster.GetAngleZ()), - 5.0, false)
            ObjectReference newActivator = xmarker.PlaceAtMe(StallManagementActivator, 1, true, false)
            FixedProperties.MerchantStand = newActivator
            newActivator.SetAngle(0,0,newActivator.GetAngleZ())
            xmarker.MoveTo(akCaster, abMatchRotation = false)
            YHUtil.Log("The stand location is X:" + newActivator.GetPositionX() + ", Y:" + newActivator.GetPositionY() + ", Z:" + newActivator.GetPositionZ())
            
            if thisMerchant.GetActorReference()
                YHUtil.Log("ThisMerchant" + (thisMerchant as BusinessScript).GetActorName() + ", " + (thisMerchant as BusinessScript).GetChestType())
                YHUtil.Log("Checking the actor's packages: " + thisMerchant.GetActorReference().GetCurrentPackage())
                ; bool packageEvaluated = thisMerchant.TryToEvaluatePackage()
                ; YHUtil.Log("Package evaluation: " + packageEvaluated)
                YHUtil.Log("Checking the actor's packages: " + thisMerchant.GetActorReference().GetCurrentPackage())
            endIf
        Else
            Merchant_01_PackageEnable.SetValueInt(0)
            Quest.GetQuest("aaslrYoureHiredMainQuest").UpdateCurrentInstanceGlobal(Merchant_01_PackageEnable)
        endIf
    endIf
endEvent