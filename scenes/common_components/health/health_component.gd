extends Node
class_name HealthComponent

signal died 
signal took_damage

## The object/node to destroy when health fully depletes. 
@export var object: Node3D
@export var max_health: float = 100
var current_health: float = 100

func _ready() -> void:
	current_health = max_health
	
func take_damage(amount: float):
	if amount >= current_health: 
		_die()
	else:
		current_health -= amount
		print("Current Health: " + str(current_health))
		took_damage.emit()

func _die():
	died.emit()
	object.queue_free()
	
