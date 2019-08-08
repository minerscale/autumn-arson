extends CanvasModulate
# Handles fading in and out.

func _ready():
	# Fade in.
	begin_fade(1)

# The target colour we want to get to
var target = 0

# The current colour (used internally)
var current = 0
# This function *probably* isn't nessesary.
# It will be easier if I go to change the behaviour however.
func begin_fade(colour):
	target = colour

func _process(delta):
	# Use fancy formula to interpolate between the target and the current.
	current += (3*delta)*(target-current)
	# This is my favorite line in the whole codebase
	set_color(Color(current,current,current))
	# Set the canvas modulate in the ParallaxBackground, they're seperate canvas layers!
	get_node("../ParallaxBackground/CanvasModulate").set_color(Color(current,current,current))
