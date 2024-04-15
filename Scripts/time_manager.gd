extends Node

signal dificulty_up(dificulty: int)

@onready var timer = $Timer
@export var end_screen_scene: PackedScene
var dificulty = 0
var dificulty_interval = 5

func _ready():
	timer.timeout.connect(on_timeout)


func _process(delta):
	var next_time = timer.wait_time - (dificulty + 1) * dificulty_interval
	if timer.time_left <= next_time:
		dificulty += 1
		dificulty_up.emit(dificulty)


func get_elapsed_time():
	return timer.wait_time - timer.time_left


func on_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
