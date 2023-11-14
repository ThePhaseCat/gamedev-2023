extends CharacterBody2D

#test

@export var SPEED = 150

@export var acceleration = 1000
@export var air_acceleration = 400
@export var friction = 1000
@export var air_resistance = 200

@export var gravityScale = 0.8

@export var jump_velocity = -300
  

var air_jump = false
var just_wall_jumped = false
var was_wall_normal = Vector2.ZERO

#other vars
@onready var area2D = $PlayerArea2D

@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var wall_jump_timer = $WallJumpTimer

@onready var animation =$AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#update global player position
	global.playerPosition = position
	
	# Add the gravity.
	handle_gravity(delta)
	
	#handle wall jump and jump
	handle_wallJump()
	handle_jump()
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(direction, delta)
	handle_air_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(direction, delta)
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	just_wall_jumped = false
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()

func _unhandled_input(event):
	if(Input.is_action_just_pressed("attack")):
		if(checks()): #must return true
			print("can attack")

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravityScale * delta

func handle_wallJump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: 
		return #also does nothing
	var wall_normal = get_wall_normal() 
	if wall_jump_timer.time_left > 0.0:
		wall_normal = was_wall_normal
	if Input.is_action_just_pressed("ui_accept"):
		velocity.x = wall_normal.x * SPEED
		velocity.y = jump_velocity
		just_wall_jumped = true

func handle_jump():
	if is_on_floor(): 
		air_jump = true #for double jump
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_pressed("ui_accept"):
			velocity.y = jump_velocity
			coyote_jump_timer.stop()
	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < jump_velocity / 2:
			velocity.y = jump_velocity / 2
		
		if Input.is_action_just_pressed("ui_accept") and air_jump and not just_wall_jumped:
			velocity.y = jump_velocity * 0.8
			air_jump = false

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): 
		return #literally does nothing
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): 
		return #also does nothing
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, air_acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_resistance * delta)

func enemyJump():
	velocity.y = jump_velocity

func checks():
	if(is_on_floor()):
		return true
	else:
		return false

#handle when stuff goes into player
func _on_player_area_2d_area_entered(area):
	var name = area.get_name()
	if(name == "DeathZone"):
		get_tree().reload_current_scene()

func _on_player_area_2d_body_entered(body):
	var name = body.get_name()
	if(name == "testEnemy"):
		get_tree().reload_current_scene()
