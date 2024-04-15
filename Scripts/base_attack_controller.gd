extends Node

@export var attack_range: float = 100
@export var base_attack: PackedScene
@export var base_dmg = 5
var aditional_dmg_percent = 1
var base_attack_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)
	base_attack_speed = $Timer.wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_added)


func on_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(attack_range, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var base_attack_instance = base_attack.instantiate() as BaseAttack
	var abilities_layer = get_tree().get_first_node_in_group("abilities_layer")
	abilities_layer.add_child(base_attack_instance)
	base_attack_instance.hit_box.damage = base_dmg * aditional_dmg_percent
	var dir = enemies[0].global_position - player.global_position
	base_attack_instance.global_position = enemies[0].global_position - dir.normalized() * 16
	
	base_attack_instance.rotation = - dir.angle()


func on_ability_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.ability_id == "attack_rate":
		var percent_reduction = current_upgrades["attack_rate"]["quantity"] * .1
		$Timer.wait_time = base_attack_speed * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.ability_id == "attack_damage":
		aditional_dmg_percent = 1 + current_upgrades["attack_damage"]["quantity"] * .15
