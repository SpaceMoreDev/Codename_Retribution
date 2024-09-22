extends State
class_name Stalk

@export var wait : float = 1
var temp : float
var player : Player
@export var beast : Beast

func _ready():
	player = Global._get_player()
	temp = wait
	#beast.nav.connect("navigation_finished", navigation_finished)

func Enter():
	pass


func Update(delta):
	pass
	
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
