extends State
class_name Stuck

@export var ray : RayCast3D

@warning_ignore("unused_parameter")
func Physics_Update(delta):
    if not ray.is_colliding():
        await  get_tree().create_timer(2).timeout
        Transitioned.emit(self,"Chase")
        print("continuing the chase")