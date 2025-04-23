extends Camera3D

var Paused : bool = false
var Player

#func _init():
	#pass
	
func _ready():
	Player = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass
	
func Pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
	
func UnPause():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _process(DeltaTime):
	if Input.is_action_just_pressed("Pause"): 
		Paused = not Paused
		Player.set_meta("Paused", Paused)
		if Paused: Pause()
		else: UnPause()
		
	if Input.is_action_pressed("Slide"):
		Player.set_meta("Sliding", true)
	else: Player.set_meta("Sliding", false)
		
	if Paused: return
	
	var VIEWPORT = get_viewport()
	var MOUSE_POSITION = VIEWPORT.get_mouse_position()
	var MOUSE_POSITION_CENTERED = Vector2(MOUSE_POSITION.x - VIEWPORT.size.x / 2, MOUSE_POSITION.y - VIEWPORT.size.y / 2)
	var MOUSE_ROTATION_VECTOR = Vector3(-MOUSE_POSITION_CENTERED.y, -MOUSE_POSITION_CENTERED.x, 0) * DeltaTime * get_meta("Sensitivity")
	
	if get_window().has_focus(): 
		rotation_degrees.x += MOUSE_ROTATION_VECTOR.x
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		get_parent_node_3d().rotation_degrees.y += MOUSE_ROTATION_VECTOR.y
		Input.warp_mouse(get_viewport().size / 2)
	pass

#func _input(Event):
	#if Event is not InputEventMouseMotion: return
