extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10
var current_health


func _ready():
	current_health = max_health


func damage(dmg: float):
	current_health = max(current_health - dmg, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


func get_healt_percent():
	if max_health <= 0:
		return 0
	return current_health / max_health


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
