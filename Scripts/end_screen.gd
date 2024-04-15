extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$%RestartBtn.pressed.connect(on_restart_pressed)


func set_defeat_screen():
	$%TitleLabel.text = "Defeated"
	$%DescLabel.text = "You have been defeated"


func on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Sceenes/main.tscn")
