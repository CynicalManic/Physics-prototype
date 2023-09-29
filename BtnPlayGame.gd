extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Inside read")
	#print("Is button pressed: ", is_pressed())
	#print("Is button disabled: ", is_disabled())
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed()-> void:
	#print("Button Pressed: ")
	#print("Is Pressed: ", is_pressed())
	pass
