extends CharacterBody3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.3
		$Camera3D.rotation_degrees.x -= event.relative.y * 0.3
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -80.0, 80.0)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func _physics_process(delta):
	var SPEED = 5.5 
	var RUN_MULTIPLIER = 2.0
	
	# Se o jogador estiver segurando "run", aumenta a velocidade
	if Input.is_action_pressed("run"):
		SPEED *= RUN_MULTIPLIER
	
	var input_direction_2D = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var input_direction_3D = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	# Gravidade e pulo
	velocity.y -= 20.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	move_and_slide()
	
	# Tiro
	if Input.is_action_pressed("shoot") and $Timer.is_stopped():
		shoot_bullet()

func shoot_bullet():
	const BULLET_3D = preload("res://player/bullet_3d.tscn")
	var new_bullet = BULLET_3D.instantiate()
	$Camera3D/Marker3D.add_child(new_bullet)
	new_bullet.global_transform = $Camera3D/Marker3D.global_transform
	$Timer.start()
