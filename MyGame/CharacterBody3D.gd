extends CharacterBody3D
class_name Player
@onready var spider = get_tree().get_first_node_in_group("Spider")
@export var Health = 3
@export var speed = 2
@export var sprint_speed = 4
@export var current_speed = speed
@export var mouse_sensitivity = 0.005
@onready var camera = $Camera3D
@onready var ray = $Camera3D/RayCast3D
#@onready var interact_label = $CanvasLayer/Label
const BOB_FREQ  = 2.0
const BOB_AMP = 0.05
var t_bob = 0.0
@onready var hand = %Hand
@onready var animation_player = %AnimationPlayer
var damage = 5
var weapon_sprite = preload("res://Item Sprites/sprite_18.png")
@onready var sprite_3d = $Hand/Sprite3D
@onready var interact_label: Label = $HUD/Label

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var jump_speed = 5
func hurt():
	Health-=1
	if Health <= 2:
		$HUD/Heart3.hide()
	if Health <= 1:
		$HUD/Heart2.hide()
	if Health <= 0:
		await get_tree().create_timer(1)
		get_tree().change_scene_to_file("res://scenes/death.tscn")


func _ready():
	# Capture the mouse
	sprite_3d.texture = weapon_sprite
	animation_player.play("RESET")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	hand.rotation.x = camera.rotation.x
	
func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		animation_player.play("Attack")
		
	velocity.y += -gravity * delta
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var move_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	if input_dir:
		velocity.x = move_dir.x * current_speed
		velocity.z = move_dir.z * current_speed
	else:
		velocity.x = 0
		velocity.z = 0
		
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/Pause_Menu.tscn")
		
	move_and_slide()
	
		
	if ray.get_collider():
		check_collisions()
	else:
		interact_label.hide()
	
	
		
		
		
	
	#else:
		#interact_label.visible = false
		
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
		
func check_collisions():
	var collider = ray.get_collider()
	if collider:
		if collider.is_in_group("Weapon"):
			interact_label.show()
			if Input.is_action_just_pressed("use"):
				collider.queue_free()
				weapon_sprite = collider.weapon_sprite
				damage = collider.damage
				sprite_3d.texture = weapon_sprite
				interact_label.hide()
			#collider.apply_central_impulse(Vector3.UP * 2)

	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1,1)
	
func check_hit():
	
	print("check hit")
	if ray.is_colliding():
		ray.force_raycast_update()
		if ray.get_collider() is Spider:
			print("hit spider")
			ray.get_collider().hurt()
	
