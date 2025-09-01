extends Area3D
class_name Hitbox 

## What target group this hitbox belongs to. 
@export var target_group: String
## Store reference to health component 
@export var health_component: HealthComponent
## How much incoming damage is multiplied. 
@export var damage_multiplier: float = 1.0

func _ready() -> void:
	# Throw an error if I forgot to assign a hitbox. 
	if target_group == null:
		push_error("No target group is assigned to this hitbox: " + name)
	# Add this hitbox to the desired target group. 
	add_to_group(target_group)
