extends CanvasLayer
@onready var fullscreen = $MarginContainer/VBoxContainer/Fullscreen

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_to_title_pressed():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
	pass # Replace with function body.


func _on_fullscreen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen.text = "Fullscreen : OFF"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen.text = "Fullscreen : ON"


func _on_h_slider_value_changed(value):
	Globals.volume = value
