extends Node

var cutscenes : Array[Cutscene] = []

func _ready() -> void:
	for i : Cutscene in get_children():
		print(i.name)
		cutscenes.append(i)
	cutscenes[0].start_cutscene()
