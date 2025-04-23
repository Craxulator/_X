extends CharacterBody3D

@export var projectile_scene : PackedScene
@export var projectile_speed = 10.0
@export var projectile_damage = 15
@export var fire_rate = 2.0 # Attacks per second

var fire_timer = 0.0

# External Variables (Property Window)
@export var health = 100
@export var move_speed = 50
@export var attack_damage = 25
@export var attack_range = 100.0
@export var attack_cooldown = 1.0

var target : CharacterBody3D # Declare target at the class level
var attack_timer = 0

#Signals
signal health_changed(new_health)
signal enemy_died

func _ready():
	print("Something")

func _physics_process(delta):
	target = get_tree().get_first_node_in_group("player")
	if target:
		move_and_attack(delta) # No need to pass target again, class-level is updated
	else:
		print("Player not found!")

func move_and_attack(delta):
	if target:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * move_speed
		move_and_slide()

		attack_timer += delta
		if global_position.distance_to(target.global_position) <= attack_range:
			# Your attack logic here
			pass

func die():
	emit_signal("enemy_died", self)
	queue_free()
