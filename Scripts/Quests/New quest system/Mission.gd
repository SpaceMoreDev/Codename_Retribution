extends Node
class_name  Mission

signal MissionCompleted

var MissionTitle : String
var missionCompleted : bool

func _init():
	MissionTitle = "Placeholder Mission"
	missionCompleted = false
	MissionCompleted.connect(CompleteMission)

func CompleteMission():
	missionCompleted = true

func _process(delta):
	Update(delta)

func Update(delta):
	pass

func IsCompleted() -> bool:
	return missionCompleted
