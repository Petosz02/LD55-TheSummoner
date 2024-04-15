extends CanvasLayer

@export var expManager: Node
@onready var exp_bar = $%ProgressBar

func _ready():
	exp_bar.value = 0
	expManager.exp_update.connect(on_exp_update)


func on_exp_update(current_exp: float, target_exp: float):
	var percent = current_exp/target_exp
	exp_bar.value = percent
