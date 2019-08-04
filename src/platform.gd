extends AnimatedSprite

var crumbling = false
export var timer = 2;
var last_timer = 2;
func _physics_process(delta):
	if (get_animation() == "step" and get_frame() == 6):
		set_animation("idle")
	if crumbling:
		timer -= delta
	
	if timer <= 0 and last_timer > 0:
		set_animation("crumble")
	if (get_animation() == "crumble" and get_frame() == 11):
		get_parent().get_node("./floating/CollisionShape2D").disabled = true
	elif (get_animation() == "crumble" and get_frame() == 16):
		get_parent().queue_free()

func _on_Area2D_body_entered(body):
	if (get_animation() == "idle"):
		set_animation("step")
		crumbling = true
