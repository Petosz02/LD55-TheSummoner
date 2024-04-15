extends PanelContainer

signal selected

@onready var title_label = $%TitleLabel
@onready var desc_label = $%DescLabel


func _ready():
	gui_input.connect(on_gui_input)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	title_label.text = upgrade.ability_name
	desc_label.text = upgrade.ability_desc


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
