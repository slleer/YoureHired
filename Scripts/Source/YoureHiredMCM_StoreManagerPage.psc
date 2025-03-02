Scriptname YoureHiredMCM_StoreManagerPage  Hidden 
{Manages the stores/chest types and their setttins}

Import YHUtil

string Function GetPageName() global
    ; return "Store Manager"
    return "Merchant Inventory"
EndFunction

Function RenderPage(YoureHiredMCM mcm, string page) global
    If (page == GetPageName())
        mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
        LEFT(mcm)
        mcm.SetCursorPosition(1)
        RIGHT(mcm)
    EndIf
EndFunction

Function LEFT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Blacksmith - Leveled Lists")
    mcm.oid_Inventory_Mace_LVLL =  mcm.AddToggleOption("Maces", mcm.I_MaceLevelList)
    mcm.oid_Inventory_Sword_LVLL = mcm.AddToggleOption("Swords", mcm.I_SwordLevelList)
    mcm.oid_Inventory_Waraxe_LVLL = mcm.AddToggleOption("War Axes", mcm.I_WarAxeLevelList)
    mcm.oid_Inventory_Warhammer_LVLL = mcm.AddToggleOption("Warhammers", mcm.I_WarHammerLevelList)
    mcm.oid_Inventory_Greatsword_LVLL = mcm.AddToggleOption("Greatswords", mcm.I_GreatSwordLevelList)
    mcm.oid_Inventory_Battleaxe_LVLL = mcm.AddToggleOption("Battleaxes", mcm.I_BattleAxeLevelList)
    mcm.oid_Inventory_Dagger_LVLL = mcm.AddToggleOption("Daggers", mcm.I_DaggerLevelList)
    mcm.oid_Inventory_Bow_LVLL = mcm.AddToggleOption("Bows", mcm.I_BowLevelList)
    mcm.oid_Inventory_Crossbow_LVLL = mcm.AddToggleOption("Crossbows", mcm.I_CrossbowLevelList)
    mcm.oid_Inventory_HeavyArmor_LVLL = mcm.AddToggleOption("Heavy Armor", mcm.I_HeavyArmorLevelList)
    mcm.oid_Inventory_HeavyShields_LVLL = mcm.AddToggleOption("Heavy Shields", mcm.I_HeavyShieldsLevelList)
    mcm.oid_Inventory_LightArmor_LVLL = mcm.AddToggleOption("Light Armor", mcm.I_LightArmorLevelList)
    mcm.oid_Inventory_LightShields_LVLL = mcm.AddToggleOption("Light Shields", mcm.I_LightShieldsLevelList)
    mcm.AddHeaderOption("Spell Vendor - Leveled Lists")
    mcm.oid_Inventory_AlterationSpellTomes_LVLL = mcm.AddToggleOption("Alteration Spell Tomes", mcm.I_AlterationSpellTomesLevelList)
    mcm.oid_Inventory_AlterationRobes_LVLL = mcm.AddToggleOption("Alteration Robes", mcm.I_AlterationRobesLevelList)
    mcm.oid_Inventory_AlterationStaves_LVLL = mcm.AddToggleOption("Alteration Staves", mcm.I_AlterationStavesLevelList)
    mcm.oid_Inventory_ConjurationSpellTomes_LVLL = mcm.AddToggleOption("Conjuration Spell Tomes", mcm.I_ConjurationSpellTomesLevelList)
    mcm.oid_Inventory_ConjurationRobes_LVLL = mcm.AddToggleOption("Conjuration Robes", mcm.I_ConjurationRobesLevelList)
    mcm.oid_Inventory_ConjurationStaves_LVLL = mcm.AddToggleOption("Conjuration Staves", mcm.I_ConjurationStavesLevelList)
    mcm.oid_Inventory_DestructionSpellTomes_LVLL = mcm.AddToggleOption("Destruction Spell Tomes", mcm.I_DestructionSpellTomesLevelList)
    mcm.oid_Inventory_DestructionRobes_LVLL = mcm.AddToggleOption("Destruction Robes", mcm.I_DestructionRobesLevelList)
    mcm.oid_Inventory_DestructionStaves_LVLL = mcm.AddToggleOption("Destruction Staves", mcm.I_DestructionStavesLevelList)
    mcm.oid_Inventory_IllusionSpellTomes_LVLL = mcm.AddToggleOption("Illusion Spell Tomes", mcm.I_IllusionSpellTomesLevelList)
    mcm.oid_Inventory_IllusionRobes_LVLL = mcm.AddToggleOption("Illusion Robes", mcm.I_IllusionRobesLevelList)
    mcm.oid_Inventory_IllusionStaves_LVLL = mcm.AddToggleOption("Illusion Staves", mcm.I_IllusionStavesLevelList)
    mcm.oid_Inventory_RestorationSpellTomes_LVLL = mcm.AddToggleOption("RestorationSpell Tomes", mcm.I_RestorationSpellTomesLevelList)
    mcm.oid_Inventory_RestorationRobes_LVLL = mcm.AddToggleOption("Restoration Robes", mcm.I_RestorationRobesLevelList)
    mcm.oid_Inventory_RestorationStaves_LVLL = mcm.AddToggleOption("Restoration Staves", mcm.I_RestorationStavesLevelList)
    mcm.AddHeaderOption("Apothecary - Leveled Lists")
    mcm.oid_Inventory_RestorAll_LVLL = mcm.AddToggleOption("Potion of Well Being", mcm.I_RestorAllLevelList)
    mcm.AddEmptyOption()
    mcm.AddHeaderOption("Spell Vendor - Other")
    mcm.oid_Inventory_SoulGemsEmptyEach = mcm.AddToggleOption("10x Each Soul Gem (Empty)", mcm.I_SoulGemsEmptyEach)
    mcm.oid_Inventory_SoulGemsFilledEach = mcm.AddToggleOption("10x Each Soul Gem (Filled)", mcm.I_SoulGemsFilledEach)
    mcm.oid_Inventory_EnchantmentsEach = mcm.AddToggleOption("1x Each Enchantment", mcm.I_EnchantmentsEach)
    mcm.AddHeaderOption("Apothecary - Other")
    mcm.oid_Inventory_BloodPotionEach = mcm.AddToggleOption("15x Blood Potions", mcm.I_BloodPotionEach)
    mcm.oid_Inventory_IngredientsEach = mcm.AddToggleOption("10x Each Ingredient", mcm.I_IngredientsEach)
EndFunction

Function RIGHT(YoureHiredMCM mcm) global
    mcm.AddHeaderOption("Blacksmith - Full Collection")
    mcm.oid_Inventory_Mace_AAO =  mcm.AddToggleOption("Maces", mcm.I_MaceAllAtOnce)
    mcm.oid_Inventory_Sword_AAO = mcm.AddToggleOption("Swords", mcm.I_SwordAllAtOnce)
    mcm.oid_Inventory_Waraxe_AAO = mcm.AddToggleOption("War Axes", mcm.I_WarAxeAllAtOnce)
    mcm.oid_Inventory_Warhammer_AAO = mcm.AddToggleOption("Warhammers", mcm.I_WarHammerAllAtOnce)
    mcm.oid_Inventory_Greatsword_AAO = mcm.AddToggleOption("Greatswords", mcm.I_GreatSwordAllAtOnce)
    mcm.oid_Inventory_Battleaxe_AAO = mcm.AddToggleOption("Battleaxes", mcm.I_BattleAxeAllAtOnce)
    mcm.oid_Inventory_Dagger_AAO = mcm.AddToggleOption("Daggers", mcm.I_DaggerAllAtOnce)
    mcm.oid_Inventory_Bow_AAO = mcm.AddToggleOption("Bows", mcm.I_BowAllAtOnce)
    mcm.oid_Inventory_Crossbow_AAO = mcm.AddToggleOption("Crossbows", mcm.I_CrossbowAllAtOnce)
    mcm.oid_Inventory_HeavyArmor_AAO = mcm.AddToggleOption("Heavy Armor", mcm.I_HeavyArmorAllAtOnce)
    mcm.oid_Inventory_HeavyShields_AAO = mcm.AddToggleOption("Heavy Shields", mcm.I_HeavyShieldsAllAtOnce)
    mcm.oid_Inventory_LightArmor_AAO = mcm.AddToggleOption("Light Armor", mcm.I_LightArmorAllAtOnce)
    mcm.oid_Inventory_LightShields_AAO = mcm.AddToggleOption("Light Shields", mcm.I_LightShieldsAllAtOnce)
    mcm.AddHeaderOption("Spell Vendor - Full Collection")
    mcm.oid_Inventory_AlterationSpellTomes_AAO = mcm.AddToggleOption("Alteration Spell Tomes", mcm.I_AlterationSpellTomesAllAtOnce)
    mcm.oid_Inventory_AlterationRobes_AAO = mcm.AddToggleOption("Alteration Robes", mcm.I_AlterationRobesAllAtOnce)
    mcm.oid_Inventory_AlterationStaves_AAO = mcm.AddToggleOption("Alteration Staves", mcm.I_AlterationStavesAllAtOnce)
    mcm.oid_Inventory_ConjurationSpellTomes_AAO = mcm.AddToggleOption("Conjuration Spell Tomes", mcm.I_ConjurationSpellTomesAllAtOnce)
    mcm.oid_Inventory_ConjurationRobes_AAO = mcm.AddToggleOption("Conjuration Robes", mcm.I_ConjurationRobesAllAtOnce)
    mcm.oid_Inventory_ConjurationStaves_AAO = mcm.AddToggleOption("Conjuration Staves", mcm.I_ConjurationStavesAllAtOnce)
    mcm.oid_Inventory_DestructionSpellTomes_AAO = mcm.AddToggleOption("Destruction Spell Tomes", mcm.I_DestructionSpellTomesAllAtOnce)
    mcm.oid_Inventory_DestructionRobes_AAO = mcm.AddToggleOption("Destruction Robes", mcm.I_DestructionRobesAllAtOnce)
    mcm.oid_Inventory_DestructionStaves_AAO = mcm.AddToggleOption("Destruction Staves", mcm.I_DestructionStavesAllAtOnce)
    mcm.oid_Inventory_IllusionSpellTomes_AAO = mcm.AddToggleOption("Illusion Spell Tomes", mcm.I_IllusionSpellTomesAllAtOnce)
    mcm.oid_Inventory_IllusionRobes_AAO = mcm.AddToggleOption("Illusion Robes", mcm.I_IllusionRobesAllAtOnce)
    mcm.oid_Inventory_IllusionStaves_AAO = mcm.AddToggleOption("Illusion Staves", mcm.I_IllusionStavesAllAtOnce)
    mcm.oid_Inventory_RestorationSpellTomes_AAO = mcm.AddToggleOption("Restoration Spell Tomes", mcm.I_RestorationSpellTomesAllAtOnce)
    mcm.oid_Inventory_RestorationRobes_AAO = mcm.AddToggleOption("Restoration Robes", mcm.I_RestorationRobesAllAtOnce)
    mcm.oid_Inventory_RestorationStaves_AAO = mcm.AddToggleOption("Restoration Staves", mcm.I_RestorationStavesAllAtOnce)
    mcm.AddHeaderOption("Apothecary - Full Collection")
    mcm.oid_Inventory_RestorAll_AAO = mcm.AddToggleOption("Potion of Well Being", mcm.I_RestorAllAllAtOnce)
    mcm.AddEmptyOption()
    mcm.AddHeaderOption("Blacksmith - Other")
    mcm.oid_Inventory_ArrowsEach = mcm.AddToggleOption("50x Each Arrow", mcm.I_ArrowsEach)
    mcm.oid_Inventory_BoltsEach = mcm.AddToggleOption("50/20x Each Bolt", mcm.I_BoltsEach)
    mcm.oid_Inventory_IngotsEach = mcm.AddToggleOption("20x Each Ingot", mcm.I_IngotsEach)
    mcm.oid_Inventory_OresEach = mcm.AddToggleOption("20x Each Ore", mcm.I_OresEach)
    mcm.AddHeaderOption("DLC Items")
    mcm.oid_Inventory_DawnguardDLC01 = mcm.AddToggleOption("Dawnguard Items", mcm.I_DawnguardDLC01)
    mcm.oid_Inventory_DragonbornDLC2 = mcm.AddToggleOption("Dragonborn Items", mcm.I_DragonbornDLC2)
EndFunction


Function OnSelect(YoureHiredMCM mcm, int optionId) global
        ;       COllection as LeveledList
    If (optionId == mcm.oid_Inventory_Mace_LVLL)
        mcm.I_MaceLevelList = !mcm.I_MaceLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_MaceLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Sword_LVLL)
        mcm.I_SwordLevelList = !mcm.I_SwordLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_SwordLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_LVLL)
        mcm.I_WaraxeLevelList = !mcm.I_WaraxeLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_WaraxeLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_LVLL)
        mcm.I_BattleAxeLevelList = !mcm.I_BattleAxeLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_BattleAxeLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_LVLL)
        mcm.I_GreatSwordLevelList = !mcm.I_GreatSwordLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_GreatSwordLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_LVLL)
        mcm.I_WarHammerLevelList = !mcm.I_WarHammerLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_WarHammerLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Dagger_LVLL)
        mcm.I_DaggerLevelList = !mcm.I_DaggerLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_DaggerLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Bow_LVLL)
        mcm.I_BowLevelList = !mcm.I_BowLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_BowLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_LVLL)
        mcm.I_CrossbowLevelList = !mcm.I_CrossbowLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_CrossbowLevelList)
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_LVLL)
        mcm.I_HeavyArmorLevelList = !mcm.I_HeavyArmorLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyArmorLevelList)
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_LVLL)
        mcm.I_HeavyShieldsLevelList = !mcm.I_HeavyShieldsLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyShieldsLevelList)
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_LVLL)
        mcm.I_LightArmorLevelList = !mcm.I_LightArmorLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_LightArmorLevelList)
    ElseIf (optionId == mcm.oid_Inventory_LightShields_LVLL)
        mcm.I_LightShieldsLevelList = !mcm.I_LightShieldsLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_LightShieldsLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_LVLL)
        mcm.I_AlterationSpellTomesLevelList = !mcm.I_AlterationSpellTomesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_LVLL)
        mcm.I_AlterationRobesLevelList = !mcm.I_AlterationRobesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_LVLL)
        mcm.I_AlterationStavesLevelList = !mcm.I_AlterationStavesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_LVLL)
        mcm.I_ConjurationSpellTomesLevelList = !mcm.I_ConjurationSpellTomesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_LVLL)
        mcm.I_ConjurationRobesLevelList = !mcm.I_ConjurationRobesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_LVLL)
        mcm.I_ConjurationStavesLevelList = !mcm.I_ConjurationStavesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_LVLL)
        mcm.I_DestructionSpellTomesLevelList = !mcm.I_DestructionSpellTomesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_LVLL)
        mcm.I_DestructionRobesLevelList = !mcm.I_DestructionRobesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_LVLL)
        mcm.I_DestructionStavesLevelList = !mcm.I_DestructionStavesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_LVLL)
        mcm.I_IllusionSpellTomesLevelList = !mcm.I_IllusionSpellTomesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_LVLL)
        mcm.I_IllusionRobesLevelList = !mcm.I_IllusionRobesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_LVLL)
        mcm.I_IllusionStavesLevelList = !mcm.I_IllusionStavesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_LVLL)
        mcm.I_RestorationSpellTomesLevelList = !mcm.I_RestorationSpellTomesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationSpellTomesLevelList)        
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_LVLL)
        mcm.I_RestorationRobesLevelList = !mcm.I_RestorationRobesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationRobesLevelList)    
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_LVLL)
        mcm.I_RestorationStavesLevelList = !mcm.I_RestorationStavesLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_LVLL)
        mcm.I_RestorAllLevelList = !mcm.I_RestorAllLevelList
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorAllLevelList)
    
        ;          Full Collection at once
    ElseIf (optionId == mcm.oid_Inventory_Mace_AAO)
        mcm.I_MaceAllAtOnce = !mcm.I_MaceAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_MaceAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Sword_AAO)
        mcm.I_SwordAllAtOnce = !mcm.I_SwordAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_SwordAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_AAO)
        mcm.I_WaraxeAllAtOnce = !mcm.I_WaraxeAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_WaraxeAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_AAO)
        mcm.I_BattleAxeAllAtOnce = !mcm.I_BattleAxeAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_BattleAxeAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_AAO)
        mcm.I_GreatSwordAllAtOnce = !mcm.I_GreatSwordAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_GreatSwordAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_AAO)
        mcm.I_WarHammerAllAtOnce = !mcm.I_WarHammerAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_WarHammerAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Dagger_AAO)
        mcm.I_DaggerAllAtOnce = !mcm.I_DaggerAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_DaggerAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Bow_AAO)
        mcm.I_BowAllAtOnce = !mcm.I_BowAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_BowAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_AAO)
        mcm.I_CrossbowAllAtOnce = !mcm.I_CrossbowAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_CrossbowAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_AAO)
        mcm.I_HeavyArmorAllAtOnce = !mcm.I_HeavyArmorAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyArmorAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_AAO)
        mcm.I_HeavyShieldsAllAtOnce = !mcm.I_HeavyShieldsAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyShieldsAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_AAO)
        mcm.I_LightArmorAllAtOnce = !mcm.I_LightArmorAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_LightArmorAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_LightShields_AAO)
        mcm.I_LightShieldsAllAtOnce = !mcm.I_LightShieldsAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_LightShieldsAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_AAO)
        mcm.I_AlterationSpellTomesAllAtOnce = !mcm.I_AlterationSpellTomesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_AAO)
        mcm.I_AlterationRobesAllAtOnce = !mcm.I_AlterationRobesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_AAO)
        mcm.I_AlterationStavesAllAtOnce = !mcm.I_AlterationStavesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_AAO)
        mcm.I_ConjurationSpellTomesAllAtOnce = !mcm.I_ConjurationSpellTomesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_AAO)
        mcm.I_ConjurationRobesAllAtOnce = !mcm.I_ConjurationRobesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_AAO)
        mcm.I_ConjurationStavesAllAtOnce = !mcm.I_ConjurationStavesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_AAO)
        mcm.I_DestructionSpellTomesAllAtOnce = !mcm.I_DestructionSpellTomesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_AAO)
        mcm.I_DestructionRobesAllAtOnce = !mcm.I_DestructionRobesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_AAO)
        mcm.I_DestructionStavesAllAtOnce = !mcm.I_DestructionStavesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_AAO)
        mcm.I_IllusionSpellTomesAllAtOnce = !mcm.I_IllusionSpellTomesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_AAO)
        mcm.I_IllusionRobesAllAtOnce = !mcm.I_IllusionRobesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_AAO)
        mcm.I_IllusionStavesAllAtOnce = !mcm.I_IllusionStavesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_AAO)
        mcm.I_RestorationSpellTomesAllAtOnce = !mcm.I_RestorationSpellTomesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_AAO)
        mcm.I_RestorationRobesAllAtOnce = !mcm.I_RestorationRobesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationRobesAllAtOnce)    
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_AAO)
        mcm.I_RestorationStavesAllAtOnce = !mcm.I_RestorationStavesAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_AAO)
        mcm.I_RestorAllAllAtOnce = !mcm.I_RestorAllAllAtOnce
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorAllAllAtOnce)

        ;              Nx Eaches
    ElseIf (optionId == mcm.oid_Inventory_ArrowsEach)
        mcm.I_ArrowsEach = !mcm.I_ArrowsEach
        mcm.SetToggleOptionValue(optionId, mcm.I_ArrowsEach)
    ElseIf (optionId == mcm.oid_Inventory_BoltsEach)
        mcm.I_BoltsEach = !mcm.I_BoltsEach
        mcm.SetToggleOptionValue(optionId, mcm.I_BoltsEach)
    ElseIf (optionId == mcm.oid_Inventory_IngotsEach)
        mcm.I_IngotsEach = !mcm.I_IngotsEach
        mcm.SetToggleOptionValue(optionId, mcm.I_IngotsEach)
    ElseIf (optionId == mcm.oid_Inventory_OresEach)
        mcm.I_OresEach = !mcm.I_OresEach
        mcm.SetToggleOptionValue(optionId, mcm.I_OresEach)
    ElseIf (optionId == mcm.oid_Inventory_BloodPotionEach)
        mcm.I_BloodPotionEach = !mcm.I_BloodPotionEach
        mcm.SetToggleOptionValue(optionId, mcm.I_BloodPotionEach)
    ElseIf (optionId == mcm.oid_Inventory_IngredientsEach)
        mcm.I_IngredientsEach = !mcm.I_IngredientsEach
        mcm.SetToggleOptionValue(optionId, mcm.I_IngredientsEach)
    ElseIf (optionId == mcm.oid_Inventory_EnchantmentsEach)
        mcm.I_EnchantmentsEach = !mcm.I_EnchantmentsEach
        mcm.SetToggleOptionValue(optionId, mcm.I_EnchantmentsEach)
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsEmptyEach)
        mcm.I_SoulGemsEmptyEach = !mcm.I_SoulGemsEmptyEach
        mcm.SetToggleOptionValue(optionId, mcm.I_SoulGemsEmptyEach)
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsFilledEach)
        mcm.I_SoulGemsFilledEach = !mcm.I_SoulGemsFilledEach
        mcm.SetToggleOptionValue(optionId, mcm.I_SoulGemsFilledEach)
    ElseIf (optionId == mcm.oid_Inventory_DawnguardDLC01)
        mcm.I_DawnguardDLC01 = !mcm.I_DawnguardDLC01
        mcm.SetToggleOptionValue(optionId, mcm.I_DawnguardDLC01)
    ElseIf (optionId == mcm.oid_Inventory_DragonbornDLC2)
        mcm.I_DragonbornDLC2 = !mcm.I_DragonbornDLC2
        mcm.SetToggleOptionValue(optionId, mcm.I_DragonbornDLC2)      
    EndIf

    ; Reset the chests to ensure changes take effect
    mcm.FixedProperties.SetNeedToUpdateMerchantChests()
    mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    
EndFunction ; on select

Function OnHighlight(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Inventory_Mace_LVLL)
        mcm.SetInfoText("When enabled, ensures a mace will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Sword_LVLL)
        mcm.SetInfoText("When enabled, ensures a sword will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_LVLL)
        mcm.SetInfoText("When enabled, ensures a war axe will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_LVLL)
        mcm.SetInfoText("When enabled, ensures a battleaxe will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_LVLL)
        mcm.SetInfoText("When enabled, ensures a greatsword will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_LVLL)
        mcm.SetInfoText("When enabled, ensures a warhammer will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Dagger_LVLL)
        mcm.SetInfoText("When enabled, ensures a dagger will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Bow_LVLL)
        mcm.SetInfoText("When enabled, ensures a bow will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_LVLL)
        mcm.SetInfoText("When enabled, ensures a crossbow will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_LVLL)
        mcm.SetInfoText("When enabled, ensures a full set of heavy armor will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_LVLL)
        mcm.SetInfoText("When enabled, ensures a heavy shield will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_LVLL)
        mcm.SetInfoText("When enabled, ensures a full set of light armor will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_LightShields_LVLL)
        mcm.SetInfoText("When enabled, ensures a light shield will always be available for purchase from managed blacksmiths. Type based off level. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_LVLL)
        mcm.SetInfoText("When enabled, ensures random novice, apprentice, and adept alteration spell tome will be available for purchase from managed spell vendors. Expert and master level spell tomes become available upon your alteration skill reaching 75 and 100 respectively. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_LVLL)
        mcm.SetInfoText("When enabled, ensures leveled alteration robes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_LVLL)
        mcm.SetInfoText("When enabled, ensures alteration staves, both blank and random enchanted, are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_LVLL)
        mcm.SetInfoText("When enabled, ensures random novice, apprentice, and adept conjuration spell tome will be available for purchase from managed spell vendors. Expert and master level spell tomes become available upon your conjuration skill reaching 75 and 100 respectively. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_LVLL)
        mcm.SetInfoText("When enabled, ensures leveled conjuration robes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_LVLL)
        mcm.SetInfoText("When enabled, ensures conjuration staves, both blank and random enchanted, are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_LVLL)
        mcm.SetInfoText("When enabled, ensures random novice, apprentice, and adept destruction spell tome will be available for purchase from managed spell vendors. Expert and master level spell tomes become available upon your destruction skill reaching 75 and 100 respectively. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_LVLL)
        mcm.SetInfoText("When enabled, ensures leveled destruction robes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_LVLL)
        mcm.SetInfoText("When enabled, ensures destruction staves, both blank and random enchanted, are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_LVLL)
        mcm.SetInfoText("When enabled, ensures random novice, apprentice, and adept illusion spell tome will be available for purchase from managed spell vendors. Expert and master level spell tomes become available upon your illusion skill reaching 75 and 100 respectively. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_LVLL)
        mcm.SetInfoText("When enabled, ensures leveled illusion robes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_LVLL)
        mcm.SetInfoText("When enabled, ensures illusion staves, both blank and random enchanted, are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_LVLL)
        mcm.SetInfoText("When enabled, ensures random novice, apprentice, and adept restoration spell tome will be available for purchase from managed spell vendors. Expert and master level spell tomes become available upon your restoration skill reaching 75 and 100 respectively. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_LVLL)
        mcm.SetInfoText("When enabled, ensures leveled restoration robes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_LVLL)
        mcm.SetInfoText("When enabled, ensures restoration staves, both blank and random enchanted, are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_LVLL)
        mcm.SetInfoText("When enabled, ensures a small number of potions of well being will be available for purchase from managed apothecaries. Potency based off level. [Default off]")
        
        ;           Full Collection
    ElseIf (optionId == mcm.oid_Inventory_Mace_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of maces will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Sword_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of swords will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of war axes will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of battleaxes will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of greatswords will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of warhammers will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Dagger_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of daggers will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Bow_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of bows will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of crossbows will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of complete heavy armor sets will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of heavy shields will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of complete light armor sets will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_LightShields_AAO)
        mcm.SetInfoText("When enabled, ensures the full collection of light shields will always be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_AAO)
        mcm.SetInfoText("When enabled, ensures all alteration spell tomes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_AAO)
        mcm.SetInfoText("When enabled, ensures alteration robes of every level will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_AAO)
        mcm.SetInfoText("When enabled, ensures all alteration staves are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_AAO)
        mcm.SetInfoText("When enabled, ensures all conjuration spell tomes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_AAO)
        mcm.SetInfoText("When enabled, ensures conjuration robes of every level will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_AAO)
        mcm.SetInfoText("When enabled, ensures all conjuration staves are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_AAO)
        mcm.SetInfoText("When enabled, ensures all destruction spell tomes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_AAO)
        mcm.SetInfoText("When enabled, ensures destruction robes of every level will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_AAO)
        mcm.SetInfoText("When enabled, ensures all destruction staves are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_AAO)
        mcm.SetInfoText("When enabled, ensures all illusion spell tomes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_AAO)
        mcm.SetInfoText("When enabled, ensures illusion robes of every level will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_AAO)
        mcm.SetInfoText("When enabled, ensures all illusion staves are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_AAO)
        mcm.SetInfoText("When enabled, ensures all restoration spell tomes will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_AAO)
        mcm.SetInfoText("When enabled, ensures restoration robes of every level will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_AAO)
        mcm.SetInfoText("When enabled, ensures all restoration staves are availabe for purchase from managed spell vendors. Includes a small amount of heart stones. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_AAO)
        mcm.SetInfoText("When enabled, ensures a small number of potions of well being at each potency level will be available for purchase from managed apothecaries. [Default off]")

        ;              Nx Eaches
    ElseIf (optionId == mcm.oid_Inventory_ArrowsEach)
        mcm.SetInfoText("When enabled, ensures an amount of arrows of each type will be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_BoltsEach)
        mcm.SetInfoText("When enabled, ensures an amount of bolts of each type (50 standard/20 elemental) will be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IngotsEach)
        mcm.SetInfoText("When enabled, ensures an amount of ingots of each type will be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_OresEach)
        mcm.SetInfoText("When enabled, ensures an amount of ores of each type will be available for purchase from managed blacksmiths. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_BloodPotionEach)
        mcm.SetInfoText("When enabled, ensures an amount of blood potions will be available for purchase from managed apothecaries. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_IngredientsEach)
        mcm.SetInfoText("When enabled, ensures an amount of each ingredient will be available for purchase from managed apothecaries. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_EnchantmentsEach)
        mcm.SetInfoText("When enabled, ensures one of each enchantment will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsEmptyEach)
        mcm.SetInfoText("When enabled, ensures an amount of each size of empty soul gem will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsFilledEach)
        mcm.SetInfoText("When enabled, ensures an amount of each size of filled soul gem will be available for purchase from managed spell vendors. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DawnguardDLC01)
        mcm.SetInfoText("When enabled, adds leveled lists of items from Dawnguard to various merchant types. [Default off]")
    ElseIf (optionId == mcm.oid_Inventory_DragonbornDLC2)
        mcm.SetInfoText("When enabled, adds leveled lists of items from Dragonborn to various merchant types. [Default off]")
    EndIf
EndFunction

Function OnDefault(YoureHiredMCM mcm, int optionId) global
    If (optionId == mcm.oid_Inventory_Mace_LVLL)
        mcm.I_MaceLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_MaceLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Sword_LVLL)
        mcm.I_SwordLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_SwordLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_LVLL)
        mcm.I_WarAxeLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_WarAxeLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_LVLL)
        mcm.I_BattleAxeLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BattleAxeLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_LVLL)
        mcm.I_GreatSwordLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_GreatSwordLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_LVLL)
        mcm.I_WarHammerLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_WarHammerLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Dagger_LVLL)
        mcm.I_DaggerLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DaggerLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Bow_LVLL)
        mcm.I_BowLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BowLevelList)
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_LVLL)
        mcm.I_CrossbowLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_CrossbowLevelList)
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_LVLL)
        mcm.I_HeavyArmorLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyArmorLevelList)
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_LVLL)
        mcm.I_HeavyShieldsLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyShieldsLevelList)
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_LVLL)
        mcm.I_LightArmorLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_LightArmorLevelList)
    ElseIf (optionId == mcm.oid_Inventory_LightShields_LVLL)
        mcm.I_LightShieldsLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_LightShieldsLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_LVLL)
        mcm.I_AlterationSpellTomesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_LVLL)
        mcm.I_AlterationRobesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_LVLL)
        mcm.I_AlterationStavesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_LVLL)
        mcm.I_ConjurationSpellTomesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_LVLL)
        mcm.I_ConjurationRobesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_LVLL)
        mcm.I_ConjurationStavesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_LVLL)
        mcm.I_DestructionSpellTomesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_LVLL)
        mcm.I_DestructionRobesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_LVLL)
        mcm.I_DestructionStavesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_LVLL)
        mcm.I_IllusionSpellTomesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionSpellTomesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_LVLL)
        mcm.I_IllusionRobesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionRobesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_LVLL)
        mcm.I_IllusionStavesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_LVLL)
        mcm.I_RestorationSpellTomesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationSpellTomesLevelList)        
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_LVLL)
        mcm.I_RestorationRobesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationRobesLevelList)    
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_LVLL)
        mcm.I_RestorationStavesLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationStavesLevelList)
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_LVLL)
        mcm.I_RestorAllLevelList = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorAllLevelList)
    
        ;          Full Collection at once
    ElseIf (optionId == mcm.oid_Inventory_Mace_AAO)
        mcm.I_MaceAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_MaceAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Sword_AAO)
        mcm.I_SwordAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_SwordAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Waraxe_AAO)
        mcm.I_WaraxeAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_WaraxeAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Battleaxe_AAO)
        mcm.I_BattleAxeAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BattleAxeAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Greatsword_AAO)
        mcm.I_GreatSwordAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_GreatSwordAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Warhammer_AAO)
        mcm.I_WarHammerAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_WarHammerAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Dagger_AAO)
        mcm.I_DaggerAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DaggerAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Bow_AAO)
        mcm.I_BowAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BowAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_Crossbow_AAO)
        mcm.I_CrossbowAllAtOnce= false
        mcm.SetToggleOptionValue(optionId, mcm.I_CrossbowAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_HeavyArmor_AAO)
        mcm.I_HeavyArmorAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyArmorAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_HeavyShields_AAO)
        mcm.I_HeavyShieldsAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_HeavyShieldsAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_LightArmor_AAO)
        mcm.I_LightArmorAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_LightArmorAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_LightShields_AAO)
        mcm.I_LightShieldsAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_LightShieldsAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationSpellTomes_AAO)
        mcm.I_AlterationSpellTomesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationRobes_AAO)
        mcm.I_AlterationRobesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_AlterationStaves_AAO)
        mcm.I_AlterationStavesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_AlterationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationSpellTomes_AAO)
        mcm.I_ConjurationSpellTomesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationRobes_AAO)
        mcm.I_ConjurationRobesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_ConjurationStaves_AAO)
        mcm.I_ConjurationStavesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ConjurationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionSpellTomes_AAO)
        mcm.I_DestructionSpellTomesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionRobes_AAO)
        mcm.I_DestructionRobesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_DestructionStaves_AAO)
        mcm.I_DestructionStavesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DestructionStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionSpellTomes_AAO)
        mcm.I_IllusionSpellTomesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionRobes_AAO)
        mcm.I_IllusionRobesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionRobesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_IllusionStaves_AAO)
        mcm.I_IllusionStavesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IllusionStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorationSpellTomes_AAO)
        mcm.I_RestorationSpellTomesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationSpellTomesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorationRobes_AAO)
        mcm.I_RestorationRobesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationRobesAllAtOnce)    
    ElseIf (optionId == mcm.oid_Inventory_RestorationStaves_AAO)
        mcm.I_RestorationStavesAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorationStavesAllAtOnce)
    ElseIf (optionId == mcm.oid_Inventory_RestorAll_AAO)
        mcm.I_RestorAllAllAtOnce = false
        mcm.SetToggleOptionValue(optionId, mcm.I_RestorAllAllAtOnce)

        ;              Nx Eaches
    ElseIf (optionId == mcm.oid_Inventory_ArrowsEach)
        mcm.I_ArrowsEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_ArrowsEach)
    ElseIf (optionId == mcm.oid_Inventory_BoltsEach)
        mcm.I_BoltsEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BoltsEach)
    ElseIf (optionId == mcm.oid_Inventory_IngotsEach)
        mcm.I_IngotsEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IngotsEach)
    ElseIf (optionId == mcm.oid_Inventory_OresEach)
        mcm.I_OresEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_OresEach)
    ElseIf (optionId == mcm.oid_Inventory_BloodPotionEach)
        mcm.I_BloodPotionEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_BloodPotionEach)
    ElseIf (optionId == mcm.oid_Inventory_IngredientsEach)
        mcm.I_IngredientsEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_IngredientsEach)
    ElseIf (optionId == mcm.oid_Inventory_EnchantmentsEach)
        mcm.I_EnchantmentsEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_EnchantmentsEach)
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsEmptyEach)
        mcm.I_SoulGemsEmptyEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_SoulGemsEmptyEach)
    ElseIf (optionId == mcm.oid_Inventory_SoulGemsFilledEach)
        mcm.I_SoulGemsFilledEach = false
        mcm.SetToggleOptionValue(optionId, mcm.I_SoulGemsFilledEach)
    ElseIf (optionId == mcm.oid_Inventory_DawnguardDLC01)
        mcm.I_DawnguardDLC01 = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DawnguardDLC01)
    ElseIf (optionId == mcm.oid_Inventory_DragonbornDLC2)
        mcm.I_DragonbornDLC2 = false
        mcm.SetToggleOptionValue(optionId, mcm.I_DragonbornDLC2) 
    EndIf
    
    ; Reset the chests to ensure changes take effect
    mcm.FixedProperties.SetNeedToUpdateMerchantChests()
    mcm.FixedProperties.MerchantManager.UpdateResetCondtions()
    
EndFunction ; On Default


