extends CharacterBody2D

@export var move_speed : float = 30.0
@export var move_dir: Vector2

var start_pos : Vector2
var target_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	target_pos = start_pos + move_dir
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	var direction = (target_pos - global_position).normalized()	
	var collision_info = move_and_collide(direction * move_speed * delta)
	if collision_info:
		#print("collided with: ", collision_info.get_collider_id())
		pass
	
	if global_position.distance_to(target_pos) < 10:
		if global_position.distance_to(start_pos) < 10:
			#print("Going to target")
			target_pos = start_pos + move_dir
		else:
			#print("Going to start")
			target_pos = start_pos
	pass


func _on_body_entered(body):
	if body.is_in_group("BouncingCube"):
		body.collided()
	pass # Replace with function body.
