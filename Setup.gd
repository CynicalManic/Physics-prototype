extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	setupBouncyCubes()
	pass # Replace with function body.

func setupBouncyCubes():
	var cube1 = get_node("Cube1")
	var cube2 = get_node("Cube2")
	var cube3 = get_node("Cube3")
	

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bouncing_cube_1_body_entered(body):
	pass # Replace with function body.
