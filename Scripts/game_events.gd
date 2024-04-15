extends Node

signal exp_collected(number:float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

func emit_exp_collected(number: float):
	exp_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
