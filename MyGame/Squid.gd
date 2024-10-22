extends CharacterBody3D

class_name Squid

@export var Health = 15
@onready var ray = $AnimatedSprite3D/RayCast3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var _nav_agent := $NavigationAgent3D as NavigationAgent3D

@export var character_speed := 3.0
var attacking = false
var following = false
func _physics_process(delta: float) -> void:
	if not following: return
	#set_target_position(player.global_position)
	if not  _nav_agent.is_navigation_finished():
		
		var next_position := _nav_agent.get_next_path_position()
		var offset := next_position - global_position
		global_position = global_position.move_toward(next_position, delta * character_speed)

	# Make the robot look at the direction we're traveling.
	# Clamp y to 0 so the robot only looks left and right, not up/down.
		offset.y = 0
		look_at(global_position + offset, Vector3.UP)

	if $HitTimer.is_stopped() and ray.is_colliding()  :
		$HitTimer.start()
		$AnimatedSprite3D.play("Attack")
		await $AnimatedSprite3D.animation_finished
		ray.force_raycast_update()
		if ray.is_colliding():
			print(ray.get_collider().name)
			if ray.get_collider() is Player:
				print("hurting player")
				player.hurt()
	elif $HitTimer.is_stopped():
		$AnimatedSprite3D.play("Walking")
	#add another timer
	#check if ray is colliding and can hit timer is stopped
  	#start hit timer
	#if collision is Player
	#player.hurt (might need to add function to player called hurt)
	#play attack animation

func hurt(dmg):
	Health -=dmg
	if Health <=0:
		queue_free()

func set_target_position(target_position: Vector3):
	_nav_agent.set_target_position(target_position)


func _on_timer_timeout() -> void:
	set_target_position(player.global_position)


func _on_hit_timer_timeout() -> void:
	set_target_position(player.global_position)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		following = true
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		following =  false
	pass # Replace with function body.
