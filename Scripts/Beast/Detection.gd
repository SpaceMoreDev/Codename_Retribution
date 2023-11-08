extends Node
class_name Detection

var rays : Array[RayCast3D]
@export var areaFar : Area3D
var timer = 1
var beast : Beast
var player : Player

var player_is_around : bool = false


func _ready():
	beast = Global._get_beast()
	player = Global._get_player()
	areaFar.connect("body_entered", body_entered_far)
	areaFar.connect("body_exited", body_exited_far)

	for child in $Head.get_children():
		if child is RayCast3D:
			rays.append(child)

func _physics_process(delta):
	checkRays()


func checkRays() -> bool:
	for ray in rays:
		if ray.is_colliding():
			var col = ray.get_collider()
			if col is Player:
				beast.nav.target_position = col.global_transform.origin
				beast.stateMachine.current_state.Transitioned.emit(beast.stateMachine.current_state, "Chase")
				return true
	return false

func LoudSoundEmitted(obj):
	if player_is_around:
		print("it heard %s.."%obj)
		beast.nav.target_position = obj.global_transform.origin
		beast.stateMachine.current_state.Transitioned.emit(beast.stateMachine.current_state, "Chase")

func body_entered_far(body):
	if body is Player:
		player_is_around = true

func body_exited_far(body):
	if body is Player:
		player_is_around = false
