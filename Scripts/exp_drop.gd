extends Node

@export var exp_crystal_scene: PackedScene
@export var health_component: HealthComponent
@export_range(0,1) var drop_percente: float = .5

func _ready():
	health_component.died.connect(on_died)


func on_died():
	if exp_crystal_scene == null:
		return
	
	if randf() > drop_percente:
		return
	
	var spawn_pos = (owner as Node2D).global_position
	var exp_crystal_instance = exp_crystal_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(exp_crystal_instance)
	exp_crystal_instance.global_position = spawn_pos
