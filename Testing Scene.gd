extends Polygon2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var randomX: float
var randomY: float

@export var velocity: Vector2
@export var rotationSpeed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func _draw():
	#print("Drawing circle at: ", randomX,", ", randomY)
	pass
	
func changePlacement() -> void:
	randomPlacement()
	self.position.x = randomX
	self.position.y = randomY
	queue_redraw()
	pass
	
func randomPlacement() -> void:
	randomX = rng.randf_range(0.0, get_viewport().get_visible_rect().size.x - 100)
	randomY = rng.randf_range(0.0, get_viewport().get_visible_rect().size.y - 100)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	self.position.x = self.position.x + (velocity.x * delta)
	self.position.y = self.position.y + (velocity.y * delta)
	velocity = velocity.rotated(deg_to_rad(rotationSpeed))
	
	queue_redraw()
	
	checkOutOfBounds()
	
	pass
	
func checkOutOfBounds():
	
	
	if(self.position.x <= 0):
		print("Too far left")
		print("Current position: ", self.position.x, ", ", self.position.y)
		print("Out of bounds: ", get_viewport().get_visible_rect().size.x - 100, ", ", get_viewport().get_visible_rect().size.y)
		velocity.x = -velocity.x
	if(self.position.y <= 0):
		print("Too far up")
		print("Current position: ", self.position.x, ", ", self.position.y)
		print("Out of bounds: ", get_viewport().get_visible_rect().size.x - 100, ", ", get_viewport().get_visible_rect().size.y)
		velocity.y = -velocity.y
	if(self.position.x >= get_viewport().get_visible_rect().size.x - 100):
		print("Too far right")
		print("Current position: ", self.position.x, ", ", self.position.y)
		print("Out of bounds: ", get_viewport().get_visible_rect().size.x - 100, ", ", get_viewport().get_visible_rect().size.y)
		velocity.x = -velocity.x
	if(self.position.y >= get_viewport().get_visible_rect().size.y - 100):
		print("Too far down")
		print("Current position: ", self.position.x, ", ", self.position.y)
		print("Out of bounds: ", get_viewport().get_visible_rect().size.x - 100, ", ", get_viewport().get_visible_rect().size.y)
		velocity.y = -velocity.y
	pass

func _on_btn_play_game_pressed():
	print("Button press received")
	changePlacement()
	pass # Replace with function body.
