extends Node
class_name DashController


## The resource of the object that can dash.
@export var object_resource: Resource


## References
@onready var player: Player = $".."
 
@onready var dash_recharge_timer: Timer = $DashRechargeTimer
@onready var dash_duration_timer: Timer = $DashDurationTimer

var current_dash_count: int = 3
var can_dash: bool = true
## Keeps track if a dash was recharging 
var dash_was_recharging: bool = false

func _ready() -> void:
	current_dash_count = object_resource.max_dash_count
	# Set up dash recharge timer.
	dash_recharge_timer.wait_time = object_resource.dash_recharge_time
	dash_recharge_timer.autostart = false
	dash_recharge_timer.one_shot = true
	# Set up dash duration timer. 
	dash_duration_timer.wait_time = object_resource.dash_duration
	dash_duration_timer.autostart = false
	dash_duration_timer.one_shot = true

func _input(event: InputEvent) -> void:
	# Prevent the player from dashing if they are out of dashes. 
	if current_dash_count <= 0:
		can_dash = false
		return
	# Start a dash. 
	if event.is_action_pressed("dash") and can_dash:
		SignalBus.start_player_dash.emit()
		dash_duration_timer.start()
		# Pause the dash recharge timer if its running.
		if dash_recharge_timer.is_stopped() == false:
			dash_recharge_timer.paused = true
			dash_was_recharging = true
		current_dash_count -= 1
		can_dash = false

func _on_dash_duration_timer_timeout() -> void:
	SignalBus.end_player_dash.emit()
	# Unpause dash recharge timer if it was paused prior to starting this dash. 
	if dash_was_recharging:
		dash_recharge_timer.paused = false
	else:
		dash_recharge_timer.start()
	can_dash = true

func _on_dash_recharge_timer_timeout() -> void:
	# Allow the player to dash if they bottom out and a dash recharges.
	if current_dash_count <= 0:
		can_dash = true
	# Start another recharge if the player is not full on dashes.
	if current_dash_count < object_resource.max_dash_count:
		dash_recharge_timer.start()
	current_dash_count += 1
