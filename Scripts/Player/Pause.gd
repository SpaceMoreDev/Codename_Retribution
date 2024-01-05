extends Node
class_name PauseMenu

var player : Player
var playerCam : PlayerCamera
@export var sensitivity : float

# compnents
@export var returnBtn : Button
@export var restartBtn : Button
@export var exitBtn : Button
@export var fullscreenButn : Button
@export var noiseBtn : Button
@export var fireDamageBtn : Button
@export var debugBtn : Button

@export var exposure : LineEdit
@export var fogDensity : LineEdit
@export var playerSpeed : LineEdit
@export var monsterSpeed : LineEdit
@export var monsterDMG : LineEdit


@export var slider : Slider
@export var joysens_slider : Slider
@export var fogSlider : Slider
@export var exposureSlider : Slider

@export var joysens_text : LineEdit
@export var sens_text : LineEdit
var _sensitivity : float
var joy_sensitivity : float

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = Global._get_player()
	playerCam = player.playerCamera

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	fogSlider.value = Global._get_env().environment.fog_density
	exposureSlider.value = Global._get_env().camera_attributes.exposure_multiplier

	noiseBtn.button_pressed = Global.useNoise
	fireDamageBtn.button_pressed = Global.allowFireDamage
	debugBtn.button_pressed = Global.DebugPath

	playerSpeed.text = str(Global.PlayerSpeed)
	monsterSpeed.text = str(Global.MonsterSpeed)
	monsterDMG.text = str(Global.DamageMonster)
	fogDensity.text = str(Global._get_env().environment.fog_density)
	exposure.text = str(Global._get_env().camera_attributes.exposure_multiplier)

	noiseBtn.connect("toggled", noiseToggle)
	debugBtn.connect("toggled", debugToggle)
	fireDamageBtn.connect("toggled", fireDamageToggle)
	returnBtn.connect("button_down", returnButton)
	restartBtn.connect("button_down", restartButton)
	exitBtn.connect("button_down", exitButton)
	fullscreenButn.connect("toggled", fullscreenToggle)

	joysens_slider.connect("value_changed", joysens_value)
	slider.connect("value_changed", slider_value)
	fogSlider.connect("value_changed", slider_fog_density)
	exposureSlider.connect("value_changed", slider_exposure_density)

	exposure.connect("text_changed", set_exposure_value)
	fogDensity.connect("text_changed", set_fog_density)
	monsterDMG.connect("text_changed", Monster_DMG_value)
	sens_text.connect("text_changed", sens_slider_value)
	joysens_text.connect("text_changed", joysens_slider_value)
	playerSpeed.connect("text_changed", set_player_speed)
	monsterSpeed.connect("text_changed", set_monster_speed)


	_sensitivity = ChangeSens(player.playerInput.mouse_sensitivity)
	sens_text.text = str(_sensitivity)
	slider.value = _sensitivity
	
	joy_sensitivity = ChangeSensJoy(player.playerInput.joystick_sensitivity)
	joysens_text.text = str(joy_sensitivity)
	joysens_slider.value = joy_sensitivity
	

func restartButton():
	self.visible = false
	playerCam.locked = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()

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

func joysens_value(val : float):
	joysens_text.text = str(val)
	ChangeSensJoy(val)
func joysens_slider_value(val : String):
	joysens_slider.value = float(val)
	ChangeSensJoy(float(val))

func sens_slider_value(val : String):
	slider.value = float(val)
	ChangeSens(float(val))

func ChangeSens(val) -> float:
	var res = float(val)
	ProjectSettings.set_setting("player/look_sensitivity", res)
	player.playerInput.mouse_sensitivity = res
	return res

func ChangeSensJoy(val) -> float:
	var res = float(val)
	player.playerInput.joystick_sensitivity = res
	return res


func set_player_speed(val : String):
	Global.PlayerSpeed = float(val)

func set_monster_speed(val : String):
	Global.MonsterSpeed = float(val)

func Monster_DMG_value(val : String):
	Global.DamageMonster = float(val)

func set_fog_density(val : String):
	fogSlider.value = float(val)
	Global._get_env().environment.fog_density = float(val)

func slider_fog_density(val : float):
	fogDensity.text = str(val)
	Global._get_env().environment.fog_density = val

func slider_exposure_density(val : float):
	exposure.text = str(val)
	Global._get_env().camera_attributes.exposure_multiplier = val

func set_exposure_value(val : String):
	Global._get_env().camera_attributes.exposure_multiplier = float(val)
	exposureSlider.value = float(val)
