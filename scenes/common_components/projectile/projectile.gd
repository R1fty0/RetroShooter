extends RigidBody3D
class_name Projectile

## Speed of the bullet 
@export var speed: float = 40.0
## What group the bullet will target 
@export var target_group: String = "player" 

@export var damage: float = 10.0

func _ready() -> void:
	# Add velocity to bullet when it is spawned to make it travel forward. 
	var impulse = Vector3.FORWARD * speed
	linear_velocity = impulse

func _on_body_entered(body: Node) -> void:
	# Check if we wanna damage this thing and damage it. 
	if body.is_in_group(target_group):
		if body is Hitbox:
			if body.health_component != null:
				body.health_component._take_damage(damage)
	# Destroy the bullet. 
	queue_free()
