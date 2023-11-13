extends State
class_name Stuck

@export var ray : RayCast3D
@export var wait : float = 1

var player : Player
var beast : Beast

func _ready():
	beast = Global._get_beast()
	player = Global._get_player()
	beast.nav.connect("navigation_finished", navigation_finished)

func Enter():
	beast.canMove = true

func Update(delta):
	if wait > 0:
		wait -= delta
	else:
		if beast.detection.checkStuck():
			check()
		elif beast.detection.checkRays():
			Transitioned.emit(self, "Chase")
			print("Stuck -> Chase")
			
		wait = 1
	
func check():
	beast.nav.target_position = beast.global_position - Vector3(0,0,5)

func navigation_finished():
	if (get_parent() as StateMachine).current_state == self:
		if beast.detection.checkRays():
			Transitioned.emit(self, "Chase")
			print("Stuck -> Chase")
		else:
			Transitioned.emit(self, "Idle")
			print("Stuck -> Idle")
