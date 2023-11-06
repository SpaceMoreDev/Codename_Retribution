extends State
class_name Idle

@export var enemy : CharacterBody3D
@export var speed : float
var player : CharacterBody3D

var move_dir : Vector3
var wander_time : float

func randomize_wander():
    move_dir = Vector3(randf_range(-1,1), 0 , randf_range(-1,1)).normalized()
    wander_time = randf_range(1,3)

func Enter():
    player = Global._get_player()
    randomize_wander()

func Update(delta:float):
    if wander_time > 0:
        wander_time -= delta
    else:
        randomize_wander()

func Physics_Update(delta : float):
    if enemy:
        enemy.velocity = move_dir * speed
    
    var player_direction = player.global_position - enemy.global_position
    if player_direction.length() < 5:
        Transitioned.emit(self, "Chase")
        print("transitioned to Chase")

