extends Node
class_name NoiseControl

signal  VoiceChanged(vol)
signal  LoudSound(obj)
@export var source:Node3D
@export var soundIcon : Node
var beasts : Array[Beast]

var volume : float :
	set(value):
		if Global.useNoise:
			value = clamp(value,0,100)
			volume = value
				
			emit_signal("VoiceChanged", volume)

func _ready():
	beasts = Global._get_beast()
	connect("VoiceChanged", VolumeChanged)
	for i in beasts:
		connect("LoudSound", i.detection.LoudSoundEmitted)

func VolumeChanged(vol):
	if(vol == 100):
		emit_signal("LoudSound", source)
	
	if soundIcon:
		if(vol == 100):
			soundIcon.modulate = Color.RED
		else:
			soundIcon.modulate = Color.WHITE

		var alphaVal = (volume/100) * 255
		soundIcon.modulate.a = alphaVal/255
