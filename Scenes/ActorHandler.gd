extends Node3D

#@onready var player = get_owner().get_node("Character")
@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin)
	
	
	
	pass

func PlayerMoveTarget(target_location):
	player.update_target_location(target_location)
	pass
	
func _input(event):
	if event is InputEventMouseButton and Input.is_action_pressed("left_click"):
		var camera = get_viewport().get_camera_3d()
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 100
		var cursorPos = Plane(Vector3.UP, transform.origin.y).intersects_ray(from, to)
		print(cursorPos)
		PlayerMoveTarget(cursorPos)
