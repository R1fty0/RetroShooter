extends Node
class_name DashController

## TODO: 
## - Dash lerping (https://chatgpt.com/c/68ad5531-5c9c-8320-afad-d0fa9a290dbc)

@export var dash_duration: float = 0.2
@export var dash_distance: float = 0.3 
## How long does it take for one dash to recharge after use 
@export var dash_cooldown: float = 1.0
## How many potenial dashes can the player have at one time. 
@export var max_stored_dashes: int = 3

@onready var player: CharacterBody3D = $".."
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

var current_stored_dashes: int = 3

func _ready() -> void:
	dash_cooldown_timer.wait_time = dash_cooldown

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		pass 

func _dash() -> void:
	var tween = create_tween()
	var start_pos: Vector3 = player.position
	var direction: Vector3 = Vector3(1,0,0).normalized()  # Must be normalized
	var distance: float = 5.0

	# var new_pos = start_pos + direction * distance
	# tween.tween_property(player, "position")
	pass
