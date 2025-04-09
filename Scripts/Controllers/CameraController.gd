extends Camera3D

var Paused : bool = false

#func _init():
	#pass
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass
	
func Pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _process(DeltaTime):
	if Input.is_action_just_pressed("Pause"): 
		Paused = not Paused
		if Paused: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Pause()
	if Paused: return
	
	var VIEWPORT = get_viewport()
	var MOUSE_POSITION = VIEWPORT.get_mouse_position()
	var MOUSE_POSITION_CENTERED = Vector2(MOUSE_POSITION.x - VIEWPORT.size.x / 2, MOUSE_POSITION.y - VIEWPORT.size.y / 2)
	var MOUSE_ROTATION_VECTOR = Vector3(-MOUSE_POSITION_CENTERED.y, -MOUSE_POSITION_CENTERED.x, 0)
	
	if get_window().has_focus(): 
		rotation_degrees += MOUSE_ROTATION_VECTOR * DeltaTime * get_meta("Sensitivity")
		Input.warp_mouse(get_viewport().size / 2)
	pass

#func _input(Event):
	#if Event is not InputEventMouseMotion: return
