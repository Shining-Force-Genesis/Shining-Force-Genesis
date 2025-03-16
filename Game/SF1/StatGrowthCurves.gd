extends Resource

class_name CN_SF1_StatGrowthCurves

func _ready():
	pass 

enum E_CURVE {
	LINEAR,
	EARLY,
	EARLY_AND_LATE,
	LATE
}

const CURVES = [
	# E_CURVE.LINEAR
	[
		Vector2(1, 5),
		Vector2(2, 10),
		Vector2(3, 15),
		Vector2(4, 20),
		Vector2(5, 25),
		Vector2(6, 30),
		Vector2(7, 35),
		Vector2(8, 40),
		Vector2(9, 45),
		Vector2(10, 50),
		Vector2(11, 55),
		Vector2(12, 60),
		Vector2(13, 65),
		Vector2(14, 70),
		Vector2(15, 75),
		Vector2(16, 80),
		Vector2(17, 85),
		Vector2(18, 90),
		Vector2(19, 95),
		Vector2(20, 100)
	],
	
	# E_CURVE.EARLY
	[
		Vector2(1, 12),
		Vector2(2, 25),
		Vector2(3, 37),
		Vector2(4, 50),
		Vector2(5, 60),
		Vector2(6, 70),
		Vector2(7, 75),
		Vector2(8, 80),
		Vector2(9, 85),
		Vector2(10, 90),
		Vector2(11, 91),
		Vector2(12, 93),
		Vector2(13, 94),
		Vector2(14, 95),
		Vector2(15, 96),
		Vector2(16, 97),
		Vector2(17, 98),
		Vector2(18, 99),
		Vector2(19, 99),
		Vector2(20, 100)
	],
	
	# E_CURVE.EARLY_AND_LATE_CURVE
	[
		Vector2(1, 8),
		Vector2(2, 16),
		Vector2(3, 24),
		Vector2(4, 30),
		Vector2(5, 35),
		Vector2(6, 40),
		Vector2(6, 42),
		Vector2(6, 45),
		Vector2(6, 47),
		Vector2(6, 50),
		Vector2(6, 52),
		Vector2(6, 55),
		Vector2(6, 57),
		Vector2(14, 60),
		Vector2(15, 65),
		Vector2(16, 70),
		Vector2(17, 78),
		Vector2(18, 86),
		Vector2(19, 94),
		Vector2(20, 100)
	],
	
	# E_CURVE.LATE
	[
		Vector2(1, 2),
		Vector2(2, 4),
		Vector2(3, 6),
		Vector2(4, 8),
		Vector2(5, 10),
		Vector2(6, 12),
		Vector2(7, 14),
		Vector2(8, 16),
		Vector2(9, 18),
		Vector2(10, 20),
		Vector2(11, 25),
		Vector2(12, 30),
		Vector2(13, 35),
		Vector2(14, 40),
		Vector2(15, 50),
		Vector2(16, 60),
		Vector2(17, 70),
		Vector2(18, 80),
		Vector2(19, 90),
		Vector2(20, 100)
	]
]
