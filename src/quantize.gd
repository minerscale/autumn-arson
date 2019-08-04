extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent_position =  get_parent().get_position()
	set_global_position(4*Vector2(round(parent_position.x/4),round(parent_position.y/4)))
