extends Node3D
class_name ProjectileShootingComponent

signal shooting
signal reloading 
signal reloaded

## How long does the gun wait before being able to fire the next shot. 
@export var time_between_shots: float = 0.5

@export_category("Projectile")
@export var projectile: PackedScene
@export var projectile_target_group: String
@export var projectile_damage: float
@export var projectile_speed: float

@export_category("Reloading")
@export var magazine_size: int = 13
@export var std_reload_time: float = 1.2
@export var tac_reload_time: float = 0.8

@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var projectile_spawn_point: Marker3D = $ProjectileSpawnPoint
@onready var reload_timer: Timer = $ReloadTimer

var can_fire: bool = true
var current_ammo_count: int = 13

func _ready() -> void:
	current_ammo_count = magazine_size
	fire_rate_timer.wait_time = time_between_shots
	reload_timer.wait_time = std_reload_time
	
func _input(event: InputEvent) -> void:
	# Allow the player to manually reload if they have a partially full magazine (a.k.a tactical reload).
	if event.is_action_pressed("reload") and current_ammo_count < magazine_size:
		_reload(true)
	if event.is_action_pressed("shoot") and can_fire:
		# Trigger a reload if the player tries shooting with an empty magazine. 
		if current_ammo_count <= 0:
			_reload(false)
		else:
			print("pew")
			_shoot()

func _shoot() -> void:
	# Add projectile to scene. 
	var new_projectile: Projectile = projectile.instantiate()
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = projectile_spawn_point.global_position
	new_projectile.global_rotation = projectile_spawn_point.global_rotation

	# Setup projectile stats
	new_projectile.direction = projectile_spawn_point.global_transform.basis.z * -1
	new_projectile.target_group = projectile_target_group
	new_projectile.damage = projectile_damage
	new_projectile.speed = projectile_speed

	# Prevent the gun from firing again.
	can_fire = false
	fire_rate_timer.start()
	
	# Remove a shot from the magazine. 
	current_ammo_count -= 1
	shooting.emit()
	
func _reload(tactical_reload: bool) -> void:
	if tactical_reload: 
		reload_timer.wait_time = tac_reload_time
	else:
		reload_timer.wait_time = std_reload_time
	print("reloading")
	reload_timer.start()
	reloading.emit()
	can_fire = false

func _on_fire_rate_timer_timeout() -> void:
	can_fire = true

func _on_reload_timer_timeout() -> void:
	can_fire = true
	current_ammo_count = magazine_size
	reloaded.emit()
