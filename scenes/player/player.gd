extends CharacterBody3D
class_name Player


## TODO:
## - change max speed used for camera fov effects

const AIR_DEACCEL: float = 3.0
const GROUND_DEACCEL: float = 8.0

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?

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

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var camera: Camera3D = $Head/Camera3D

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

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
	move_speed = base_speed
	if not is_on_floor():
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("left", "right", "forward", "back") 
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# Only allow the player to control horizontal movement when they are on the floor. 
	if is_on_floor():
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
	move_and_slide()
	
	# Camera fov changes.
	var velocity_clamped = clamp(velocity.length(), 0.5, move_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func _get_camera_next_headbob_pos(bob_time):
	var pos = Vector3.ZERO
	pos.y = sin(bob_time * bob_freq) * bob_amp
	pos.x = cos(bob_time * bob_freq/2) * bob_amp
	return pos


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

# Hide mouse cursor 
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

# Show mouse cursor
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


func _on_dash_controller_end_dash() -> void:
	# move_speed = base_speed
	pass

func _on_dash_controller_start_dash(dash_velocity: Variant) -> void:
	pass
