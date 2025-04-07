extends "res://enemy.gd"

@export var projectile_scene : PackedScene
@export var projectile_speed = 10.0
@export var projectile_damage = 15
@export var fire_rate = 2.0 # Attacks per second

var fire_timer = 0.0

func _ready():
	move_speed = 0.0 # Stationary
	attack_range = 20.0 # Long range

func _physics_process(delta):
	fire_timer += delta
	if fire_timer >= 1.0 / fire_rate:
		attack()
		fire_timer = 0.0

func attack():
	if target:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		get_parent().add_child(projectile)

		# Rotate to face the target.
		projectile.transform.basis = (target.global_position - global_position).looking_at(Vector3.UP)

		# Give the projectile velocity.
		projectile.velocity = (target.global_position - global_position).normalized() * projectile_speed
		projectile.damage = projectile_damage

		print("R.A.N.D.E. fired!")
