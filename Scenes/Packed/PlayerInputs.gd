extends Node
class_name Inputs

signal KeyPressed(Key:InputEvent)
signal KeyReleased(Key:InputEvent)
signal KeyHold(Key:InputEvent)
signal JoyMotion(Axis:Vector2)
signal MouseMotion(Axis:Vector2)

@export var HoldThreshold : float = 0.25
@export var _sensitivity : float = 0.5

var b_Controller : bool = false
var inputActionMap : Dictionary = {}
var inputThreshold : Dictionary = {}
var holdTimer = 0

# Current Inputs
var currentAction : StringName
var currentPressedKey : InputEvent

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

func Pressed(Key : InputEvent):
	currentPressedKey = Key

func Released(Key : InputEvent):
	if currentPressedKey:
		currentPressedKey = null

func Hold(Key : InputEvent):
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion:
		if event is InputEventMouseMotion:
			var Delta = event.relative * get_process_delta_time()
			mousePosition = event.position
			emit_signal("MouseMotion", Delta)
			b_Controller = false
		elif event is InputEventJoypadMotion:
			b_Controller = true
			var axis = Vector2(Input.get_joy_axis ( 0,JOY_AXIS_RIGHT_X ), Input.get_joy_axis ( 0,JOY_AXIS_RIGHT_Y ))
			var Delta = axis * 350 * get_process_delta_time()
			emit_signal("JoyMotion", Delta)
			print("joy")
			
	
	if event is InputEventKey or event is InputEventJoypadButton :
		var action = FindAction(event)
		currentAction = action
		if currentAction != "":
			if Input.is_action_just_pressed(currentAction):
				emit_signal("KeyPressed", event)
			elif Input.is_action_just_released(currentAction):
				emit_signal("KeyReleased", event)
				holdTimer = 0

func _process(delta):
	if b_Controller:
		pass
	
	if (currentAction != "") and (Input.is_action_pressed(currentAction)):
		if holdTimer < HoldThreshold:
			holdTimer += delta
		else:
			emit_signal("KeyHold", currentPressedKey)
			
