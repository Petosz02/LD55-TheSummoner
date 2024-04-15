extends Node2D

@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func start(text: String):
	label.text = text
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2.UP * 16, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", global_position + Vector2.UP * 46, .5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
