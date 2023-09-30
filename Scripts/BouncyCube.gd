extends CharacterBody2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var randomX: float
var randomY: float

@export var rotationSpeed: float
#@export var move_speed: float = 30.0
@export var starting_velocity =  Vector2(0,0)
@export var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	velocity = starting_velocity
			

	#randomPlacement()
	pass # Replace with function body.

func _draw():
	#print("Drawing circle at: ", randomX,", ", randomY)
	pass

	
	
func randomPlacement() -> void:
	randomX = rng.randf_range(0.0, get_viewport().get_visible_rect().size.x - 100)
	randomY = rng.randf_range(0.0, get_viewport().get_visible_rect().size.y - 100)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#global_position = global_position.move_toward(global_position + velocity, move_speed * delta)	
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		#print("collided with: ", collision_info.get_collider_id())
		velocity = velocity.bounce(collision_info.get_normal())

	velocity = velocity.rotated(deg_to_rad(rotationSpeed))
	
	queue_redraw()
	
	pass
	
