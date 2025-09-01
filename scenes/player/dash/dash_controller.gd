extends Node
class_name DashController

## How long does a single dash last for. 
@export var dash_duration: float = 0.02
## How long does it take for each dash to recharge 
@export var dash_recharge_time: float = 1.0
## How many potenial dashes can the player have at one time. 
@export var max_dash_count: int = 3
## How long after the last dash does recharging start. 
@export var dash_recharge_delay: float = 0.30

## References
@onready var player: CharacterBody3D = $".."
## Timer that manages how long dashes take to recharge (yes I know the naming is stupid, should be recharge). 
@onready var dash_recharge_timer: Timer = $DashRechargeTimer
@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_recharge_delay_timer: Timer = $DashRechargeDelayTimer

var current_dash_count: int = 3
var can_dash: bool = true
var can_recharge_dash: bool = true

func _ready() -> void:
	dash_recharge_timer.wait_time = dash_recharge_time
	dash_duration_timer.wait_time = dash_duration
	dash_recharge_delay_timer.wait_time = dash_recharge_delay
	current_dash_count = max_dash_count

func _input(event: InputEvent) -> void:
	# Prevent the player from dashing if they are out of dashes. 
	if current_dash_count <= 0:
		can_dash = false
		return
	if event.is_action_pressed("dash") and can_dash:
		SignalBus.start_player_dash.emit()
		current_dash_count -= 1
		# Reset the recharge dash timer and start the recharge delay timer 
		# if the player uses dash before a dash fully recharges. 
		if !dash_recharge_timer.is_stopped():
			# Start the recharge delay timer.
			dash_recharge_delay_timer.start()
			can_recharge_dash = false
			# Reset the recharge dash timer
			dash_recharge_timer.wait_time = dash_recharge_time
		else:
			dash_recharge_delay_timer.start()
			can_recharge_dash = false
		can_dash = false

func _on_dash_duration_timer_timeout() -> void:
	SignalBus.end_player_dash.emit()
	dash_recharge_timer.start()
	can_dash = true
	
func _on_dash_recharge_delay_timer_timeout() -> void:
	dash_recharge_timer.start()
	can_recharge_dash = true

func _on_dash_recharge_timer_timeout() -> void:
	current_dash_count += 1
	# Keep recharing dashes if we are still missing dashes. 
	if can_recharge_dash and current_dash_count < max_dash_count and dash_recharge_timer.is_stopped():
		dash_recharge_timer.start()
