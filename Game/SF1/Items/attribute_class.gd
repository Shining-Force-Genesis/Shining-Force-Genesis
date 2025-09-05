class_name Attribute extends Resource

enum E_ATTRIBUTE {
	None, 
	Attack, 
	Defense, 
	Agility, 
	Move, 
	Critcal,
	HP, 
	MP,
	YGRT
}

@export var attribute_type: E_ATTRIBUTE
@export var attribute_bonus: int
