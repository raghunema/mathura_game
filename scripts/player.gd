extends CharacterBody3D
class_name  Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const PICK_RAY_LENTH = 10
const ROTATION_SENS = 0.005 #degrees?

@onready var head = $Head
@onready var camera = $Head/Camera3D
var pitch: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: 
		head.rotate_y(-event.relative.x * ROTATION_SENS)

		print(event)
	
		pitch -= event.relative.y * ROTATION_SENS
		pitch = clamp(pitch, deg_to_rad(-15), deg_to_rad(15))
		camera.rotation.x = pitch


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	
	var origin = camera.project_ray_origin(mouse_pos)
	# var mouse_direction = camera.project_ray_normal(mouse_pos) 

	var end = origin + camera.project_ray_normal(mouse_pos) * PICK_RAY_LENTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.exclude = [get_rid()] #exclude the object

	var result:Dictionary = space_state.intersect_ray(query)
	
	
	# var target: Vector3 = origin + mouse_direction * 10.0
	# look_at(target, Vector3.UP)
	if not result.is_empty(): 
		print(result)

	move_and_slide()
