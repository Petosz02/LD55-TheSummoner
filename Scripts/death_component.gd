extends Node2D

@export var sprite: Sprite2D
@export var healt_component: Node


func _ready():
	$CPUParticles2D.texture = sprite.texture
	healt_component.died.connect(on_died)


func  on_died():
	if not owner is Node2D:
		return
	var spaw_pos = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	
	entities.add_child(self)
	global_position = spaw_pos
	$AnimationPlayer.play("default")
