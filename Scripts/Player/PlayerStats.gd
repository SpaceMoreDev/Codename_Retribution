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


var Health : float = 100:
	set(value):
		Health = clamp(value,0,100)
		HealthBarUI.value = Health
		emit_signal("health_updated", Health)
	get:
		return Health

var Stamina : float = 100:
	set(value):
		Stamina = clamp(value,0,100)
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
	connect("health_updated", check_health)
	connect("stamina_updated", check_stamina)
	connect("form_changed", check_form)
	
	CurrentForm = FORM.HUMAN

func check_health(value):
	print("Health changed to %s"%value)

func check_form(form):
	print("Changed into %s"%FORM.keys()[form])

func check_stamina(value):
	print("Stamina changed to %s"%value)

