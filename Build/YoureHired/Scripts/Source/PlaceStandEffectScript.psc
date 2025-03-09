Scriptname PlaceStandEffectScript extends ActiveMagicEffect  

YoureHiredMerchantPropertiesScript property FixedProperties auto

Activator property MerchantStandActivator auto
Furniture property MerchantStandFurniture auto
ObjectReference property xmarker auto
ObjectReference property mapMarker01 auto
ObjectReference property MerchantStandRef auto
ObjectReference property WriteLedgerIdle auto
ObjectReference property BrowseIdle auto
ObjectReference property SweepIdle auto
ObjectReference property WipeBrowIdle auto


Event OnEffectStart(Actor akTarget, Actor akCaster)

    Form[] containerForms = Game.GetPlayer().GetContainerForms()
    int index = containerForms.Length
    ObjectReference asObj
    Form asForm
    YHUtil.Log("We are about to start the loop")

    YHUtil.Log("We are out of the loop")
    
    
EndEvent