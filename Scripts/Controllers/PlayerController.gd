extends CharacterBody3D

var InputDirection
var MovementDirection
var PreJumpVelocity = Vector3.ZERO
var Hitbox = null

func _ready():
	Hitbox = $Hitbox
	pass

func HandleGravity(DeltaTime):
	if not is_on_floor(): velocity.y -= get_meta("Gravity") * DeltaTime
	pass
	
func HandleJump():
	if not Input.is_action_just_pressed("Jump") or not is_on_floor(): return 
	PreJumpVelocity = velocity
	velocity.y = get_meta("JumpForce")
	
	pass
	
func HandleMovement(DeltaTime):
	var WalkSpeed = get_meta("WalkSpeed")
	var FrictionCoefficient = PI / 10
	
	if MovementDirection:
		velocity.x = MovementDirection.x * WalkSpeed
		velocity.z = MovementDirection.z * WalkSpeed
	else:
		velocity.x -= sign(velocity.x) * FrictionCoefficient
		velocity.z -= sign(velocity.z) * FrictionCoefficient
		
	if velocity.length() < 0.1: velocity = Vector3.ZERO
	pass

func HandleAirMovement(DeltaTime):
	var WalkSpeed = get_meta("WalkSpeed")
	var AirResistance = 0.01 * sqrt(velocity.length()) 
	# Faster velocity means you collide with more air particles
	# It's rooted as the faster you move, the easier you cut through the air
	
	if MovementDirection:
		velocity.x = PreJumpVelocity.x + (MovementDirection.x * WalkSpeed / 2)
		velocity.z = PreJumpVelocity.z + (MovementDirection.z * WalkSpeed / 2)
	else:
		PreJumpVelocity.x -= sign(velocity.x) * AirResistance
		PreJumpVelocity.z -= sign(velocity.z) * AirResistance
	
	pass

func StartSlide():
	print("StartSlide")
	Hitbox.shape.extends.y = Hitbox.shape.extends.z
	Hitbox.shape.extends.z = Hitbox.shape.extends.y
	pass

func HandleSlide(DeltaTime):
	pass
	
func EndSlide():
	pass

func _physics_process(DeltaTime):
	if get_meta("Paused"): return
	
	InputDirection = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	MovementDirection = (transform.basis * Vector3(InputDirection.x, 0, InputDirection.y)).normalized()
	
	HandleGravity(DeltaTime)
	HandleJump()
	
	if Input.is_action_just_pressed("Slide"): StartSlide()
	
	if is_on_floor(): 
		HandleMovement(DeltaTime)
		if get_meta("Sliding"): HandleSlide(DeltaTime)
	else: HandleAirMovement(DeltaTime)
	
	move_and_slide()
	pass

func take_damage(): 
	pass
