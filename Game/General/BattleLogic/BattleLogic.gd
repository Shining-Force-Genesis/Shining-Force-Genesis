extends Node

class_name battle_logic_node

@onready var turn_logic_node = $TurnLogic
@onready var movement_logic_node = $MovementLogic


func _ready() -> void:
	Singleton_CommonVariables.battle__logic_node = self
