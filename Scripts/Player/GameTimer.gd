extends Node

var timerLabel : Label
var gameTime = 0


func _enter_tree():
	timerLabel = $TimerLabel
	gameTime = 0

func _process(delta):
	gameTime += delta
	timerLabel.text = "%.2f"%(gameTime)
