extends Node3D

@onready var camera_3d = $Camera3D
var mouse_sensitivity = 0.3
@onready var camera_rig = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_3d.global_transform = GameManager.player.camera_point.global_transform
	
	
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("right_click"):
		GameManager.player.camera_center.rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity))

