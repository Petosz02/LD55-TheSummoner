extends CharacterBody2D

@export var max_speed = 150
@export var acceleration = 10

@onready var damage_timer = $DamageTimer
@onready var health_component = $HealthComponent
@onready var ability_manager = $AbilityManager

var number_collided_bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionArea.body_entered.connect(on_body_entered)
	$CollisionArea.body_exited.connect(on_body_exited)
	damage_timer.timeout.connect(on_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	on_health_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = get_move_dir()
	movement = movement.normalized()
	var target_speed = movement * max_speed
	velocity = velocity.lerp(target_speed, 1.0 - exp(-delta * acceleration))
	move_and_slide()


func get_move_dir():
	var move_dir = Vector2.ZERO
	var x_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_dir = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_dir = Vector2(x_dir,y_dir)
	return move_dir 


func check_deal_damage():
	if number_collided_bodies == 0 || !damage_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_timer.start()
	print(health_component.current_health)


func on_body_entered(area: Node2D):
	number_collided_bodies += 1
	check_deal_damage()


func on_body_exited(area: Node2D):
	number_collided_bodies -= 1


func on_timeout():
	check_deal_damage()


func on_health_changed():
	$HealthBar.value = health_component.get_healt_percent()


func on_ability_upgrade_added(ability: AbilityUpgrade, current_upgrades: Dictionary):
	if not ability is Ability:
		return
	var new_ability = ability as Ability
	ability_manager.add_child(new_ability.ability_controller_scene.instantiate())
	
