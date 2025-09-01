extends Area3D
class_name Projectile

## All of these settings are usually set by the projectile shooting component. 
## What group the bullet will target 
var target_group: String = "player" 
var damage: float = 10.0
var speed: float = 40.0
var direction: Vector3 = Vector3.FORWARD

func _physics_process(delta: float) -> void:
	var displacement = direction.normalized() * speed * delta
	_projectile_col_detection(displacement)
	# Move projectile if we don't hit anything. 
	global_position += displacement
	# Rotate to face movement direction
	##look_at(global_position + displacement, Vector3.UP)

func _projectile_col_detection(displacement: Vector3):
	# Raycasting for projectile collisions. 
	# Create ray parameters
	var ray_params = PhysicsRayQueryParameters3D.new()
	ray_params.from = global_position
	ray_params.to = global_position + displacement
	ray_params.exclude = [self]
	ray_params.collide_with_areas = true  # important: detect areas

	# Cast the ray
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(ray_params)
	# Trigger collision handling. 
	if result:
		var hit_body = result.collider
		_handle_hit(hit_body)
		queue_free()
		
func _handle_hit(body: Node) -> void:
	if body.is_in_group(target_group):
		if body is Hitbox and body.health_component != null:
			var total_damage = damage * body.damage_multiplier
			body.health_component.take_damage(total_damage)
