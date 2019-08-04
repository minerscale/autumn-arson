extends KinematicBody2D

# Declare member variables here. Examples:
export var gravity = 600
export var terminal_velocity = 1600
export var jump_vel = 200
export var x_speed = 200

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Input.is_action_pressed("left") and not Input.is_action_pressed("right")):
		velocity.x = -x_speed
		get_node("./Sprite").set_scale(Vector2(-1,1))
	elif (Input.is_action_pressed("right") and not Input.is_action_pressed("left")):
		velocity.x = x_speed
		get_node("./Sprite").set_scale(Vector2(1,1))
	else:
		velocity.x = 0
	if (is_on_floor() or is_on_ceiling()):
		velocity.y = 0
		
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = -jump_vel
	if (Input.is_action_just_released("jump") and velocity.y < 0):
		velocity.y = 0
	
	var acceleraton = Vector2(0,gravity) # 2nd derivative
	velocity += delta*acceleraton
	velocity.y = min(velocity.y, terminal_velocity)
	
	move_and_slide((delta*velocity - 0.5*acceleraton*(pow(delta,2)))/delta, Vector2(0,-1))
	