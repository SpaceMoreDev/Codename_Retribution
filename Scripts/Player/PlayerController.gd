extends CharacterBody3D
class_name Player

# Player stats like health, stamina and form
@export var Stats : PlayerStats

#movement variables
var _input : Vector2 = Vector2.ZERO
var Speed : float = 5.0
var Jump_Speed : float = 6.0
var canJump : bool  = true
var original_gravity = 10.9
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


const WALK_SPEED = 2.5
const SPRINT_SPEED = 4.5

func _ready():
	Speed = WALK_SPEED

func Jump():
	if(canJump and Input.is_action_just_pressed("JUMP") and is_on_floor()):
		velocity.y = Jump_Speed

func Move(delta):
	var direction = transform.basis * Vector3(_input.x, 0 , _input.y).normalized()

	if(not is_on_floor()):
		velocity.y -= _gravity * delta
	Jump()

	if(is_on_floor()):
		if(direction):
			velocity.x = direction.x * Speed
			velocity.z = direction.z * Speed
		else:
			velocity.x = lerp(velocity.x, direction.x * Speed, delta * 6.5)
			velocity.z = lerp(velocity.z, direction.z * Speed, delta * 6.5)
	else:
		velocity.x = lerp(velocity.x, direction.x * Speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * Speed, delta * 3.0)

	move_and_slide()


@warning_ignore("unused_parameter")
func _process(delta):
	_input = Input.get_vector("LEFT","RIGHT","UP","DOWN")

	if(Input.is_action_just_pressed("RUN")):
		Speed = SPRINT_SPEED
	elif(Input.is_action_just_released("RUN")):
		Speed = WALK_SPEED

func _physics_process(delta):
	Move(delta)
