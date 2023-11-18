extends Item
class_name HealthPotion

var playerStats : PlayerStats

func _ready():
	playerStats = Global._get_player().stats

func Use(health : float):
	playerStats.Health += health



func Get_type():
	return "Health"
