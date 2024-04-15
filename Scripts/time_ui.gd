extends CanvasLayer

@export var time_time_manager: Node
@onready var label = $%Label

func _process(delta):
	var time_left = time_time_manager.get_elapsed_time()
	label.text = format(time_left)


func format(sec: float):
	var mins = floor(sec/60)
	var secs = sec - mins * 60
	return str(mins) + ":" + ("%02d" %(secs))
