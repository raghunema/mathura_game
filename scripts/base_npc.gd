extends RigidBody3D

class_name Base_NPC

@onready var GameController = $"/root/GameController"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass

#func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
		#print("Mouse click detected globally")

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print('(npc) npc clicked ', name)
		GameController.request_conversation(name)
