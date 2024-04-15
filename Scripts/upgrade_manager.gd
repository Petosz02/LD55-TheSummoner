extends Node

@export var exp_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightTable = WeightTable.new()

const ATTACK_DAMAGE = preload("res://resources/updates/attack_damage.tres")
const ATTACK_RATE = preload("res://resources/updates/attack_rate.tres")
const WATER_SLIME = preload("res://resources/updates/water_slime.tres")
const WATER_SLIME_DAMAGE = preload("res://resources/updates/water_slime_damage.tres")
const AIR_SLIME = preload("res://resources/updates/air_slime.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade_pool.add_item(ATTACK_DAMAGE, 10)
	upgrade_pool.add_item(ATTACK_RATE, 10)
	upgrade_pool.add_item(WATER_SLIME, 10)
	upgrade_pool.add_item(AIR_SLIME, 10)
	
	exp_manager.levelup.connect(on_levelup)
	

func update_upgrade_pool(choosen_upgrade: AbilityUpgrade):
	if choosen_upgrade.ability_id == WATER_SLIME.ability_id:
		upgrade_pool.add_item(WATER_SLIME_DAMAGE, 10)


func pick_upgrade():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
		
	return chosen_upgrades


func aply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.ability_id)
	if !has_upgrade:
		current_upgrades[upgrade.ability_id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.ability_id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.ability_id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
			#upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return pool_upgrade.ability_id != upgrade.ability_id)
		
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	print(current_upgrades)


func on_levelup(current_level:int):
	var upgrade_screen = upgrade_screen_scene.instantiate() 
	add_child(upgrade_screen)
	var chosen_upgrades = pick_upgrade()
	upgrade_screen.set_ability_upgradess(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	aply_upgrade(upgrade)
