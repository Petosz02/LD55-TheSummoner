extends Node

signal exp_update(current_exp: float, tartet_exp: float)
signal levelup(new_level: int)

var target_exp_grow = 5

var current_exp = 0
var current_level = 1
var target_exp = 5

func _ready():
	GameEvents.exp_collected.connect(on_exp_collected)


func on_exp_collected(number: float):
	add_exp(number)

func add_exp(number: float):
	current_exp = min(current_exp + number, target_exp)
	exp_update.emit(current_exp, target_exp)
	if current_exp == target_exp:
		current_level += 1
		target_exp += target_exp_grow
		current_exp = 0
		exp_update.emit(current_exp, target_exp)
		levelup.emit(current_level)
	print(current_exp)
