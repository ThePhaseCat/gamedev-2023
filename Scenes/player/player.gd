extends CharacterBody2D

#test

@export var SPEED = 150
@export var DASH_SPEED = 300
@export var AIR_DASH_SPEED = 400
var dashing = false
var can_dash = true

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

@onready var animation = $AnimationPlayer

@onready var PlayerSwordAttack = $PlayerSwordAttack

@onready var sprite = $AnimatedSprite2D
@onready var scratchSprite = $scratchsprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var playerFacingDirection = "right"

var canAttack = true

var canShootProjectile = true

var attacking = false

var timesWallJumped = 0

#projectile stuff
var projectile1 = preload("res://Scenes/Projectiles/projectile_1.tscn")

#timer
@onready var dash_timer = $dash_timer
@onready var dash_again_timer = $dash_again_timer
@onready var projectile_fire_timer = $projectile_fire_timer
@onready var frameStop = $frameStop
var frameReady: bool = false

#menu
@onready var pause_menu = $PauseMenu

#sound
@onready var shootSound = $shootSound
@onready var jumpSound = $jumpSound
@onready var jump2Sound = $jump2Sound
@onready var swipeSound = $swipeSound
@onready var dashSound = $dashSound

func _ready():
	frameStop.start()
	position = global.playerPosition
	pause_menu.isPauseActive = false
	scratchSprite.hide()
	if(global.hasPlayerHitCheckpoint == true):
		position = global.checkpointPosition
	else:
		pass

func _physics_process(delta):
	if(position == Vector2(2128, -660)):
		if(global.hasPlayerHitCheckpoint == true):
			position = global.checkpointPosition
		else:
			#print("HI")
			position = Vector2(188, 144)
	if(frameReady):
		#update global player position
		#print(global.playerPosition)
		global.playerPosition = position
		
		# Add the gravity.
		handle_gravity(delta)
		
		#handle wall jump and jump
		handle_wallJump()
		handle_jump()
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("move_left", "move_right")
		handle_acceleration(direction, delta)
		handle_air_acceleration(direction, delta)
		apply_friction(direction, delta)
		apply_air_resistance(direction, delta)
		
		var was_on_floor = is_on_floor()
		var was_on_wall = is_on_wall_only()
		if was_on_wall:
			was_wall_normal = get_wall_normal()
		if(global.pauseOn == false):
			move_and_slide()
		var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
		if just_left_ledge:
			coyote_jump_timer.start()
		just_wall_jumped = false
		var just_left_wall = was_on_wall and not is_on_wall()
		if just_left_wall:
			wall_jump_timer.start()
			timesWallJumped = timesWallJumped - 1
		
		handle_animations(direction)
		
		#sprite.flip_h = velocity.x < 0

func _unhandled_input(event):
	if(Input.is_action_just_pressed("move_left")):
		if(frameReady):
			playerFacingDirection = "left"
			sprite.offset = Vector2(-7, 0)
			sprite.flip_h = true
	if(Input.is_action_just_pressed("move_right")):
		if(frameReady):
			playerFacingDirection = "right"
			sprite.offset = Vector2.ZERO
			sprite.flip_h = false
	
	if(Input.is_action_just_pressed("attack")):
		if(checks()): #must return true
			if(canAttack == true):
				if(PlayerSwordAttack.attacking == false):
					if(animation.is_playing() == true):
						pass #don't do anything
					else:
						canAttack = false
						PlayerSwordAttack.attacking = true
						swipeSound.play()
						if(playerFacingDirection == "left"):
							animation.play("attackLeft")
							sprite.play("scratch")
						else:
							animation.play("attackRight")
							sprite.play("scratch")
	
	if(Input.is_action_just_pressed("dash") and can_dash == true and just_wall_jumped == false):
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_again_timer.start()
		dashSound.play()
	
	if(Input.is_action_just_pressed("ranged_attack")):
		if(canShootProjectile == true):
			shootSound.play()
			projectileAttack1()
	
	if(Input.is_action_just_pressed("pause") and is_on_floor()):
		pause_menu.show_pause()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravityScale * delta

func handle_wallJump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: 
		return #also does nothing
	var wall_normal = get_wall_normal() 
	if wall_jump_timer.time_left > 0.0:
		wall_normal = was_wall_normal
	if Input.is_action_just_pressed("jump") and timesWallJumped <= 3:
		#jump2Sound.play()
		velocity.x = wall_normal.x * SPEED
		velocity.y = jump_velocity
		timesWallJumped = timesWallJumped + 1
		just_wall_jumped = true

func handle_jump():
	if is_on_floor(): 
		air_jump = true #for double jump
		can_dash = true
		timesWallJumped = 0
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_pressed("jump"):
			jumpSound.play()
			velocity.y = jump_velocity
			coyote_jump_timer.stop()
			sprite.play("jump")
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < jump_velocity / 2:
			velocity.y = jump_velocity / 2
			sprite.play("jump")
			jump2Sound.play()
		
		if Input.is_action_just_pressed("jump") and air_jump and not just_wall_jumped:
			velocity.y = jump_velocity * 0.8
			air_jump = false
			sprite.play("jump")
			jump2Sound.play()

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): 
		return #literally does nothing
	if input_axis != 0:
		if(dashing == true):
			velocity.x = input_axis * DASH_SPEED
		else:
			velocity.x = input_axis * SPEED
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		#if(input_axis == 1):
			#playerFacingDirection = "right"
		#else:
			#playerFacingDirection = "left"

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): 
		return #also does nothing
	if input_axis != 0:
		if(dashing == true):
			velocity.x = input_axis * AIR_DASH_SPEED
			velocity.y = 0
		else:
			velocity.x = input_axis * SPEED
		velocity.x = move_toward(velocity.x, 0, air_acceleration * delta)

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
		global.amountOfCoins = 0
		get_tree().reload_current_scene()

func _on_player_area_2d_body_entered(body):
	pass


func actualDeath():
	if(global.hasPlayerHitCheckpoint == true):
		pass
	else:
		global.amountOfCoins = 0
	
	get_tree().reload_current_scene()

func mainAttackAnimationFinished(): #called when main attack animation (either left or right) is finished
	canAttack = true
	PlayerSwordAttack.attacking = false

func handle_animations(dir):
	if(canAttack == false and PlayerSwordAttack.attacking == true):
		pass
	else:
		if(velocity == Vector2.ZERO):
			sprite.play("idle")
			#if(playerFacingDirection == "left"):
				#sprite.flip_h = true
			#elif(playerFacingDirection == "right"):
				#sprite.flip_h = false
		else:
			if(is_on_floor() == true):
				sprite.play("walk")
				#if(playerFacingDirection == "left"):
					#sprite.flip_h = true
				#elif(playerFacingDirection == "right"):
					#sprite.flip_h = false

func projectileAttack1():
	var projectile = projectile1.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.global_position.y = projectile.global_position.y - 20
	canShootProjectile = false
	projectile_fire_timer.start()
	if(playerFacingDirection == "left"):
		projectile.dir = "left"
	elif(playerFacingDirection == "right"):
		projectile.dir = "right"
	else:
		print("this shouldn't happen")


func _on_dash_timer_timeout():
	dashing = false


func _on_dash_again_timer_timeout():
	if(just_wall_jumped == true):
		return #do nothing
	else:
		can_dash = true


func _on_projectile_fire_timer_timeout():
	canShootProjectile = true


func _on_frame_stop_timeout():
	frameReady = true
