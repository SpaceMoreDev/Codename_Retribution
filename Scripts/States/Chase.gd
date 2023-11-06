extends State
class_name Chase

@export var speed : float = 3
var player : CharacterBody3D
@export var enemy : CharacterBody3D
@export var ray : RayCast3D
@export var area : Area3D

var push_power = 10
var inarea = false
var timer : float = 1

func _ready():
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
	if (get_parent() as StateMachine).current_state == self:
		var direction = player.global_position - enemy.global_position
		if not inarea:
			if direction.length() > 1 and direction.length() < 5:	
				enemy.nav.target_position = player.global_transform.origin
			else:
				enemy.nav.set_velocity(Vector3.ZERO)
				if ray.is_colliding():
					enemy.canMove = false
					Transitioned.emit(self, "Stuck")
					print("transitioned to Stuck")

func navigation_finished():
	if (get_parent() as StateMachine).current_state == self:
		var dir = player.global_position - enemy.global_position
		if dir.length() > 2:
			Transitioned.emit(self, "Idle")
			print("transitioned to Idle")
		else:
			if not inarea:
				DamagePlayer(20)

func Update(delta):
	if inarea:
		if timer > 0:
			timer -= delta
		else:
			inarea = false
			timer = 1	

func DamagePlayer(damage):
	# [add animation for attack here]
	player.Stats.Health -= damage
	var a = player.global_transform.origin
	var b = enemy.global_transform.origin
	player.velocity = (a-b) * push_power
	
	

func body_entered(body):
	if body is Player:
		inarea = true
		enemy.seeingPlayer = true
		DamagePlayer(30)
	
	if body is RigidBody3D:
		print("balls")
		var a = body.global_transform.origin
		var b = enemy.global_transform.origin
		body.add_constant_force((a-b) *80)


func body_exited(body):
	if body is Player:
		inarea = false
