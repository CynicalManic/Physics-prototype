extends CharacterBody3D

var Animation_State = "Idle"

const WALKING_SPEED = 6.0
const SPRINTING_SPEED = 10.0
const ACCEL = 14.0
const DEACCEL = 14.0
const AIR_ACCEL_FACTOR = 0.5
const JUMP_VELOCITY = 8.0

var jumping := false
var max_speed = WALKING_SPEED
var pathfinding = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * \
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var mouse_sensitivity = 0.002
#var push_force = 25.0

#@onready var CameraHub = self.get_node("CameraHub")
#@onready var SpringArm = CameraHub.get_node("SpringArm")
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var initial_position := position
@onready var armature_2 = $Armature2
@onready var camera_center : Node3D = $camera_center
@onready var camera_point = $camera_center/camera_point
@onready var nav_agent = $NavigationAgent3D


func _ready():
	animation_tree.active = true
	GameManager.set_player(self)
	#SpringArm = CameraHub.get_node("SpringArm")
	pass
	

	
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

func GetDirection():
	var next_location = nav_agent.get_next_path_position()
	var current_location = global_transform.origin
	
	var movement_vec2 := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var movement_direction := camera_center.basis * transform.basis * Vector3(movement_vec2.x, 0, movement_vec2.y)
	movement_direction = movement_direction.normalized()
	
	if movement_vec2 != Vector2.ZERO:
		pathfinding = false
		
	if pathfinding == true and nav_agent.is_navigation_finished():
			pathfinding = false
			print("Arrived at location")
		
	if pathfinding == true:		
		movement_direction = (next_location - current_location).normalized()
		movement_direction.y = 0
		return movement_direction
	else:
		return movement_direction

func _physics_process(delta):
	# Reset position if fell off map
	if global_position.y < -12:
		position = initial_position
		velocity = Vector3.ZERO
	
	# Add gravity
	velocity += gravity * delta
		
	var vertical_velocity := velocity.y
	var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
	#print("X: " , velocity.x , " Y: " , velocity.x , " Z: " , velocity.z)
	
	var movement_direction = GetDirection()
	
	var horizontal_direction := (transform.basis * horizontal_velocity).normalized()
	var horizontal_speed := horizontal_velocity.length()
	
	var jump_attempt := Input.is_action_pressed("jump")
	var sprinting := Input.is_action_pressed("Sprint")
	
	if sprinting:
		max_speed = SPRINTING_SPEED
	else:
		max_speed = WALKING_SPEED
	
	if is_on_floor():		
		jumping = false
		if movement_direction.length() > 0.1:
			if horizontal_speed < max_speed:
				horizontal_speed += ACCEL * delta
			else:
				horizontal_speed -= DEACCEL * delta			
		else:
			horizontal_speed -= DEACCEL * delta
			movement_direction = horizontal_velocity.normalized()
			if horizontal_speed < 0:
				horizontal_speed = 0

		horizontal_velocity = movement_direction * horizontal_speed
		
		if not jumping and jump_attempt:
			vertical_velocity = JUMP_VELOCITY
			jumping = true
	else:
		if movement_direction.length() > 0.1:
			horizontal_velocity += movement_direction * (ACCEL * AIR_ACCEL_FACTOR * delta)
			if horizontal_velocity.length() > max_speed:
				horizontal_velocity = horizontal_velocity.normalized() * max_speed
	
	velocity = horizontal_velocity + Vector3.UP * vertical_velocity
	
	if movement_direction:
		armature_2.look_at(armature_2.transform.origin - movement_direction + position, Vector3.UP)
		
	move_and_slide()
	

	
	"""	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_impulse(-col.get_normal() * push_force * delta, col.get_position() - col.get_collider().global_position)
	"""
	AnimationHandler()
				
	
func update_target_location(target_location):
	pathfinding = true
	nav_agent.target_position = target_location
