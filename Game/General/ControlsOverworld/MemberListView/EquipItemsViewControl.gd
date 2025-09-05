extends Control

var EmptyItemSlotTexture = preload("res://Assets/EmptyItemSlot.png")
var UnequipItemSlotTexture = preload("res://Assets/UnequipHand.png")

@onready var characterStatsPreviewControlNode = $CharacterStatsPreviewControlNode
@onready var redSelectionNode = $RedSelectionBorderRoot
@onready var selectedItemLabel = $SelectedItemLabel

const ITEM_TEXT_SELECTION_POSITIONS = [
	Vector2(-144, -12),
	Vector2(-160, 0),
	Vector2(-128, 0),
	Vector2(-144, 12),
]

enum E_SelectedItem {
	UP,
	LEFT,
	RIGHT,
	DOWN
}
var selected_item: int = E_SelectedItem.UP

var weapons_array = null

var is_equip_menu_active: bool = false

# TEMP: FIXME: refactor
# make this this a global enum somewhere else
# taken from Item.gd
enum E_SF1_ATTRIBUTES {
	NONE, 
	ATTACK, 
	DEFENSE,
	AGILITY, 
	MOVE, 
	CRITICAL, 
	HP, 
	MP,
	YGRT
}


func _ready():
	pass


func set_equip_menu_active():
	# show()
	# CleanItemSlots()
	
	await get_tree().create_timer(0.1).timeout
	
	if Singleton_CommonVariables.selected_character.inventory.size() > 0:
		get_parent().get_parent().active = false
		is_equip_menu_active = true
		DisplayWeapons()
		show()
		redSelectionNode.show()
		
		# itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[0]
		# selected_item = E_SelectedItem.UP
		# itemTextRedSelection.show()
	else:
		AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")


func CleanItemSlots() -> void:
	var iicn = get_node("ItemIconsControlNode")
	for i in 3:
		iicn.get_child(i).texture = EmptyItemSlotTexture
	
	iicn.get_child(3).texture = UnequipItemSlotTexture


func set_equip_menu_inactive() -> void:
	is_equip_menu_active = false
	selectedItemLabel.text = "NOTHING"
	hide()


func DisplayWeapons() -> void:
	weapons_array = []
	
	print(Singleton_CommonVariables.selected_character)
	
	for item in Singleton_CommonVariables.selected_character.inventory:
		var irl = load(item.resource)
		
		if irl is CN_SF1_Item_Weapon:
			print(irl.item_name)
			print(irl.equippable_by)
			
			for class_req in irl.equippable_by:
				if class_req == Singleton_CommonVariables.selected_character.class_idx:
					weapons_array.push_back({
						"resource": irl,
						"is_equipped": item.is_equipped
					})
					break
	
	# print(weapons_array)
	
	var i = 0
	var iicn = get_node("ItemIconsControlNode")
	var a_weapon_is_equipped: bool = false
	for item in weapons_array:
		iicn.get_child(i).texture = item.resource.texture
		
		if item.is_equipped:
			a_weapon_is_equipped = true
			
			if i == 0:
				redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[0]
				selected_item = E_SelectedItem.UP
				PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[0].resource)
			elif i == 1:
				redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[1]
				selected_item = E_SelectedItem.LEFT
				PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[1].resource)
			elif i == 2:
				redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[2]
				selected_item = E_SelectedItem.RIGHT
				PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[2].resource)
		
		i = i + 1
	
	if !a_weapon_is_equipped:
		redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[3]
		selected_item = E_SelectedItem.DOWN


func _process(_delta):
	if !is_equip_menu_active:
		return
	
	# UI navigation based on icons
	if Input.is_action_just_released("ui_down"):
		#if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 4:
		
		# Unequip
		
		PreviewDisplayCharacterStatsWithNewEquipSelection(null)
		
		redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[3]
		selected_item = E_SelectedItem.DOWN
	elif Input.is_action_just_released("ui_up"):
		if weapons_array.size() >= 1:
			redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[0]
			selected_item = E_SelectedItem.UP
			PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[0].resource)
	elif Input.is_action_just_released("ui_left"):
		if weapons_array.size() >= 2:
			redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[1]
			selected_item = E_SelectedItem.LEFT
			PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[1].resource)
	elif Input.is_action_just_released("ui_right"):
		if weapons_array.size() >= 3:
			redSelectionNode.position = ITEM_TEXT_SELECTION_POSITIONS[2]
			selected_item = E_SelectedItem.RIGHT
			PreviewDisplayCharacterStatsWithNewEquipSelection(weapons_array[2].resource)
	
	if Input.is_action_just_released("ui_a_key"):
		if selected_item == E_SelectedItem.DOWN:
			for i in Singleton_CommonVariables.selected_character.inventory.size():
				Singleton_CommonVariables.selected_character.inventory[i].is_equipped = false
				
#				var item = load(Singleton_Game_GlobalCommonVariables.selected_character.inventory[i].resource)
#
#				print(item.get_item_type())
#				print(item.get_item_type() == "Weapon")
#				print("\n")
#
#				if item.get_item_type() == "Weapon":
#					Singleton_Game_GlobalCommonVariables.selected_character.inventory[i].is_equipped = false
#
#
#			print(Singleton_Game_GlobalCommonVariables.selected_character.inventory)
#
#			pass
		else:
			var war = weapons_array[selected_item].resource
			for i in Singleton_CommonVariables.selected_character.inventory.size():
				var item = load(Singleton_CommonVariables.selected_character.inventory[i].resource)
				if item is CN_SF1_Item_Weapon:
					if item.item_name == war.item_name:
						Singleton_CommonVariables.selected_character.inventory[i].is_equipped = true
					else:
						Singleton_CommonVariables.selected_character.inventory[i].is_equipped = false
		
		selectedItemLabel.text = "NOTHING"
		set_equip_menu_inactive()
		get_parent().get_parent().active = true
		get_parent().get_parent().itemsViewControlNode.show()
		get_parent().get_parent().itemsViewControlNode.find_child("RedSelectionBorderRoot").hide()
		get_parent().get_parent().itemsViewControlNode.DisplayItems()
		get_parent().get_parent().DisplayItemsFullInfo(Singleton_CommonVariables.selected_character)
		
	elif Input.is_action_just_released("ui_b_key"):
		selectedItemLabel.text = "NOTHING"
		set_equip_menu_inactive()
		get_parent().get_parent().active = true
		get_parent().get_parent().itemsViewControlNode.show()
		get_parent().get_parent().itemsViewControlNode.find_child("RedSelectionBorderRoot").hide()
		get_parent().get_parent().itemsViewControlNode.DisplayItems()
	
	pass


func DisplayCharacterStats(force_member) -> void: 
	var c = force_member
	
	var attack = c.stats.attack + c.stats.attack_boost
	var defense = c.stats.defense + c.stats.defense_boost
	var agility = c.stats.agility + c.stats.agility_boost
	var move = c.stats.move + c.stats.move_boost
	var hp = c.stats.hp + c.stats.hp_boost
	var mp = c.stats.mp + c.stats.mp_boost
	var critical_hit_chance = c.stats.critical_hit_chance + c.stats.critical_hit_chance_boost
	var double_attack_chance = c.stats.double_attack_chance + c.stats.double_attack_chance_boost
	var dodge_chance = c.stats.dodge_chance + c.stats.dodge_chance_boost
	
	
	var i = 0
	for item in Singleton_CommonVariables.selected_character.inventory:
		print(Singleton_CommonVariables.selected_character.inventory[i].is_equipped)
		if Singleton_CommonVariables.selected_character.inventory[i].is_equipped == false:
			i = i + 1
			continue
		
		var irl = load(item.resource)
		var j = 0
		if irl is CN_SF1_Item_Weapon:
			for attr in range(irl.attributes.size()):
				# print(attr)
				match irl.attributes[attr].attribute_type:
					# Singleton_Game_GlobalCommonVariables.E_SF1_ATTRIBUTES.NONE: pass
					E_SF1_ATTRIBUTES.ATTACK: attack = attack + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.DEFENSE: defense = defense + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.AGILITY: agility = agility + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.MOVE: move = move + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.CRITICAL: critical_hit_chance = critical_hit_chance + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.HP: hp = hp + irl.attributes[attr].attribute_bonus
					E_SF1_ATTRIBUTES.MP: mp = mp + irl.attributes[attr].attribute_bonus
					# E_A.YGRT: attack = attack + weapon_resource_preview.attribute_bonus[i]
				
				j = j + 1
		i = i + 1
	
	characterStatsPreviewControlNode.get_node("AttackControl").get_child(1).text = str(attack)
	characterStatsPreviewControlNode.get_node("DefenseControl").get_child(1).text = str(defense)
	characterStatsPreviewControlNode.get_node("AgilityControl").get_child(1).text = str(agility)
	characterStatsPreviewControlNode.get_node("MoveControl").get_child(1).text = str(move)
	characterStatsPreviewControlNode.get_node("HPControl").get_child(1).text = str(hp)
	characterStatsPreviewControlNode.get_node("MPControl").get_child(1).text = str(mp)
	characterStatsPreviewControlNode.get_node("CriticalHitChanceAttackControl").get_child(1).text = str(critical_hit_chance)
	characterStatsPreviewControlNode.get_node("DoubleAttackChanceControl").get_child(1).text = str(double_attack_chance)
	characterStatsPreviewControlNode.get_node("DodgeControl").get_child(1).text = str(dodge_chance)


func PreviewDisplayCharacterStatsWithNewEquipSelection(weapon_resource_preview) -> void:
	var c = Singleton_CommonVariables.selected_character
	
	var attack = c.stats.attack + c.stats.attack_boost
	var defense = c.stats.defense + c.stats.defense_boost
	var agility = c.stats.agility + c.stats.agility_boost
	var move = c.stats.move + c.stats.move_boost
	var hp = c.stats.hp + c.stats.hp_boost
	var mp = c.stats.mp + c.stats.mp_boost
	var critical_hit_chance = c.stats.critical_hit_chance + c.stats.critical_hit_chance_boost
	var double_attack_chance = c.stats.double_attack_chance + c.stats.double_attack_chance_boost
	var dodge_chance = c.stats.dodge_chance + c.stats.dodge_chance_boost
	
	var i = 0
	if weapon_resource_preview != null:
		selectedItemLabel.text = weapon_resource_preview.item_name
		
		for attr in range(weapon_resource_preview.attributes.size()):
			
			print("What the fuck - ", weapon_resource_preview.attributes[attr], E_SF1_ATTRIBUTES.ATTACK)
			
			match weapon_resource_preview.attributes[attr].attribute_type:
				# Singleton_Game_GlobalCommonVariables.E_SF1_ATTRIBUTES.NONE: pass
				E_SF1_ATTRIBUTES.ATTACK: attack = attack + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.DEFENSE: defense = defense + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.AGILITY: agility = agility + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.MOVE: move = move + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.CRITICAL: critical_hit_chance = critical_hit_chance + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.HP: hp = hp + weapon_resource_preview.attributes[attr].attribute_bonus
				E_SF1_ATTRIBUTES.MP: mp = mp + weapon_resource_preview.attributes[attr].attribute_bonus
				# E_A.YGRT: attack = attack + weapon_resource_preview.attribute_bonus
			
			i = i + 1
	else:
		selectedItemLabel.text = "NOTHING"
	
	characterStatsPreviewControlNode.get_node("AttackControl").get_child(1).text = str(attack)
	characterStatsPreviewControlNode.get_node("DefenseControl").get_child(1).text = str(defense)
	characterStatsPreviewControlNode.get_node("AgilityControl").get_child(1).text = str(agility)
	characterStatsPreviewControlNode.get_node("MoveControl").get_child(1).text = str(move)
	characterStatsPreviewControlNode.get_node("HPControl").get_child(1).text = str(hp)
	characterStatsPreviewControlNode.get_node("MPControl").get_child(1).text = str(mp)
	characterStatsPreviewControlNode.get_node("CriticalHitChanceAttackControl").get_child(1).text = str(critical_hit_chance)
	characterStatsPreviewControlNode.get_node("DoubleAttackChanceControl").get_child(1).text = str(double_attack_chance)
	characterStatsPreviewControlNode.get_node("DodgeControl").get_child(1).text = str(dodge_chance)
	
