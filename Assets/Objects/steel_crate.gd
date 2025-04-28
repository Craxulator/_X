extends CharacterBody3D



func _ready():
	_on_CollisionBody3D_body_entered()
	print("test")
	
func _on_CollisionBody3D_body_entered():
	print("collided")
