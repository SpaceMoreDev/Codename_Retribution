extends Area3D

@export var character:Character
var scene = preload("res://Scenes/Packed/DialogueSystem/dialogue_system.tscn")
var dialogue_instance

func _ready():
	# Connect the body_entered signal to a method
	connect("body_entered", on_body_entered)
#	connect("body_exited", on_body_exited)




func on_body_entered(body):
	if body.is_in_group("Player"):
		dialogue_instance = scene.instantiate()
		get_parent().add_child(dialogue_instance)
		dialogue_instance.set_dialogue_char(character)
		#dialogue_instance.start_dialogue("im about to cum")


func on_body_exited(body):
	if body.is_in_group("Player"):
		dialogue_instance.queue_free()
