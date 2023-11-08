extends Node
class_name NoiseControl

signal  VoiceChanged(vol)
signal  LoudSound(obj)
@export var source:Node3D
var beast : Beast

var volume : float :
	set(value):
		value = clamp(value,0,100)
		volume = value
		emit_signal("VoiceChanged", volume)

func _ready():
	beast = Global._get_beast()
	connect("VoiceChanged", VolumeChanged)
	connect("LoudSound", beast.detection.LoudSoundEmitted)

func VolumeChanged(vol):
	if(volume == 100):
		emit_signal("LoudSound", source)
		print("made a sound")
