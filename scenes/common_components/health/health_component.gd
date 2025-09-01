extends Node
class_name HealthComponent

## NOTE:
## - this component must be the child of whatever object you want dead when its health runs out.

signal died 
signal took_damage

@export var max_health: float = 100
var current_health: float = 100

func _ready() -> void:
	current_health = max_health
	
func take_damage(amount: float):
	if amount >= current_health: 
		_die()
	else:
		print("Took " + str(amount) + " damage.")
		current_health -= amount
		took_damage.emit()

func _die():
	died.emit()
	get_parent().queue_free()
	
