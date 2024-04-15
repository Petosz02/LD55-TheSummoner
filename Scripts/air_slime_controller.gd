extends Node
@export var slime_scene: PackedScene
@export var base_dmg: float = 10
var percent_damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_added)


func on_timeout():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	var slime_instance = slime_scene.instantiate() as Node2D
	entities_layer.add_child(slime_instance)
	slime_instance.global_position = player.global_position
	slime_instance.hit_box.damage = base_dmg * percent_damage
	

func on_ability_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.ability_id == "air_slime_damage":
		percent_damage = 1 + current_upgrades["air_slime_damage"]["quantity"] * .1
