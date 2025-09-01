extends Label

@export var dash_controller: DashController

	
func _process(_delta: float) -> void:
	text = "Dashes: " + str(dash_controller.current_dash_count)
