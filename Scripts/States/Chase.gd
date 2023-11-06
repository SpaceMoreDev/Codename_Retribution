extends State
class_name Chase

@export var enemy : CharacterBody3D
@export var move_speed : float = 30.0
var player : CharacterBody3D


func Enter():
	player = Global._get_player()

func Physics_Update(delta : float):
	var direction = player.global_position - enemy.global_position

	if direction.length() > 1:
		enemy.velocity = direction.normalized() * move_speed
		enemy.look_at(player.position, Vector3.UP)
		# enemy.rotate_y(deg_to_rad(enemy.faceDir.rotation.y * enemy.turn_speed))
	else:
		enemy.velocity = Vector3.ZERO
	
	if direction.length() > 5:
		Transitioned.emit(self, "Idle")
		print("transitioned to Idle")

	
