extends Label

@export var player_health_component: HealthComponent

func _process(delta: float) -> void:
	text = "Health: " + str(player_health_component.current_health)
