extends Node3D

class_name Fire

@export var flames : GPUParticles3D
@export var smoke : GPUParticles3D
@export var isactive : bool = false

func _ready():
    Fire_State(isactive)


func Fire_State(state : bool) -> void:
    flames.emitting = state
    smoke.emitting = state
    isactive = state
    visible = state 