extends CharacterBody2D

var hp = 25

var speed = 100
var gravity = 20

var is_moving_left = true

@onready var ray = $RayCast2D
@onready var ray2 = $RayCast2D2

var attackNodeInArea = false
var attackingNode = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not is_on_floor()):
		velocity.y += gravity * delta
	
	if(is_moving_left == true):
		velocity.x = speed
	else:
		velocity.x = -speed
	#velocity.x = speed if is_moving_left else -speed
	detect_turn_around()
	
	move_and_slide()
	
	if(attackNodeInArea == true):
		if(attackingNode.attacking == true):
			print("HP: " + str(hp))
			hp = hp - 1
			await get_tree().create_timer(0.5).timeout
			if(hp <= 0):
				death()

func detect_turn_around():
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
	queue_free()


func _on_attack_check_area_exited(area):
	attackNodeInArea = false
	attackingNode = null
