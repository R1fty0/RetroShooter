extends CharacterBody3D
class_name Player

const AIR_DEACCEL: float = 3.0
const GROUND_DEACCEL: float = 8.0


@export_group("Movement")
## Normal speed.
@export var run_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5

@export_group("Camera")
@export var camera_sens : float = 0.002
## Camera headbobbing. 
@export var bob_freq: float = 2.0
@export var bob_amp: float = 0.08
var current_bob_time: float = 0.0

## Camera fov.
const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 1.5

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var dash_speed: float = 23.0

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $PhysicalCollider
@onready var camera: Camera3D = $Head/Camera3D

var dashing: bool = false

func _ready() -> void:
	SignalBus.connect("start_player_dash", _start_dash)
	SignalBus.connect("end_player_dash", _end_dash)
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	move_speed = run_speed

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	

func _physics_process(delta: float) -> void:
	# Apply gravity if we are in the air. 
	if not is_on_floor():
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity.y -= gravity * delta
	
	# Start jumping. 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("left", "right", "forward", "back") 
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if dashing: 
		velocity = move_dir * dash_speed
		
	# Only allow the player to control horizontal movement when they are on the floor and not dashing. 
	if is_on_floor() and !dashing:
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = lerp(velocity.x, move_dir.x * move_speed, delta * GROUND_DEACCEL)
			velocity.z = lerp(velocity.z, move_dir.z * move_speed, delta * GROUND_DEACCEL)
	else:
		velocity.x = lerp(velocity.x, move_dir.x * move_speed, delta * AIR_DEACCEL)
		velocity.z = lerp(velocity.z, move_dir.z * move_speed, delta * AIR_DEACCEL)
		
			
	# Camera headbobbing.
	current_bob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _get_camera_next_headbob_pos(current_bob_time)
	
	# Camera fov changes.
	var velocity_clamped = clamp(velocity.length(), 0.5, dash_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _get_camera_next_headbob_pos(bob_time):
	var pos = Vector3.ZERO
	pos.y = sin(bob_time * bob_freq) * bob_amp
	pos.x = cos(bob_time * bob_freq/2) * bob_amp
	return pos

## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * camera_sens
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * camera_sens
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

## Hide mouse cursor 
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

## Show mouse cursor
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _end_dash() -> void:
	dashing = false

func _start_dash() -> void:
	dashing = true
