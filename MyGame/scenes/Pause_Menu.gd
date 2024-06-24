extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")
	pass # Replace with function body.


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")
	pass # Replace with function body.


func _on_back_to_title_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
	pass # Replace with function body.
