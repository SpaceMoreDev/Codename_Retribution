extends Node
class_name Detection

@onready var player = Global._get_player()
@onready var farArea : Area3D= $Far
@onready var nearArea : Area3D = $Near

var beast : Beast

func _ready():
    beast = get_parent() as Beast
    farArea.connect("body_entered", RangeFar)
    farArea.connect("body_exited", OutOfRangeFar)
    nearArea.connect("body_entered", RangeNear)

func RangeFar(body):
    if body is Player:
        print("player is far")
        beast.Set_Target_Location(player.global_transform.origin)
        

func OutOfRangeFar(body):
    if body is Player:
        print("player is no longer in range")
        beast.active = false

func RangeNear(body):
    if body is Player:
        print("player is near")
        beast.active = true
        