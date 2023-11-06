extends State
class_name Idle

var player : CharacterBody3D
@export var enemy : CharacterBody3D
@export var wander_max_time : float = 5
@export var wait_time : float = 1

var move_dir : Vector3
var wander_time : float


func randomize_wander():


	move_dir = Vector3(randf_range(-1,1), 0 , randf_range(-1,1)).normalized()
	wander_time = randf_range(1,wander_max_time)
	
	enemy.canMove = false
	enemy.nav.set_velocity(Vector3.ZERO)
	await get_tree().create_timer(wait_time).timeout
	
	var new_dest = move_dir * (wander_time + 2)
	enemy.nav.target_position = enemy.global_position + new_dest
	enemy.canMove = true

func Enter():
	player = Global._get_player()
	enemy.move_speed = enemy.MOVE_SPEED
	

func Update(delta:float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		


func Physics_Update(delta : float):
	
	var player_direction = player.global_position - enemy.global_position

	if player_direction.length() < 5:
		Transitioned.emit(self, "Chase")
		print("transitioned to Chase")


# func navigation_finished():
# 	if (get_parent() as StateMachine).current_state == self:
# 		var new_dest = move_dir * 5
# 		enemy.nav.target_position = enemy.global_position + new_dest
