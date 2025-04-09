extends CharacterBody3D

var Player = null

func _ready():
	Player = get_parent_node_3d()
	pass

func HandleGravity(DeltaTime):
	if not is_on_floor(): velocity.y -= Player.get_meta("Gravity") * DeltaTime
	pass
	
func HandleJump():
	if Input.is_action_pressed("Jump") and is_on_floor(): velocity.y = Player.get_meta("JumpForce")
	pass
	
func HandleMovement(DeltaTime):
	var WalkSpeed = Player.get_meta("WalkSpeed")
	
	var InputDirection = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var MovementDirection = (transform.basis * Vector3(InputDirection.x, 0, InputDirection.y)).normalized()
	
	if MovementDirection:
		velocity.x = MovementDirection.x * WalkSpeed
		velocity.z = MovementDirection.z * WalkSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, WalkSpeed)
		velocity.z = move_toward(velocity.z, 0, WalkSpeed)
	pass

func _physics_process(DeltaTime):
	HandleGravity(DeltaTime)
	HandleJump()
	HandleMovement(DeltaTime)
	move_and_slide()
	pass
