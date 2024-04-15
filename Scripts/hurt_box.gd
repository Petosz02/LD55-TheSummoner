extends Area2D
class_name HurtBox

@onready var dot = $DOT
@export var healt_component: HealthComponent
@export var float_text: PackedScene

var colliding_bodies = 0
var dot_damage = 0

func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	dot.timeout.connect(on_timeout)


func get_damage(dmg: float):
	if colliding_bodies == 0 || !dot.is_stopped():
		return
	
	healt_component.damage(dmg)
	
	if !owner.is_in_group("slime"):
		var float_text_instace = float_text.instantiate()
		get_tree().get_first_node_in_group("abilities_layer").add_child(float_text_instace)	
		float_text_instace.global_position = global_position
		float_text_instace.start(str(dmg))
	
	dot.start()


func on_timeout():
	get_damage(dot_damage)


func on_area_entered(area: Area2D):
	if not area is HitBox:
		return
	
	if healt_component == null:
		return
	
	colliding_bodies += 1
	var hitbox = area as HitBox
	get_damage(hitbox.damage)
	dot_damage = hitbox.damage

func on_area_exited(area: Area2D):
	if not area is HitBox:
		return
	
	if healt_component == null:
		return
		
	colliding_bodies -= 1
