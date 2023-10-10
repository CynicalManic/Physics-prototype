extends CharacterBody3D

var Animation_State = "Idle"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity = 0.002
var push_force = 25.0
@onready var CameraHub = self.get_node("CameraHub")
@onready var SpringArm = CameraHub.get_node("SpringArm")

func _ready():
	$AnimationPlayer.play("Idle")
	SpringArm = CameraHub.get_node("SpringArm")
	pass
	
func AnimationHandler(input_dir):
	
	if input_dir == Vector2(0,0) and is_on_floor():
		Animation_State = "Idle"
	elif input_dir != Vector2(0,0) and is_on_floor() and Input.is_action_pressed("Sprint"):
		Animation_State = "Sprinting"
	elif input_dir != Vector2(0,0) and is_on_floor():
		Animation_State = "Walking"
	
	
	if (Animation_State == "Idle" or Animation_State == "Walking") and not is_on_floor():
		Animation_State = "Falling"	
	
	if Animation_State == "Idle":
		$AnimationPlayer.play("Idle")
	if Animation_State == "Walking":
		$AnimationPlayer.play("Walking")
	if Animation_State == "Jumping":
		$AnimationPlayer.play("Jumping")
	if Animation_State == "Falling":
		$AnimationPlayer.play("Falling")
	if Animation_State == "Sprinting":
		$AnimationPlayer.play("Sprinting")
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Animation_State = "Jumping"
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	
	move_and_slide()
	
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_impulse(-col.get_normal() * push_force * delta, col.get_position() - col.get_collider().global_position)
	
	AnimationHandler(input_dir)
				
				
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("right_click"):
		rotation.y = rotation.y + SpringArm.rotation.y
		if SpringArm.has_method("reset_camera_rotation"):
			SpringArm.reset_camera_rotation()
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		


func _on_animation_player_animation_finished(anim_name):
	if Animation_State == "Jumping":
		$AnimationPlayer.play("Falling")
		Animation_State = "Falling"
	pass # Replace with function body.
