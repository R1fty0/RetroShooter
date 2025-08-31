extends Node3D
class_name ProjectileShootingComponent


## How long does the gun wait before being able to fire the next shot. 
@export var time_between_shots: float = 0.5

@export_category("Projectile")
@export var projectile: PackedScene
@export var projectile_target_group: String
@export var projectile_damage: float
@export var projectile_speed: float

@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var projectile_spawn_point: Marker3D = $ProjectileSpawnPoint

var can_fire: bool = true

func _ready() -> void:
	fire_rate_timer.wait_time = time_between_shots
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and can_fire:
		_shoot()

func _shoot() -> void:
	var new_projectile: Projectile = projectile.instantiate()
	# Add projectile to scene. 
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = projectile_spawn_point.global_position
	new_projectile.global_rotation = projectile_spawn_point.global_rotation

	# Setup projectile stats
	# Make the projectile face forward relative to what direction the gun is pointing at.
	new_projectile.direction = projectile_spawn_point.global_transform.basis.z * -1
	new_projectile.target_group = projectile_target_group
	new_projectile.damage = projectile_damage
	new_projectile.speed = projectile_speed

	# Prevent the gun from firing again.
	can_fire = false
	fire_rate_timer.start()


func _on_fire_rate_timer_timeout() -> void:
	print("can shoot again")
	can_fire = true
