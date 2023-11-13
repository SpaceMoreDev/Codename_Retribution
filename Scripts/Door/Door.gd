extends Node3D
class_name Door

## Signal emitted when the door handle is grabbed
signal door_grabbed(door)

## Signal emitted when the door handle is released
signal door_released(door)

## Signal emitted when a latched door is opened
signal door_opened(door)

## Signal emitted when a door re-latches
signal door_closed(door)

var key : DoorKey
var doorbody : RigidBody3D
var hinge : HingeJoint3D

@export var is_locked : bool = false:
	set(v):
		if doorbody:
			doorbody.set_process(!v)
		is_locked = v

## Door self-closing force
@export var close_force := 0.0 # (float, 0.0, 1.0, 0.01)

## Door friction
@export var friction := 0.1 # (float, 0.0, 10.0, 0.1)

## Door bounce-factor at end-stops
@export var bounce := 0.25 # (float, 0.0, 1.0, 0.01)

## Flag to set the door to latch when closed
@export var latch_on_close := true

## Flag to lock the door so the handle will not open it
@export var door_locked := false

func _on_door_grabbed():
	emit_signal("door_grabbed", self)


func _on_door_released():
	emit_signal("door_released", self)


func _on_door_opened():
	emit_signal("door_opened", self)


func _on_door_closed():
	emit_signal("door_closed", self)


func _enter_tree():
	doorbody = $body
	hinge = $hinge

func _ready():
	doorbody.set_process(!is_locked)
		

@warning_ignore("unused_parameter")
func Update(delta):
	pass

func _physics_process(delta):
	Update(delta)
