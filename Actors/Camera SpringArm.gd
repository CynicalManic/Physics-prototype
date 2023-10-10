extends SpringArm3D

var mouse_sensitivity = 0.002

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("left_click"):
		rotate_y(-event.relative.x * mouse_sensitivity)


func reset_camera_rotation():
	rotation.y = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	#self.rotate_y(0.01)
	pass
