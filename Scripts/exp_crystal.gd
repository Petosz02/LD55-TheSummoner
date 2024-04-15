extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(on_enter)


func tween_collect(percent: float, start_pos: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position = start_pos.lerp(player.global_position, percent)


func  collect():
	GameEvents.emit_exp_collected(1)
	queue_free()


func on_enter(area: Area2D):
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position),0.0,1.0,1.0)
	tween.tween_callback(collect)
	