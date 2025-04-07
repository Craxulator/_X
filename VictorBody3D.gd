extends "res://enemy.gd" # Replace with your Enemy class's path

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
	if target:
		target.take_damage(attack_damage)
		print("V.I.C.T.O.R. attacked!")
