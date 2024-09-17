extends Cutscene

@export var canvas : CanvasLayer
@export var wood : Node3D
@export var progress : ProgressBar
var ispushing = false


func start_cutscene():
	Global._get_player().active = false
	Global.incutscene = true
	scene_animation.connect("animation_finished", intro_done)

func intro_done(name):
	if name == "Intro_sequence":
		ispushing = true
		player_animation.set("parameters/conditions/isPushing", ispushing)
	elif name == "Intro_done":
		scene_animation.active =false
		player_animation.active =false
		wood.visible = false
		Global.incutscene = false
		Global._get_player().active = true
		

func player_anim_done() -> bool:
	if  player_animation.get("parameters/Pushing/blend_position") >= 1:
		scene_animation.set("parameters/conditions/Pushed", true)
		player_animation.set("parameters/conditions/Intro_done", true)
		ispushing = false
		return true
	return false

func _physics_process(delta: float) -> void:
	if ispushing:
		var val = player_animation.get("parameters/Pushing/blend_position")
		progress.value = val * 100
		#print(val)
		if not player_anim_done() and val > 0:
			var new_val = val - delta * .2
			player_animation.set("parameters/Pushing/blend_position", new_val)
		if Input.is_action_just_pressed("JUMP"):
			player_animation.set("parameters/Pushing/blend_position", val + .05)
