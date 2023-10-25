extends Node
class_name HeadBobbing
@export var camera : Camera3D

#head bob
@export var _frequency = 3
@export var _amplitude = 0.08
var crouching = false
var acceleration : float = 5
var t_bob = 0.0

func _physics_process(delta):
    if(not camera.locked and not crouching):
        t_bob += delta * get_parent().velocity.length() * float(get_parent().is_on_floor())
        var headbobbing = lerp(camera.transform.origin, head_bobbing(t_bob), delta * acceleration)
        camera.transform.origin = headbobbing
        camera.rotation.z = lerp(camera.rotation.z, 0.0, delta * acceleration)


func head_bobbing(time)->Vector3:
    var pos = Vector3.ZERO
    pos.y = sin(time *_frequency) * _amplitude
    pos.x = cos(time *_frequency/2) * _amplitude
    return pos