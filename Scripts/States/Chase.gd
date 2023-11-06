extends State
class_name Chase

@export var speed : float = 3
var player : CharacterBody3D
@export var enemy : CharacterBody3D

func _ready():
	enemy.nav.connect("navigation_finished", navigation_finished)

func Enter():
	player = Global._get_player()
	enemy.move_speed = speed

func Exit():
	enemy.move_speed = enemy.MOVE_SPEED

func Physics_Update(delta : float):
	if (get_parent() as StateMachine).current_state == self:
		var direction = player.global_position - enemy.global_position

		if direction.length() > 1 and direction.length() < 5:	
			enemy.nav.target_position = player.global_transform.origin
		else:
			enemy.velocity = Vector3.ZERO

func navigation_finished():
	if (get_parent() as StateMachine).current_state == self:
		Transitioned.emit(self, "Idle")
		print("transitioned to Idle")
