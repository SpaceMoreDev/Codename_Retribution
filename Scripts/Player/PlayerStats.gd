extends Node3D
class_name PlayerStats

enum FORM {
	HUMAN,
	BEAST
}

@onready var HealthBarUI : TextureProgressBar = $"../Player_UI/HealthBar"
@onready var StaminaBarUI : TextureProgressBar = $"../Player_UI/StaminaBar"

signal health_updated(newHealth)
signal stamina_updated(newStamina)
signal form_changed(newForm)

signal stamina_is_zero

const REGEN_SPEED = 7
const CONSUME_SPEED = 40
const CONSUME_JUMP = 30

var enableRegen : bool = true
var CanConsume : bool = true
var player : CharacterBody3D

var Health : float = 100:
	set(value):
		value = clamp(value,0,100)
		Health = value
		HealthBarUI.value = Health
		emit_signal("health_updated", Health)
	get:
		return Health

var Stamina : float = 100:
	set(value):
		value = clamp(value,0,100)
		Stamina = value
		StaminaBarUI.value = Stamina
		emit_signal("stamina_updated", Stamina)
	get:
		return Stamina


func _ready():
	player = get_parent() as CharacterBody3D
	connect("health_updated", check_health)
	connect("stamina_updated", check_stamina)
	connect("stamina_is_zero", emptystamina)
	player.connect("player_jumped", check_jump)

func check_health(value):
	print("Health changed to %s"%value)


func check_stamina(value):
	# print("Stamina changed to %s"%value)
	if(value == 0):
		get_parent().Speed = Player.WALK_SPEED
		CanConsume = false
		emit_signal("stamina_is_zero")
	if(value > CONSUME_JUMP):
		StaminaBarUI.self_modulate = Color.WHITE
	else:
		StaminaBarUI.self_modulate = Color.YELLOW
		

func emptystamina():
	print("waiting..")
	enableRegen = false
	await get_tree().create_timer(2).timeout
	enableRegen = true

@warning_ignore("unused_parameter")
func check_jump(jumpHeight):
	Stamina -= CONSUME_JUMP

@warning_ignore("unused_parameter")
func _process(delta):
	if(player.is_on_floor()):	
		if(CanConsume):
			if( (get_parent() as Player)._input != Vector2.ZERO and Input.is_action_pressed("RUN")):
				Stamina -= CONSUME_SPEED * delta
	if(Stamina < 100):
		if(enableRegen):
			Stamina += REGEN_SPEED * delta
