extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_play_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level Select.tscn")
	pass # Replace with function body.


func _on_btn_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
	pass # Replace with function body.


func _on_btn_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
