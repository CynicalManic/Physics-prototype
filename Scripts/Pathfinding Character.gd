extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):		
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	velocity = new_velocity
	move_and_slide()
	
	AnimationHandler()

func AnimationHandler():
	# Check if moving
	if(velocity == Vector3.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walking"] = false
		animation_tree["parameters/conditions/sprinting"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		if (Input.is_action_pressed("Sprint")):
			animation_tree["parameters/conditions/sprinting"] = true
			animation_tree["parameters/conditions/walking"] = false
		else:			
			animation_tree["parameters/conditions/walking"] = true
			animation_tree["parameters/conditions/sprinting"] = false	
		
	# Check if on floor
	if (is_on_floor()):
		animation_tree["parameters/conditions/is_on_floor"] = true
		animation_tree["parameters/conditions/falling"] = false
	else:
		animation_tree["parameters/conditions/is_on_floor"] = false
		if(Input.is_action_pressed("jump")):
			animation_tree["parameters/conditions/jumping"] = true
			animation_tree["parameters/conditions/falling"] = false
		else:
			animation_tree["parameters/conditions/jumping"] = false
			animation_tree["parameters/conditions/falling"] = true	
	pass

func update_target_location(target_location):
	nav_agent.target_position = target_location
