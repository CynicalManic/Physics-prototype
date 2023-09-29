extends ColorRect

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var randomWidth: float
var randomHeight: float

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func _draw():
	print("Drawing circle at: ", randomWidth,", ", randomHeight)
	draw_circle(Vector2(randomWidth, randomHeight), 30, Color.WHITE)
	pass
	
func changePlacement() -> void:
	randomPlacement()
	queue_redraw()
	pass
	
func randomPlacement() -> void:
	randomWidth = rng.randf_range(0.0, 1920.0)
	randomHeight = rng.randf_range(0.0, 1080.0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_play_game_pressed():
	print("Button press received")
	changePlacement()
	pass # Replace with function body.
