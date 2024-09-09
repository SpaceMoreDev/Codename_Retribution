extends Node
class_name Inputs

signal KeyPressed(Key:StringName)
signal KeyReleased(Key:StringName)
signal KeyHold(Key:StringName)
signal JoyMotion(Axis:Vector2)
signal MouseMotion(Axis:Vector2)

@export var HoldThreshold : float = 0.25
@export var Deadzone : float = 0.25
@export var mouse_sensitivity : float = 0.15
@export var joystick_sensitivity : float = 2
var joystick_state = Vector2.ZERO
var isUsingJoyStick = false;

var inputActionMap : Dictionary = {}
var holdTimer = 0

# Current Inputs
var currentActions : Dictionary
var currentPressedKeys : Array[StringName]

# Mouse Inputs
var mouseDelta : Vector2 = Vector2.ZERO
var mousePosition : Vector2 = Vector2.ZERO


func UpdateActionKeys():
	inputActionMap.clear()
	for actionName in InputMap.get_actions():
		for inputEvent in InputMap.action_get_events(actionName):
			inputActionMap[inputEvent] = actionName

func FindAction(Key : InputEvent) -> String:
	for input : InputEvent in inputActionMap:
		if input.is_match(Key):
			#print("Action: %s >> Input: %s" % [inputActionMap[input], input])
			return inputActionMap[input]
	return ""

func _ready():
	UpdateActionKeys()
	connect("KeyPressed", Pressed)
	connect("KeyReleased", Released) 
	connect("KeyHold", Hold)

func Pressed(Key : StringName):
	currentActions[Key] = 0
	currentPressedKeys.append(Key)

func Released(Key : StringName):
	currentActions.erase(Key)
	currentPressedKeys.erase(Key)

func Hold(Key : StringName):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var Delta = event.relative * mouse_sensitivity 
		mousePosition = event.position
		emit_signal("MouseMotion", Delta)
		isUsingJoyStick = false
		
	elif event is InputEventJoypadMotion:
		#joystick_state = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		joystick_state = Input.get_vector("LOOK_LEFT","LOOK_RIGHT","LOOK_UP","LOOK_DOWN")
		isUsingJoyStick = true
	
	if event is InputEventKey or event is InputEventJoypadButton :
		var action = FindAction(event)
		if action != "":
			if Input.is_action_just_pressed(action):
				emit_signal("KeyPressed", action)
			elif Input.is_action_just_released(action):
				emit_signal("KeyReleased", action)


func _process(delta):
	for action in currentPressedKeys:
		if Input.is_action_pressed(action):
			if currentActions[action] < HoldThreshold:
				currentActions[action] += delta
			else:
				emit_signal("KeyHold", action)
	if isUsingJoyStick:
		# Handle continuous joystick movement
		if abs(joystick_state.length()) > Deadzone:
			var Delta = joystick_state * joystick_sensitivity
			emit_signal("JoyMotion", Delta)
		else:
			emit_signal("JoyMotion", Vector2.ZERO)
