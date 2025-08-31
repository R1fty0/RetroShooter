extends Node
class_name HealthComponent

signal died 
signal took_damage

@export var max_health: float = 100
var current_health: float = 100

func _ready() -> void:
	current_health = max_health
	
func _take_damage(amount: float):
	if amount >= current_health: 
		_die()
	else:
		current_health -= amount
		took_damage.emit()
		print("Ouch")

func _die():
	died.emit()
	print("Ahhhhh")
	queue_free()
