extends CharacterBody2D

var hp = 5

var speed = 100
var gravity = 20

var is_moving_left = true

@onready var ray = $RayCast2D

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

func detect_turn_around():
	if(not ray.is_colliding()):
		is_moving_left = !is_moving_left
		scale.x = -scale.x

func _on_area_2d_body_entered(body):
	var name = body.get_name()
	if(name == "player"):
		body.enemyJump()
		death()


func _on_attack_check_area_entered(area):
	hp = hp - 1
	if(hp == 0):
		death()

func death():
	queue_free()
