extends KinematicBody2D

# Declare member variables here. Examples:
export var gravity = 1000
export var terminal_velocity = 1600
export var jump_vel = 400
export var x_speed = 220

var velocity = Vector2(0,0)
var timer_max = 1
var timer = timer_max
var dead = false
var win = false

var attacking = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!dead):
		# The next 40 or so lines are almost entirely didicated aesthetics, it is an absolute shitshow.
		# Abandon all hope ye who enter here, that said:
		if (Input.is_action_pressed("left") and not Input.is_action_pressed("right")):
			# Move left
			velocity.x = -x_speed
			# Flip the sprites around so they face the right direction
			get_node("./Sprite").set_scale(Vector2(-1,1))
			get_node("./fire").set_scale(Vector2(-1,1))
			get_node("./fire").set_position(Vector2(4,0))
		elif (Input.is_action_pressed("right") and not Input.is_action_pressed("left")):
			# Do the same but for right
			velocity.x = x_speed
			get_node("./Sprite").set_scale(Vector2(1,1))
			get_node("./fire").set_scale(Vector2(1,1))
			get_node("./fire").set_position(Vector2(0,0))
		else:
			# If we aren't pressing differnt keys, arrest the velocity in the x direction
			velocity.x = 0
		if (is_on_floor() or is_on_ceiling()):
			# Stop when we hit the roof or the ground
			velocity.y = 0
		
		if (Input.is_action_just_pressed("jump") and is_on_floor()):
			velocity.y = -jump_vel
			# Play the jump sound
			get_node("AudioStreamPlayer").play()
		# Interesting mechanic, but it makes jumping feel much more controllable
		if (Input.is_action_just_released("jump") and velocity.y < 0):
			velocity.y = 0

		if !is_on_floor():
			# Play the in air animation if we're not on the ground
			if get_node("Sprite").get_animation() != "air":
				get_node("Sprite").play("air")
		# If we aren't pressing EXCLUSIVELY left or right
		elif (is_on_floor() and (Input.is_action_pressed("left") != Input.is_action_pressed("right"))):
			if get_node("Sprite").get_animation() != "walk":
				get_node("Sprite").play("walk")
		# A lot of convoluted conditions that make us go back to default state.
		elif (!(get_node("Sprite").get_animation() in ["attack-start", "attack-middle", "attack-end"]) and
				is_on_floor() and Input.is_action_pressed("left") == Input.is_action_pressed("right")):
				get_node("Sprite").play("default")
		# Make the fire <3
		if (Input.is_action_just_pressed("attack")):
			$fire.play("attack-start")
			if get_node("Sprite").get_animation() == "default":
				get_node("Sprite").play("attack-start")
		# Make the fire loop
		if (Input.is_action_pressed("attack")):
			$fire/killbox/killshape.disabled = false
			if $fire.get_animation() == "attack-start" and $fire.get_frame() == 4:
				$fire.play("attack-middle")
		else:
			# Change the hitbox so it can't kill enemies anymore
			$fire/killbox/killshape.disabled = true
		
		# Convoluted attack animation stopping mechanics
		if (Input.is_action_just_released("attack")):
			if $fire.get_animation() in ["attack-start", "attack-middle"]:
				$fire.play("attack-end")
			if (get_node("Sprite").get_animation() in ["attack-start", "attack-middle"]):
				get_node("Sprite").play("attack-end")
		
		
		if (get_node("Sprite").get_animation() == "attack-end" and get_node("Sprite").get_frame() == 2):
			get_node("Sprite").play("default")
		
		# Killplane
		if (get_position().y >= 1200):
			dead = true
			# Fade to black
			get_node("../CanvasModulate").begin_fade(0)
		
		# Look mum! More physics!
		# Constant acceleration (look mum, no calculus!)
		var acceleraton = Vector2(0,gravity) # 2nd derivative
		
		# v = at
		velocity += delta*acceleraton # 1st derivative
		velocity.y = min(velocity.y, terminal_velocity)
		
		# actually move the player
		# s = vt - 0.5at^2 (close cousin of s = ut + 0.5at^2)
		move_and_slide((delta*velocity - 0.5*acceleraton*(pow(delta,2)))/delta, Vector2(0,-1))
		
		# Have we just won or died? Cool!
		for i in $Area2D.get_overlapping_areas():
			if i.is_in_group('enemy'):
				dead = true
				get_node("../CanvasModulate").begin_fade(0)
			if i.is_in_group('nutt'):
				dead = true
				win = true
				get_node("../CanvasModulate").begin_fade(0)
	else:
		# So we are dead (or just won!). Wait 'till the fade to black finishes and then finish up
		timer -= delta
		if timer <= 0:
			if win:
				get_tree().change_scene("res://scn/win.tscn")
			else:
				get_tree().reload_current_scene()
