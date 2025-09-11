extends Node2D

var actor_type: String
var inventory 
var force_member_idx
var enemey_node

@onready var inventory_preview_view = $InventoryPreview

@onready var stats_info_view = $StatsInfoView
@onready var stats_info_view_attack: Label = $StatsInfoView/AttackLabel
@onready var stats_info_view_defense: Label = $StatsInfoView/DefenseLabel
@onready var stats_info_view_move: Label = $StatsInfoView/MoveLabel
@onready var stats_info_view_agility: Label = $StatsInfoView/AgilityLabel
@onready var stats_info_view_dodge: Label = $StatsInfoView/DodgeLabel
@onready var stats_info_view_critical: Label = $StatsInfoView/CriticalLabel

@onready var item_info_view = $InfoItemView
@onready var item_info_view_name_label = $InfoItemView/NameStaticLabel
@onready var item_info_view_equip_label = $InfoItemView/EquipStaticLabel

var EmptyItemSlotTexture = load("res://Assets/EmptyItemSlot.png")

@onready var SlotUpSprite = $InventoryPreview/SlotUpSprite
@onready var SlotLeftSprite = $InventoryPreview/SlotLeftSprite
@onready var SlotRightSprite = $InventoryPreview/SlotRightSprite
@onready var SlotDownSprite = $InventoryPreview/SlotDownSprite
@onready var RedSelectionBorderRoot = $InventoryPreview/RedSelectionBorderRoot

enum E_ItemSelection {
	UP,
	LEFT,
	RIGHT,
	DOWN
}

const RedSelectionPositions = [
	Vector2(16, 0),
	Vector2(0, 12),
	Vector2(32, 12),
	Vector2(16, 24)
]

var current_selection = E_ItemSelection.UP


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	Singleton_CommonVariables.ui__battle_inventory_item_action_menu = self


func display_actor_inventory() -> void:
	current_selection = E_ItemSelection.UP
	RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	
	CleanItemSlots()
	
	if actor_type == "Character":
		var fm = Singleton_CommonVariables.sf_game_data_node.ForceMembers[force_member_idx]
		
		stats_info_view_attack.text = str(fm.stats.attack)
		stats_info_view_defense.text = str(fm.stats.defense)
		stats_info_view_move.text = str(fm.stats.move)
		stats_info_view_agility.text = str(fm.stats.agility)
		# stats_info_view_dodge.text = str(fm.stats.dodge_chance)
		# stats_info_view_critical.text = str(fm.stats.critical)
	
	if inventory.size() == 0:
		item_info_view_equip_label.text = ""
		item_info_view_equip_label.text = ""
	else:
		for item_idx in inventory.size():
			var r = load(inventory[item_idx].resource)
			
			match item_idx:
				0: SlotUpSprite.texture = r.texture
				1: SlotLeftSprite.texture = r.texture
				2: SlotRightSprite.texture = r.texture
				3: SlotDownSprite.texture = r.texture
			
			if item_idx == 0:
				item_info_view_name_label.text = r.item_name
				
				if inventory[item_idx].is_equipped:
					item_info_view_equip_label.text = "EQUIPPED"
				else:
					item_info_view_equip_label.text = ""


func show_with_tween() -> void:
	show()
	set_menu_active()


func set_menu_active() -> void:
	# CleanItemSlots()
	process_mode = Node.PROCESS_MODE_INHERIT
	current_selection = E_ItemSelection.UP
	RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	RedSelectionBorderRoot.show()

func set_menu_inactive() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	RedSelectionBorderRoot.hide()


func CleanItemSlots() -> void:
	SlotUpSprite.texture = EmptyItemSlotTexture
	SlotLeftSprite.texture = EmptyItemSlotTexture
	SlotRightSprite.texture = EmptyItemSlotTexture
	SlotDownSprite.texture = EmptyItemSlotTexture


func _input(event):
	if event.is_action_released("ui_b_key"):
		print("Cancel Battle Inventory Menu")
		process_mode = Node.PROCESS_MODE_DISABLED
		AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
		
		Singleton_CommonVariables.ui__battle_inventory_item_action_menu.hide()
		# Singleton_BattleVariables.battle_base.s_hide_battle_inventory_menu()
		
		Singleton_CommonVariables.ui__battle_inventory_action_menu.show()
		
		Singleton_CommonVariables.battle_inventory_action_type = ""
		
		# Singleton_BattleVariables.battle_base.s_show_battle_action_menu("right")
		
		# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
		# yield on signal seems busted sometimes gets double called or falls through?
		await Signal(get_tree().create_timer(0.1), "timeout")
		
		Singleton_CommonVariables.ui__battle_inventory_action_menu.set_menu_active()
		
		# get_parent().get_node("BattleActionsMenuRoot").set_menu_active()
		return
	
	if Input.is_action_just_released("ui_down"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			# print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory)
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 4:
				current_selection = E_ItemSelection.DOWN
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
				
				update_item_selection(c_idx, 3)
			pass
	elif Input.is_action_just_released("ui_up"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 1:
				current_selection = E_ItemSelection.UP
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
				update_item_selection(c_idx, 0)
	elif Input.is_action_just_released("ui_left"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 2:
				current_selection = E_ItemSelection.LEFT
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
				update_item_selection(c_idx, 1)
	elif Input.is_action_just_released("ui_right"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 3:
				current_selection = E_ItemSelection.RIGHT
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
				update_item_selection(c_idx, 2)
	
	elif Input.is_action_just_released("ui_a_key"):
		print(current_selection)
		
		match Singleton_CommonVariables.battle_inventory_action_type:
			"EQUIP":
				var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
				if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() > 0:
					var r = load(Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory[current_selection].resource)
					
					if r.item_type == "WEAPON":
						for item in Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory:
							item.is_equipped = false
						
						# TODO: check class requirements
						# TODO: should make a generic attempt to equip item function 
						# CLEAN: lots of clean up to do after Chapter 1 is is quasi fully working
						
						Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory[current_selection].is_equipped = true
						inventory = Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory
						display_actor_inventory()
					else:
						AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				pass
			"USE":
				await Signal(get_tree().create_timer(0.1), "timeout")
				
				var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
				
				if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() <= 0:
					AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
					return
				
				var r = load(Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory[current_selection].resource)
				
				if r.item_type != "USABLE":
					AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
					return
				
				if r.item_name == "Angel Wing":
					print("Angel Wing Used")
					
					# TODO: show dialogue
					Singleton_CommonVariables.ui__battle_inventory_item_action_menu.hide()
					# Singleton_BattleVariables.battle_base.s_hide_battle_inventory_menu()
					Singleton_CommonVariables.ui__battle_inventory_action_menu.show()
					Singleton_CommonVariables.battle_inventory_action_type = ""
					
					Singleton_CommonVariables.main_character_player_node = Singleton_CommonVariables.main_character_player_node_ref
					
					Singleton_CommonVariables.battle__target_actor_types = null
					Singleton_CommonVariables.battle__resource_animation_scene_path = null
					Singleton_CommonVariables.ui__magic_menu.hide()
					
					Singleton_CommonVariables.is_currently_in_battle_scene = false
					# Singleton_CommonVariables.main_character_player_node.disabled_main_character()
					Singleton_CommonVariables.sf_game_data_node.egress_marker_set = true
					Singleton_CommonVariables.ui__battle_action_menu.is_menu_active = false
					Singleton_CommonVariables.ui__battle_action_menu.hide_cust()
					
					Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
					Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
					
					# var n = await SceneManager.GetSceneNode(Singleton_CommonVariables.sf_game_data_node.egress_location)
					# SceneManager.ChangeSceneNode(n)
					
					var n = SceneManager.GetSceneNode(Singleton_CommonVariables.sf_game_data_node.egress_location)
					# n.marker = Singleton_CommonVariables.sf_game_data_node.egress_location
					SceneManager.ChangeSceneNode(n)
						
					if Singleton_CommonVariables.main_character_player_node:
						Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
						Singleton_CommonVariables.main_character_player_node.show()
						Singleton_CommonVariables.main_character_player_node.camera_current(true)
					
					return
				
				set_menu_inactive()
				hide()
				Singleton_CommonVariables.battle__logic__target_selection_node.use_item_idx = current_selection
				Singleton_CommonVariables.battle__logic__target_selection_node.set_use_item_target_selection()
				pass
			"DROP":
				var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
				if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() > 0:
					Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.remove_at(current_selection)
					inventory = Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory
					display_actor_inventory()
			"GIVE":
				await Signal(get_tree().create_timer(0.1), "timeout")
				set_menu_inactive()
				hide()
				Singleton_CommonVariables.battle__logic__target_selection_node.give_item_idx = current_selection
				Singleton_CommonVariables.battle__logic__target_selection_node.set_give_item_target_selection()
				return
				pass
		
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
#
#
#
#		for i in fm_size:
#			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
#				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
#
#				if Singleton_Game_GlobalCommonVariables.selected_item != null:
#					Singleton_Game_GlobalCommonVariables.selected_target_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
#				else:
#					Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
#
#				yield(get_tree().create_timer(0.1), "timeout")
#				match Singleton_Game_GlobalCommonVariables.action_type:
#					"SHOP_BUY": CompletePurchaseAndGiveItemToSelectedCharacter()
#
#					"EQUIP": 
#						# equipItemsControlNode.DisplayCharacterStats(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i])
#						# itemsViewControlNode.hide()
#						# equipItemsControlNode.set_equip_menu_active()
#						pass
#
#					# _: itemsViewControlNode.set_item_selection_menu_active()
#
#				# active = false
#
		# hide()
		# active = false
		
		
		# Singleton_CommonVariables.battle_inventory_action_type = "EQUIP"
		# Singleton_CommonVariables.battle_inventory_action_type = "USE"
		# Singleton_CommonVariables.battle_inventory_action_type = "DROP"
		# Singleton_CommonVariables.battle_inventory_action_type = "GIVE"
		
		return
		
		#if event.is_action_released("ui_a_key"):
			#print("Accept Action - ", currently_selected_option)
			#
			#if currently_selected_option == e_inventory_menu_options.EQUIP_OPTION:
				#cleanup_for_sub_menu_navigation()
				#
				## TODO: all of these options are going to depend on in vbattle or not
				## different following menus will be needed
				#
				#if Singleton_CommonVariables.is_currently_in_battle_scene:
					#Singleton_CommonVariables.ui__equip_menu.show()
					#await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__equip_menu.set_menu_active()
				#else:
					#Singleton_CommonVariables.action_type = "EQUIP"
					#Singleton_CommonVariables.ui__member_list_menu.show()
					## await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					#Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				#
				#return
			#elif currently_selected_option == e_inventory_menu_options.USE_OPTION:
				#cleanup_for_sub_menu_navigation()
				#
				#if Singleton_CommonVariables.is_currently_in_battle_scene:
					#Singleton_CommonVariables.ui__use_menu.show()
					## await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__use_menu.set_battle_use_menu_active()
				#else:
					#Singleton_CommonVariables.action_type = "USE"
					#Singleton_CommonVariables.ui__member_list_menu.show()
					## await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					#Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				#
				#return
			#elif currently_selected_option == e_inventory_menu_options.DROP_OPTION:
				#cleanup_for_sub_menu_navigation()
				#
				#if Singleton_CommonVariables.is_currently_in_battle_scene:
					## TODO: Singleton_CommonVariables.ui__drop_menu.show_cust()
					#Singleton_CommonVariables.ui__drop_menu.show()
					#await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__drop_menu.set_battle_drop_menu_active()
				#else:
					#Singleton_CommonVariables.action_type = "DROP"
					#Singleton_CommonVariables.ui__member_list_menu.show()
					#await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					#Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				#
				#return
			#elif currently_selected_option == e_inventory_menu_options.GIVE_OPTION:
				#cleanup_for_sub_menu_navigation()
				#
				#if Singleton_CommonVariables.is_currently_in_battle_scene:
					#Singleton_CommonVariables.ui__give_menu.show()
					#await get_tree().create_timer(0.03).timeout
					#Singleton_CommonVariables.ui__give_menu.set_battle_give_menu_active()
				#else:
					#Singleton_CommonVariables.action_type = "GIVE"
					#Singleton_CommonVariables.ui__member_list_menu.show()
					## await get_tree().create_timer(0.1).timeout
					#Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					#Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				#
				#return


func update_item_selection(c_idx: int, item_idx: int) -> void:
	var item = Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory[item_idx]
	var r = load(item.resource)
	
	item_info_view_name_label.text = r.item_name
	
	if item.is_equipped:
		item_info_view_equip_label.text = "EQUIPPED"
	else:
		item_info_view_equip_label.text = ""
