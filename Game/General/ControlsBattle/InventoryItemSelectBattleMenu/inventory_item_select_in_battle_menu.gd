extends Node2D

@onready var inventory_preview_view = $InventoryPreview
@onready var stats_info_view = $StatsInfoView
@onready var item_info_view = $InfoItemView

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
		
		
		# Singleton_BattleVariables.battle_base.s_show_battle_action_menu("right")
		
		# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
		# yield on signal seems busted sometimes gets double called or falls through?
		await Signal(get_tree().create_timer(0.1), "timeout")
		
		Singleton_CommonVariables.ui__battle_inventory_action_menu.set_menu_active()
		
		# get_parent().get_node("BattleActionsMenuRoot").set_menu_active()
		return
	
	if Input.is_action_just_pressed("ui_down"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			# print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory)
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 4:
				current_selection = E_ItemSelection.DOWN
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
			pass
	elif Input.is_action_just_pressed("ui_up"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 1:
				current_selection = E_ItemSelection.UP
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	elif Input.is_action_just_pressed("ui_left"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 2:
				current_selection = E_ItemSelection.LEFT
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	elif Input.is_action_just_pressed("ui_right"):
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2:
			return
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1:
			var c_idx = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot").SF1_MEMBER_INDEX
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[c_idx].inventory.size() >= 3:
				current_selection = E_ItemSelection.RIGHT
				RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	
	elif Input.is_action_just_pressed("ui_a_key"):
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
		
		print(current_selection)
		
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
