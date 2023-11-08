extends Node3D

var action : PlayerAction
var inventory : Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	action = Global._get_player().playerAction
	inventory = Global._get_player().inventory
	action.connect("start_interaction", TakeObject)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func TakeObject(obj : Node3D):
	if(obj.get_parent() == get_parent()):
		inventory.AddToInventory(obj.get_parent())
		get_parent().queue_free()
