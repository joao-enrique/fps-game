extends CharacterBody3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.3
		$Camera3D.rotation_degrees.x -= event.relative.y * 0.3
		$Camera3D.rotation_degrees.x = clamp(
			$Camera3D.rotation_degrees.x, -80.0, 80.0
		)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func _physics_process(delta):
	const SPEED = 5.5 
	
	var input_direction_2D = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
