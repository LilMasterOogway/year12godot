extends RigidBody3D

@export var damage = 5
@export var weapon_sprite = preload("res://Item Sprites/sprite_18.png")

func _ready():
	$Sprite3D.texture = weapon_sprite
	
