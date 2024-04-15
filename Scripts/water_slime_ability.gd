extends CharacterBody2D

@export var max_speed = 40
@export var acceleration = 20
@export var attack_range = 200
@export var self_damage:float = 1
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit_box: HitBox = $HitBox
@onready var timer = $SelfDamageTimer


func _ready():
	timer.timeout.connect(on_timeout)
	health_component.health_changed.connect(on_health_changed)
	on_health_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = get_direction()
	var target_speed = dir * max_speed
	velocity = velocity.lerp(target_speed, 1.0 - exp(-delta * acceleration))
	move_and_slide()


func get_direction():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var target_enemi = get_closest_enemi()
	if target_enemi != null:
		return (target_enemi.global_position - global_position).normalized()
	return (player.global_position - global_position).normalized()


func get_closest_enemi():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(attack_range, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	return enemies[0]


func on_health_changed():
	$HealthBar.value = health_component.get_healt_percent()


func on_timeout():
	health_component.damage(self_damage)
