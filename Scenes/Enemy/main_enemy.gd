extends CharacterBody2D

var hp = 20

var speed = 50
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_moving_left = true

@onready var deathSound = $deathSound

@onready var ray = $RayCast2D
@onready var ray2 = $RayCast2D2
@onready var sprite = $AnimatedSprite2D
@onready var deathEffect = preload("res://enemy_death_effect.tscn")
@onready var playerCheck = $PlayerCheck

var attackNodeInArea = false
var attackingNode = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not is_on_floor()):
		#print("hi")
		velocity.y += gravity * delta
		#print(str(velocity.y))
	
	if(is_moving_left == true):
		velocity.x = speed
	else:
		velocity.x = -speed
	#velocity.x = speed if is_moving_left else -speed
	detect_turn_around()
	
	if(global.pauseOn == false):
		move_and_slide()
	
	if(hp <= 0):
		death()
	
	if(attackNodeInArea == true):
		if(attackingNode.attacking == true):
			#print("HP: " + str(hp))
			hp = hp - 1
			await get_tree().create_timer(0.5).timeout

func wait(duration):
	await get_tree().create_timer(duration,false,false,true).timeout

func detect_turn_around():
	if(is_on_floor()):
		if(not ray.is_colliding()):
			is_moving_left = !is_moving_left
			scale.x = -scale.x
		elif(ray2.is_colliding()):
			if(ray2.get_collider().get_name() == "player"):
				return #do nothing because turn around shouldn't happen with player
			else:
				is_moving_left = !is_moving_left
				scale.x = -scale.x
		else:
			pass
	else:
		pass
		#print("not on floor, can't turn around?")

func _on_area_2d_body_entered(body):
	var name = body.get_name()
	if(name == "player"):
		body.enemyJump()
		death()


func _on_attack_check_area_entered(area):
	attackNodeInArea = true
	attackingNode = area
	#hp = hp - 1
	#if(hp == 0):
	#	death()

func death():
	DeathSoundManager.play()
	#deathSound.play()
	var jumpDust = deathEffect.instantiate()
	jumpDust.emitting = true
	get_parent().add_child(jumpDust)
	jumpDust.global_position = global_position
	queue_free()

func healthDecreaseFromProjectile():
	hp = hp - 5
	#print("hp + " + str(hp))

func _on_attack_check_area_exited(area):
	attackNodeInArea = false
	attackingNode = null


func _on_player_check_body_entered(body):
	var name = body.get_name()
	#print(name)
	if(name == "player"):
		playerCheck.monitoring = false
		body.actualDeath()


func _on_attack_check_body_entered(body):
	var name = body.get_name()
	#print(name)
	if(name == "Projectile1"):
		hp = hp - 10
		#print("HP: " + str(hp))
		body.timeToDeath()
