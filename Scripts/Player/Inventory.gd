extends Node
class_name Inventory


@export var textLabel : RichTextLabel
@export var hand : Node3D
@export var throw_force : float

var inventory : Dictionary = {}
var itemIndex : int = 0


@warning_ignore("unused_parameter")
func AddToInventory(object):
	if inventory.has(object.Get_type()):
		inventory[object.Get_type()] += 1 
	else:
		inventory[object.Get_type()] = 1 
		
	showDic()

func Use(key):
	if inventory.size() == 0 or key > inventory.size()-1:
		return
	
	
	var itemkey = inventory.keys()[key]
	if inventory[itemkey]:
		
		print("Used %s"%itemkey)
		# will add more types
		var obj
		if(itemkey == "OilBottle"):
			obj = Global.oilBottlePrefab.instantiate()
			add_child(obj)
			obj.global_position = hand.global_position
			obj.global_rotation = hand.global_rotation
			obj.Use(throw_force)
		elif(itemkey == "Molotov"):
			obj = Global.molotovBottlePrefab.instantiate()
			add_child(obj)
			obj.global_position = hand.global_position
			obj.global_rotation = hand.global_rotation
			obj.Use(throw_force)
		elif (itemkey == "Health"):
			if Global._get_player().stats.Health == 100:
				print("health is full")
				return
			obj = Global.healthPotionPrefab.instantiate()
			add_child(obj)
			obj.Use(10)
			obj.queue_free()

		
		
		inventory[itemkey] -= 1
		
		if inventory[itemkey] == 0:
			inventory.erase(itemkey)
			if itemIndex > 0:
				itemIndex -= 1
			
		
		
	else:
		print("didnt find %s"%itemkey)
	
	showDic()
	

func showDic():
	print("index: %s"%itemIndex)

	textLabel.text = ""
	if inventory.size() > 0:
		var itemkey = inventory.keys()[itemIndex]
		
		for i in inventory:
			if itemkey == i:
				textLabel.text += "[b][%s - %s][/b] \n" %[i, inventory[i]]
			else:
				textLabel.text += "[%s - %s] \n" %[i, inventory[i]]
	else:
		itemIndex = 0


@warning_ignore("unused_parameter")
func _process(delta):
	if(not Input.is_action_pressed("INTERACT")):
		if Input.is_action_just_pressed("AIM"):
			Use(itemIndex)

		if Input.is_action_just_released("SCROLL_UP"):
			if itemIndex > 0:
				itemIndex -= 1
				showDic()
		elif Input.is_action_just_released("SCROLL_DOWN"):
			if itemIndex < inventory.size()-1:
				itemIndex += 1
				showDic()
