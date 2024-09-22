extends State
class_name Hurt

@export var wait : float = 1
var temp : float
var player : Player
@export var beast : Beast

func _ready():
	player = Global._get_player()
	temp = wait
	#beast.nav.connect("navigation_finished", navigation_finished)

func Enter():
	beast.Head_IK.influence = 0
	beast.animation.set("parameters/conditions/Hit", true)
	await get_tree().create_timer(0.1).timeout
	beast.animation.set("parameters/conditions/Hit", false)
	beast.animation.set("parameters/conditions/isWalk", false)
	beast.canMove = false


func Update(delta):
	if wait > 0:
		wait -= delta
	else:
		#if beast.detection.checkStuck():
			#check()
		#elif beast.detection.checkRays():
		beast.gothit = false
		beast.canMove = true
		beast.IKcontrol.Activate()
		Transitioned.emit(self, "Idle")
		print("Hurt -> Idle")
			
		wait = temp
	
func check():
	beast.nav.target_position = beast.global_position - Vector3(0,0,5)

#func navigation_finished():
	#if (get_parent() as StateMachine).current_state == self:
		#if beast.detection.checkRays():
			#Transitioned.emit(self, "Chase")
			#print("Stuck -> Chase")
		#else:
			#Transitioned.emit(self, "Idle")
			#print("Stuck -> Idle")
