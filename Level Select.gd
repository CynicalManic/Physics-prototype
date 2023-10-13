extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_btn_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
	pass # Replace with function body.


func _on_btn_level_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/3rd Person.tscn")
	pass # Replace with function body.res://Scenes/3rd Person.tscn


func _on_btn_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/3D Test Scene.tscn")
	pass # Replace with function body.


func _on_btn_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Terrain Test Map.tscn")
	pass # Replace with function body.
