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

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * \
		ProjectSettings.get_setting("physics/3d/default_gravity_vector")

var mouse_sensitivity = 0.002
#var push_force = 25.0

@onready var CameraHub = self.get_node("CameraHub")
@onready var SpringArm = CameraHub.get_node("SpringArm")
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var initial_position := position


func _ready():
	animation_tree.active = true
	SpringArm = CameraHub.get_node("SpringArm")
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
	
	var movement_vec2 := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var movement_direction := transform.basis * Vector3(movement_vec2.x, 0, movement_vec2.y)
	movement_direction = movement_direction.normalized()
	
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
		print(horizontal_direction)
		
		if not jumping and jump_attempt:
			vertical_velocity = JUMP_VELOCITY
			jumping = true
	else:
		if movement_direction.length() > 0.1:
			horizontal_velocity += movement_direction * (ACCEL * AIR_ACCEL_FACTOR * delta)
			if horizontal_velocity.length() > max_speed:
				horizontal_velocity = horizontal_velocity.normalized() * max_speed
	
	velocity = horizontal_velocity + Vector3.UP * vertical_velocity
	
	
	move_and_slide()
	
	"""	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_impulse(-col.get_normal() * push_force * delta, col.get_position() - col.get_collider().global_position)
	"""
	AnimationHandler()
				
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("right_click"):
		rotation.y = rotation.y + SpringArm.rotation.y
		if SpringArm.has_method("reset_camera_rotation"):
			SpringArm.reset_camera_rotation()
		rotate_y(-event.relative.x * mouse_sensitivity)		
