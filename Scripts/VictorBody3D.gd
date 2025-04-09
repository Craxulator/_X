extends "res://Scripts/Controllers/EnemyController.gd" 

@export var explosion_scene : PackedScene
@export var explosion_damage = 50
@export var explosion_radius = 3.0

@onready var collide = $collider
func _ready():
	move_speed = 8.0 # Fast movement
	attack_range = 2.0 # Short range
	attack_damage = 25 # High damage

func move_and_attack(delta):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	attack_timer += delta
	if attack_timer >= attack_cooldown:
		if global_position.distance_to(target.global_position) <= attack_range:
			attack()
			attack_timer = 0.0

func attack():
	pass 

func die(): 
	explode() 
	queue_free() 

func explode(): 
	if explosion_scene: 
		var explosion = load("res://Scenes/explosion.tscn").instantiate() 
		explosion.global_position = global_position 
		get_parent().add_child(explosion) 
		
		#Apply damage to player if in range 
		var bodies = explosion.get_node("Area3D").get_overlapping_bodies() 
		for body in bodies: 
			if body.is_in_group("player"): 
				body.take_damage(explosion_damage) 
		
		# Destroy explosion
		call_deferred("destroy_explosion", explosion)

func destroy_explosion(explosion):
	await get_tree().create_timer(0.5).timeout # 0.5 sec delay
	if is_instance_valid(explosion):
		explosion.queue_free()
