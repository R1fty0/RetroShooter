extends Label

@export var player_gun: ProjectileShootingComponent
var is_reloading: bool = false

func _ready() -> void:
	player_gun.reloading.connect(_show_reloading_text)
	player_gun.reloaded.connect(_hide_reloading_text)

func _process(delta: float) -> void:
	if !is_reloading:
		text = "Ammo: " + str(player_gun.current_ammo_count) + "/" + str(player_gun.magazine_size)
	else:
		text = "Reloading..."

func _show_reloading_text() -> void:
	is_reloading = true

func _hide_reloading_text() -> void:
	is_reloading = false
