extends CharacterBody3D

@export var speed = 2
@export var sprint_speed = 4
@export var current_speed = speed
@export var mouse_sensitivity = 0.005
@onready var camera = $Camera3D
@onready var ray = $Camera3D/RayCast3D
@onready var interact_label = $CanvasLayer/Label

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var jump_speed = 5
func _ready():
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	velocity.y += -gravity * delta
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var move_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	if input_dir:
		velocity.x = move_dir.x * current_speed
		velocity.z = move_dir.z * current_speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/Pause_Menu.tscn")
		
	move_and_slide()
	
	if ray.is_colliding():
		check_collisions()
	#else:
		#interact_label.visible = false
		
func check_collisions():
	var collider = ray.get_collider()
	if collider.is_in_group("Physics"):
		interact_label.visible = true
		if Input.is_action_pressed("use"):
			collider.apply_central_impulse(Vector3.UP * 2)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1,1)
	

