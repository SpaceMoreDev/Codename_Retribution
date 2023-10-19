extends Node3D
class_name PlayerStats

enum FORM {
	HUMAN,
	BEAST
}

@onready var HealthBarUI : TextureProgressBar = $"../Player_UI/HealthBar"
@onready var StaminaBarUI : TextureProgressBar = $"../Player_UI/StaminaBar"
@onready var FormLabelUI : Label = $"../Player_UI/Form"

signal health_updated(newHealth)
signal stamina_updated(newStamina)
signal form_changed(newForm)

const REGEN_SPEED = 7
const CONSUME_SPEED = 40

var Running : bool = true
var CanRun : bool = true
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

var CurrentForm : FORM = FORM.HUMAN:
	set(new_form):
		CurrentForm = new_form
		FormLabelUI.text = FORM.keys()[CurrentForm]
		emit_signal("form_changed", new_form)
	get:
		return CurrentForm


func _ready():
	player = get_parent() as CharacterBody3D
	connect("health_updated", check_health)
	connect("stamina_updated", check_stamina)
	connect("form_changed", check_form)
	player.connect("player_jumped", check_jump)

func check_health(value):
	print("Health changed to %s"%value)

func check_form(form):
	print("Changed into %s"%FORM.keys()[form])

func check_stamina(value):
	# print("Stamina changed to %s"%value)
	if(value == 0):
		get_parent().Speed = Player.WALK_SPEED
		CanRun = false
		Running = false
	if(value > 0):
		Running = true

@warning_ignore("unused_parameter")
func check_jump(jumpHeight):
	if(player.is_on_floor()):	
		Stamina -= CONSUME_SPEED * 1.5

@warning_ignore("unused_parameter")
func _process(delta):
	if(player.is_on_floor()):	
		if(CanRun):
			if(Running and Input.is_action_pressed("RUN")):
				Stamina -= CONSUME_SPEED * delta
	if(Stamina < 100):
		Stamina += REGEN_SPEED * delta
