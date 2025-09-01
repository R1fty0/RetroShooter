extends Label

@export var dash_controller: DashController

	
func _process(delta: float) -> void:
	text = "Dashes: " + str(dash_controller.current_dash_count)
	
func _ready() -> void:
	Event_Bus
