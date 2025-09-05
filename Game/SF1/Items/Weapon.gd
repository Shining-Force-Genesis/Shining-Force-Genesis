extends CN_SF1_Item

class_name CN_SF1_Item_Weapon

# TODO: target types for weapons should be cleaned up
# doesn't make sense to have target enemeies and characters in the way its currently
# setup since from the character actors perspective the target is enemeies
# but from enemeies it would be characters
# needs to be simplifed and made clearer 
# maybe something like oppsite actor type, current actor type,  both
# and additional field for self

enum character_classes {SWORDSMAN}

@export var battle_texture: Texture

@export var chance_to_crack: bool = false

#@export_enum("Swordsman - SDMN", "Knight - KNT",
	#"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
	#"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
	#"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
	#"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
	#"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
	#"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
	#"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
	#"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
	#"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
	#"MGCR") var equippable_by: int # Array[int]

enum E_CLASSES {
	Swordsman___SDMN, 
	Knight___KNT,
	Warrior___WARR, 
	Sky_Knight___SKNT, 
	Mage___MAGE,
	Monk___MONK, 
	Healer___HEAL, 
	Archer___ACHR, 
	ASKT,
	Birdman___BDMN,
	Winged_Knight___WKNT,
	Dragon___DRGN, 
	Robot___RBT, 
	Werewolf___WRWF, 
	Samurai___SMR, 
	Ninja___NINJ, 
	Hero___HERO, 
	Paladin___PLDN, 
	Galaditor___GLDR, 
	SBRN, 
	Wizard___WIZD, 
	Master_Monk___MSMK, 
	Vicar___VICR, BWMS, 
	Sky_Warrior___SKYW, 
	SKYL,
	GRDR, 
	Cyborg___CYBG, 
	Wolf_Barron___WFBN, 
	Yogurt___YGRT,
	MGCR
} 
@export var equippable_by: Array[E_CLASSES]

func _ready():
	pass

func get_item_type() -> String:
	return "Weapon"
