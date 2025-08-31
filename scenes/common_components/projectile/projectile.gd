extends Area3D
class_name Projectile

## All of these settings are usually set by the projectile shooting component. 
## What group the bullet will target 
var target_group: String = "player" 
var damage: float = 10.0
var speed: float = 40.0
var direction: Vector3 = Vector3.FORWARD

func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	# Move bullet forward.
	global_position += velocity * delta
	# Make bullet spin during movement. 
	if velocity.length() > 0:
		look_at(global_position + velocity, Vector3.UP)

func _on_body_entered(body: Node) -> void:
	print("ive hit something")
	# Check if we wanna damage this thing and damage it. 
	if body.is_in_group(target_group):
		if body is Hitbox:
			if body.health_component != null:
				body.health_component._take_damage(damage)
				print("We've damaged something")
	# Destroy the bullet. 
	queue_free()
