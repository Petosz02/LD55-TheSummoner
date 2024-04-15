extends Node

@export var end_screen_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$%Player.health_component.died.connect(on_player_died)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat_screen()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
