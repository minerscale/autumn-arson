extends AnimatedSprite

# Short script that makes the player locked to a 4x4px grid.
# Makes it look more '8bit'

func _physics_process(delta):
	var parent_position =  get_parent().get_position()
	set_global_position(4*Vector2(floor(parent_position.x/4),floor(parent_position.y/4)))
