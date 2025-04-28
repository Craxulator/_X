extends CharacterBody3D

# External Variables (Property Window) 
@export var health = 100 
@export var move_speed = 50 
@export var attack_damage = 25 
@export var attack_range = 100.0
@export var attack_cooldown = 1.0 

#Internal Variables 
var target  
var attack_timer = 0 

#Signals 
signal health_changed(new_health) 
signal enemy_died 

func _ready():
	target = get_tree().get_first_node_in_group("player") 
	#if target:
		#print("Player found") 

func _physics_process(delta):
	if target:
		move_and_attack(delta)
	else:
		pass

func move_and_attack(delta):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	attack_timer += delta
	if attack_timer >= attack_cooldown:
		if global_position.distance_to(target.global_position) <= attack_range:
			attack()
			attack_timer = 0

func attack(): 
	if target: 
		target.take_damage(attack_damage) 
		print("Enemey attacked!") 

func take_damage(damage): 
	health -= damage 
	emit_signal("health_changed", health) 
	
	if health <= 0: 
		die() 

func die(): 
	emit_signal("enemy_died", self) 
	queue_free()

"""  Basic Moevement System Provided by Godot
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
"""
