extends Node
class_name DashController

signal start_dash
signal end_dash

## How long does a single dash last for. 
@export var dash_duration: float = 0.02
## How long does it take for each dash to recharge 
@export var dash_cooldown: float = 1.0
## How many potenial dashes can the player have at one time. 
@export var max_dash_count: int = 3

## References
@onready var player: CharacterBody3D = $".."
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_duration_timer: Timer = $DashDurationTimer

var current_dash_count: int = 3
var can_dash: bool = true

func _ready() -> void:
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_duration_timer.wait_time = dash_duration
	current_dash_count = max_dash_count
	

func _input(event: InputEvent) -> void:
	# Prevent the player from dashing if they are out of dashes. 
	if current_dash_count <= 0:
		can_dash = false
		return
	if event.is_action_pressed("dash") and can_dash:
		start_dash.emit()
		current_dash_count -= 1
		dash_duration_timer.start()
		can_dash = false

func _on_dash_cooldown_timer_timeout() -> void:
	current_dash_count += 1

func _on_dash_duration_timer_timeout() -> void:
	end_dash.emit()
	dash_cooldown_timer.start()
	can_dash = true
	
