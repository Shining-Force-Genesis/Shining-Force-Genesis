extends Node2D

enum e_menu_options {
	SAVE_OPTION,
	CURE_OPTION,
	DEAD_OPTION,
	PROMOTION_OPTION
}
var currently_selected_option: int = e_menu_options.SAVE_OPTION

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $NinePatchRect/Label

@onready var save_spirte: Sprite2D = $SaveActionSprite
@onready var cure_spirte: Sprite2D = $CureActionSprite
@onready var dead_spirte: Sprite2D = $DeadActionSprite
@onready var promotion_spirte: Sprite2D = $PromotionActionSprite

# onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")


func _ready():
	Singleton_CommonVariables.ui__priest_menu = self
	set_sprites_to_zero_frame()
	animationPlayer.set_speed_scale(2)
	animationPlayer.play("AttackMenuOption")
	label.text = "Save"
	process_mode = Node.PROCESS_MODE_DISABLED


func set_menu_active() -> void:
	await get_tree().create_timer(0.02).timeout
	
	process_mode = Node.PROCESS_MODE_DISABLED
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.SAVE_OPTION
	animationPlayer.play("AttackMenuOption")
	label.text = "Save"


func _process(_delta):	
	if Input.is_action_just_released("ui_b_key"):
		CancelPriestMenu()
		return
	
	if Input.is_action_just_released("ui_a_key"):
		# return
		
		await get_tree().create_timer(0.02).timeout
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.PROMOTION_OPTION:
			process_mode = Node.PROCESS_MODE_DISABLED
			AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			Singleton_CommonVariables.action_type = "PRIEST_PROMOTION"
			
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "No one seems to deserve a promotion.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				# Singleton_CommonVariables.menus_root_node.GoldInfoBox.hide()
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				show()
				process_mode = Node.PROCESS_MODE_INHERIT
			return
		elif currently_selected_option == e_menu_options.DEAD_OPTION:
			process_mode = Node.PROCESS_MODE_DISABLED
			AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_DEAD"
			
			# Singleton_CommonVariables.menus_root_node.character_info_box_node().hide()
			# Singleton_CommonVariables.menus_root_node.gold_info_box_node().hide()
			
			Singleton_CommonVariables.dialogue_box_node.show()
			
			Singleton_CommonVariables.ui__micro_member_list_view.set_menu_active()
			Singleton_CommonVariables.ui__micro_member_list_view.HideInventoryPreview()
			Singleton_CommonVariables.ui__micro_member_list_view.show()
			
			return
		elif currently_selected_option == e_menu_options.CURE_OPTION:
			process_mode = Node.PROCESS_MODE_DISABLED
			AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_CURE"
			
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "No one seems to need my help.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				# Singleton_CommonVariables.menus_root_node.GoldInfoBox.hide()
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				show()
				process_mode = Node.PROCESS_MODE_INHERIT
		
			return
		elif currently_selected_option == e_menu_options.SAVE_OPTION:
			process_mode = Node.PROCESS_MODE_DISABLED
			AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			Singleton_CommonVariables.action_type = "PRIEST_SAVE"
			
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "DEV - Saving disabled cause I'm still chaning the internals a lot.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				# Singleton_CommonVariables.menus_root_node.GoldInfoBox.hide()
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				show()
				process_mode = Node.PROCESS_MODE_INHERIT
			return
		
		
		
	if Input.is_action_just_pressed("ui_down"):
		menu_option_selected(e_menu_options.PROMOTION_OPTION, "StayMenuOption", "Promotion")
	elif Input.is_action_just_pressed("ui_up"):
		menu_option_selected(e_menu_options.SAVE_OPTION, "AttackMenuOption", "Save")
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.DEAD_OPTION, "InventoryMenuOption", "Raise Dead")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.CURE_OPTION, "MagicMenuOption", "Cure")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	save_spirte.frame = 0
	cure_spirte.frame = 0
	dead_spirte.frame = 0
	promotion_spirte.frame = 0


func CancelPriestMenu() -> void:
	print("Cancel Overworld Action Menu")
	process_mode = Node.PROCESS_MODE_DISABLED
	AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	await get_tree().create_timer(0.02).timeout
	
	Singleton_CommonVariables.action_type = null
	
	Singleton_CommonVariables.interaction_node_reference.interaction_completed()
	
	# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
	# TODO add animation
	hide()
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)


func s_show_priest_menu() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	
	set_sprites_to_zero_frame()
	
	menu_option_selected(e_menu_options.SAVE_OPTION, "AttackMenuOption", "Save")
	
	show()
