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

    endIf
endEvent