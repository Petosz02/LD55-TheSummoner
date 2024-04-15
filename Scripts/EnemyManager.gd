extends Node

const SPAWN_RANGE = 330

@export var orb_enemy_scene: PackedScene
@export var imp_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var time_manager: Node
@onready var timer = $Timer
var base_spawn_time

var enemy_table = WeightTable.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_table.add_item(orb_enemy_scene, 10)
	timer.timeout.connect(on_timeout)
	time_manager.dificulty_up.connect(on_dificulty_up)
	base_spawn_time = timer.wait_time


func on_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var random_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_pos = player.global_position + random_dir * SPAWN_RANGE
	
	var enemy_scene = enemy_table.pick_item()
	
	var enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_pos


func on_dificulty_up(level: int):
	var time_off = (.1 / 12) * level
	time_off = min(time_off, .3)
	print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	if level == 6:
		enemy_table.add_item(imp_enemy_scene,15)
	
	if level == 16:
		enemy_table.add_item(ghost_enemy_scene, 30)

