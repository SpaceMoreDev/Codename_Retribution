extends State
class_name Chase

@export var speed : float = 2
var player : CharacterBody3D
@export var enemy : CharacterBody3D
@export var stuckRay : RayCast3D
var detection : Detection
@export var area : Area3D

var push_power = 10
var inarea = false
var timer : float = 1

func _ready():
	detection = enemy.detection
	enemy.nav.connect("navigation_finished", navigation_finished)
	area.connect("body_entered", body_entered)
	area.connect("body_exited", body_exited)

func Enter():
	player = Global._get_player()
	enemy.canMove = true
	enemy.move_speed = speed

func Exit():
	enemy.move_speed = enemy.MOVE_SPEED

func Physics_Update(delta : float):
	if not inarea:	
		if stuckRay.is_colliding():
			enemy.canMove = false
			Transitioned.emit(self, "Stuck")
			print("transitioned to Stuck")


func Update(delta):
	if inarea:
		if timer > 0:
			timer -= delta
		else:
			if detection.checkRays():
				DamagePlayer(20)
			timer = 1	

func DamagePlayer(damage):
	# [add animation for attack here]
	player.stats.Health -= damage
	var a = player.global_transform.origin
	var b = enemy.global_transform.origin
	player.velocity = (a-b) * push_power
	
func navigation_finished():
	if (get_parent() as StateMachine).current_state == self:
		if not inarea:
			Transitioned.emit(self, "Idle")
			print("transitioned to Idle")

func body_entered(body):
	if body is Player:
		print("player In")
		inarea = true
		enemy.seeingPlayer = true
		DamagePlayer(30)


func body_exited(body):
	if body is Player:
		inarea = false
		print("player Out")
