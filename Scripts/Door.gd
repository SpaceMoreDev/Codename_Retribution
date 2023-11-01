extends Node

class_name Door

var key : DoorKey
var questID : int

var hasquest: bool = false

var locked : bool = false

var opened : bool = false


func Lock(state : bool) -> void:
    locked = state

func Complete(obj,id):
    if(obj.get_parent() == get_parent()):
        Global.questList.CompleteQuest(id)
        print("%s Quest Completed!"%id)