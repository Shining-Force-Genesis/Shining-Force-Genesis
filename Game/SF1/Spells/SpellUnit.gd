extends Resource

class_name CN_SF1_Spell_Unit

## The spell resource path
@export var resource: String
# @export var resource: CN_SF1_Spell

@export var levels = [
	{ # 1
		"unlocked": true,
		"unlock_levels": {
			"unpromoted": 1,
			# promoted
		}
	},
	
	{ # 2
		"unlocked": false,
		"unlock_levels": {
			"unpromoted": 1
			# promoted
		}
	},
	
	{ # 2
		"unlocked": false,
		"unlock_levels": {
			"unpromoted": 1
			# promoted
		}
	},
	
	{ # 2
		"unlocked": false,
		"unlock_levels": {
			"unpromoted": 1
			# promoted
		}
	},
]
