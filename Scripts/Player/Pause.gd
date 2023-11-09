extends Node
class_name PauseMenu

var player : Player
var playerCam : PlayerCamera
@export var sensitivity : float

# compnents
@export var returnBtn : Button
@export var exitBtn : Button
@export var fullscreenButn : Button
@export var noiseBtn : Button
@export var fireDamageBtn : Button
@export var debugBtn : Button

@export var playerSpeed : LineEdit
@export var monsterSpeed : LineEdit
@export var monsterDMG : LineEdit


@export var slider : Slider
@export var sens_text : LineEdit
@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = Global._get_player()
	playerCam = player.playerCamera

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	sens_text.text = str(_sensitivity)

	noiseBtn.button_pressed = Global.useNoise
	fireDamageBtn.button_pressed = Global.allowFireDamage
	debugBtn.button_pressed = Global.DebugPath

	playerSpeed.text = str(Global.PlayerSpeed)
	monsterSpeed.text = str(Global.MonsterSpeed)
	monsterDMG.text = str(Global.DamageMonster)

	noiseBtn.connect("toggled", noiseToggle)
	debugBtn.connect("toggled", debugToggle)
	fireDamageBtn.connect("toggled", fireDamageToggle)
	returnBtn.connect("button_down", returnButton)
	exitBtn.connect("button_down", exitButton)
	fullscreenButn.connect("toggled", fullscreenToggle)
	slider.connect("value_changed", slider_value)

	monsterDMG.connect("text_changed", Monster_DMG_value)
	sens_text.connect("text_changed", sens_slider_value)
	playerSpeed.connect("text_changed", set_player_speed)
	monsterSpeed.connect("text_changed", set_monster_speed)

func exitButton():
	get_tree().quit()

func fullscreenToggle(toggle : bool):
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func noiseToggle(toggle : bool):
	Global.useNoise = toggle

func fireDamageToggle(toggle: bool):
	Global.allowFireDamage = toggle	

func debugToggle(toggle: bool):
	Global.DebugPath = toggle

func returnButton():
	self.visible = false
	playerCam.locked = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not self.visible:
			self.visible = true
			playerCam.locked = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			self.visible = false
			playerCam.locked = false
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func slider_value(val : float):
	sens_text.text = str(val)
	ChangeSens(val)

func sens_slider_value(val : String):
	slider.value = float(val)
	ChangeSens(float(val))

func ChangeSens(val):
	ProjectSettings.set_setting("player/look_sensitivity", get_process_delta_time() * float(val))
	playerCam._sensitivity = get_process_delta_time() * float(val)


func set_player_speed(val : String):
	Global.PlayerSpeed = float(val)

func set_monster_speed(val : String):
	Global.MonsterSpeed = float(val)

func Monster_DMG_value(val : String):
	Global.DamageMonster = float(val)

