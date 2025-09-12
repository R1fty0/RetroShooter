extends Resource
class_name PlayerResource


@export_category("Movement")
## Normal speed.
@export var move_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
@export var dash_velocity: float = 9.0

@export_category("Camera")
@export var camera_sens : float = 0.002
## Camera headbobbing. 
@export var bob_freq: float = 2.0
@export var bob_amp: float = 0.08
@export var bob_time: float = 0.02

@export_category("Dashing")
## How fast does the player move when dashing. 
@export var dash_speed: float = 100.0
## How long does a single dash last for. 
@export var dash_duration: float = 0.02
## How long does it take for each dash to recharge 
@export var dash_recharge_time: float = 1.0
## How many potenial dashes can the player have at one time. 
@export var max_dash_count: int = 3
