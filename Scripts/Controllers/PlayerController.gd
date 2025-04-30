extends CharacterBody3D

var InputDirection
var MovementDirection
var PreJumpVelocity = Vector3.ZERO
var Hitbox = null
var StepSliding = false
var SlideStartVelocity = Vector3.ZERO

var SlideJump = false
var WallState = false
var WallTime = 0

func _ready():
	Hitbox = $Hitbox
	pass

func HandleGravity(DeltaTime):
	if not is_on_floor(): velocity.y -= get_meta("Gravity") * DeltaTime
	pass
	
func Jump():
	PreJumpVelocity = velocity
	velocity.y = get_meta("JumpForce")
	pass

func HandleJump():
	if not Input.is_action_just_pressed("Jump"): return
	if get_meta("CanFly"): Jump(); return
	
	if StepSliding:
		print("Is-On-Floor: " + str(is_on_floor()))
		return
		
	if not is_on_floor(): pass
	else: Jump()
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

func HandleAirMovement():
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
	SlideStartVelocity = velocity
	
	StepSliding = true
	var SavedY = Hitbox.shape.size.y
	Hitbox.shape.size.y = Hitbox.shape.size.z
	Hitbox.shape.size.z = SavedY
	SavedY = null
	
	set_meta("Sliding", true)
	pass

func HandleSlide(DeltaTime):
	velocity.x = MovementDirection.x * SlideStartVelocity.length()
	velocity.z = MovementDirection.z * SlideStartVelocity.length()
	pass
	
func EndSlide():
	StepSliding = false
	
	var SavedY = Hitbox.shape.size.y
	Hitbox.shape.size.y = Hitbox.shape.size.z
	Hitbox.shape.size.z = SavedY
	SavedY = null
	
	if not SlideJump:
		position.y += Hitbox.shape.size.y / 2.4
		
func ChangeWallState(IsOnWall):
	WallState = IsOnWall
	if is_on_floor(): return
	print(IsOnWall)
	pass
		
func HandleWallSlide(DeltaTime):
	
	pass

func _physics_process(DeltaTime):
	if get_meta("Paused"): return
	
	InputDirection = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	MovementDirection = (transform.basis * Vector3(InputDirection.x, 0, InputDirection.y)).normalized()
	
	HandleGravity(DeltaTime)
	HandleJump()
	
	if Input.is_action_just_pressed("Slide"): StartSlide()
	
	if Input.is_action_just_released("Slide"):
		set_meta("Sliding", false)
		if is_on_floor(): EndSlide()
	
	if is_on_floor(): 
		if StepSliding && not get_meta("Sliding"): EndSlide()
		if get_meta("Sliding"): HandleSlide(DeltaTime)
		elif not WallState: HandleMovement(DeltaTime)
	else: 
		if not get_meta("Sliding"): HandleAirMovement()
		
	if is_on_wall() and not WallState: ChangeWallState(true)
	elif WallState: ChangeWallState(false)	
	if WallState and not is_on_floor(): HandleWallSlide(DeltaTime)
	
	move_and_slide()
	pass

func take_damage(): 
	pass
