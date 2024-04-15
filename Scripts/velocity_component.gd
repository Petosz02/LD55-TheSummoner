extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
var velocity = Vector2.ZERO

func accelerate_player():
	var owner_node2D = owner as Node2D
	if owner_node2D == null:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2D.global_position).normalized()
	accelerate_dir(direction)


func accelerate_dir(direction: Vector2):
	var desired_vel = direction * max_speed
	velocity = velocity.lerp(desired_vel, 1.0 - exp(-acceleration * get_process_delta_time()))


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
