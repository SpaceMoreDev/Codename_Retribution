extends Door

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var Input_x : float = 0.0
var data
var dead_zone : float = 1
var pull_power = 150
var action
var player : Player
var grab_position


var inputs

# Variables to control the door movement
@export var max_angular_velocity: float = 5.0 # Maximum angular speed the door can rotate
@export var sensitivity: float = 0.5 # Sensitivity to mouse dragging
@export var stop_threshold: float = 1.0 # Angle threshold to consider the door "stopped"
@export var closing_delay: float = 3.0 # Delay before the door starts closing
@export var closing_axis: float = 1
@export var DetectArea : DoorIK

# The camera node, set this to the player's camera in the editor
var camera

# To track if the player is dragging the mouse
var is_dragging = false
var should_close = false
# Variable to store the initial relative offset between the player and the door
var initial_offset_from_door: Vector3

# Timer for closing delay
var close_timer: Timer

# PID Controller parameters
@export var pid_p: float = 0.1 # Proportional gain
@export var pid_i: float = 0.01 # Integral gain
@export var pid_d: float = 0.05 # Derivative gain
@export var target_y_rotation: float = 0.0 # Target Y-axis rotation angle for closed position

# PID control variables
var pid_integral: float = 0.0
var previous_error: float = 0.0

func _ready():
	player = Global._get_player()
	camera = player.playerCamera
	action = player.playerAction
	grab_position = action.grab_position

	# Initialize and start the timer
	close_timer = Timer.new()
	close_timer.wait_time = closing_delay
	close_timer.one_shot = true
	close_timer.connect("timeout", _on_close_timer_timeout)
	add_child(close_timer)
	
	action.connect("start_interaction", InteractWithDoor)
	action.connect("end_interaction", remove_object)
	
	player.playerInput.connect("MouseMotion", DragInput)
	player.playerInput.connect("JoyMotion", DragInput)

func remove_object():
	if data != null:
		data = null
		player.end_R_IK()
		player._auto_direction = Vector3.ZERO
		is_dragging = false
		# Stop the timer if it was running
		close_timer.stop()
		# Check if the door is nearly closed
		if abs($body.rotation_degrees.y - target_y_rotation) < 20:
			# Close immediately if the door is nearly closed
			should_close = true
		else:
			# Start the timer for closing the door
			#close_timer.start()
			pass
		player.playerCamera.locked = false

func InteractWithDoor(door: Node3D):
	if door == $body:
		if DetectArea.can_open_door:
			player.start_R_IK(DetectArea.IK_target)
			player.playerCamera.locked = true
			if not is_locked:
				data = door
				is_dragging = true
				should_close = false
				Input_x = 0.0
				
				# Store the initial offset between the player and the door
				initial_offset_from_door = player.global_transform.origin - $body.global_transform.origin
			else:
				print("Door is locked")

func DragInput(axis: Vector2):
	
	if data != null and is_dragging:
		handle_mouse_drag(axis.x)
 
func handle_mouse_drag(mouse_delta_x: float):
	# Get the door's position and the camera's position
	var door_position = $body.global_transform.origin
	var camera_position = camera.global_transform.origin

	# Calculate the direction from the camera to the door
	var camera_to_door = (door_position - camera_position).normalized()

	# Determine if the hinges are to the left or right relative to the camera
	var hinge_side = sign(door_position.cross(camera_to_door).z)

	# Determine the drag direction based on hinge side and mouse movement
	var drag_direction = mouse_delta_x

	if hinge_side > 0:
		# Hinge on the right
		print("Hinge on the right")
		drag_direction = -mouse_delta_x
	else:
		# Hinge on the left
		print("Hinge on the left")
		drag_direction = -mouse_delta_x

	#if abs(mouse_delta_x) > 0.1:
		#var push = drag_direction
		#if hinge_side > 0:
			#push = -drag_direction
#
		#
#
		## Update player's position based on the door's rotation to maintain relative position
		#var new_relative_position = $body.global_transform.basis * initial_offset_from_door
		#var spot = $body.global_transform.origin + new_relative_position
		#player._auto_direction = (spot - player.position).normalized() * push * 0.2
	#else:
		#player._auto_direction = Vector3.ZERO

	# Apply sensitivity and clamp the angular velocity
	var angular_velocity = clamp(drag_direction * sensitivity, -max_angular_velocity, max_angular_velocity)

	# Apply the angular velocity around the hinge axis (Y-axis in local space)
	$body.angular_velocity = Vector3(0, angular_velocity, 0)

func apply_pid_control(delta: float):
	# Get the current Y-axis rotation angle in degrees
	var current_y_rotation = $body.rotation_degrees.y

	# Calculate the error (how far the current angle is from the target angle)
	var error = target_y_rotation - current_y_rotation

	# Proportional term
	var p_term = pid_p * error

	# Integral term (accumulates error over time)
	pid_integral += error * delta
	var i_term = pid_i * pid_integral

	# Derivative term (rate of change of error)
	var d_term = pid_d * (error - previous_error) / delta
	previous_error = error

	# Calculate total PID output
	var pid_output = p_term + i_term + d_term

	# Apply the torque around the hinge axis (Y-axis)
	# Make sure to apply a reasonable torque value
	var torque = clamp(pid_output, -max_angular_velocity, max_angular_velocity)
	
	# Check if the door is within the threshold and stop applying torque if close enough
	if abs(error) < stop_threshold:
		$body.angular_velocity = Vector3(0, 0, 0)
		pid_integral = 0 
		previous_error = 0 
	else:
		$body.apply_torque(Vector3(0, torque, 0))

func _process(delta: float):
	if not is_dragging and (should_close or abs($body.rotation_degrees.y - target_y_rotation) < 20):
		apply_pid_control(delta)

func _on_close_timer_timeout():
	should_close = true


func _on_detect_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
