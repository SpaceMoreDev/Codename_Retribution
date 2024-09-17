extends Node

var cutscenes : Array[Cutscene] = []
@export var no_cutscenes : bool = false
@export var skip_to_scene: int = 0


func _ready() -> void:
	for i : Cutscene in get_children():
			cutscenes.append(i)
			i.scene_animation.active = false
			i.player_animation.active = false
	if not no_cutscenes:
		cutscenes[skip_to_scene].scene_animation.active = true
		cutscenes[skip_to_scene].player_animation.active = true
		cutscenes[skip_to_scene].start_cutscene()
	else:
		Global._get_player().position = Vector3(0,1,0)
		Global._get_player().rotation = Vector3(0,0,0)
		Global._get_player().active = true
		Global.incutscene = false
	
