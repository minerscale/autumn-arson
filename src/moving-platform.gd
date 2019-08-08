extends Node2D

# Tweakable values so we can accurately control the behavior
export var distance = 128
export var speed = 32

# x offset from the initial position (the position in the editor)
var xpos = 0
# Global x position from initial position
var init_xpos

# The time it takes to move from one side to another
var time
# Literally the current time since the object was created
var cur_time = 0

# Called once on startup
func _ready():
	init_xpos = get_position().x
	# By s = d/t (Look mum! I'm using physics!)
	time = float(distance)/speed

# Called once per frame
func _process(delta):
	cur_time += delta
	var direction = -(floor(fmod(cur_time/time,2))*2 - 1)
	xpos += direction*4*speed*delta
	set_position(Vector2(init_xpos+xpos,get_position().y))
