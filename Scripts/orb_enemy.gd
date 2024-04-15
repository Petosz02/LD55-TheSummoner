extends CharacterBody2D

@onready var velocity_component = $VelocityComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity_component.accelerate_player()
	velocity_component.move(self)
