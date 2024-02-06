extends CharacterBody2D

var dir = "right"

var collision

var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(moving == true):
		if(dir == "right"):
			move_and_collide(Vector2(2,0))
			collision = move_and_collide(Vector2(2, 0))
			if(collision):
				var name = collision.get_collider().name
				if(name == "testEnemy"):
					collision.get_collider().healthDecreaseFromProjectile()
				queue_free()
		elif(dir == "left"):
			move_and_collide(Vector2(-2,0))
			collision = move_and_collide(Vector2(-2, 0))
			if(collision):
				var name = collision.get_collider().name
				if(name == "testEnemy"):
					collision.get_collider().healthDecreaseFromProjectile()
				queue_free()
		else:
			print("this should not print")
	elif(moving == false):
		velocity = Vector2.ZERO
	else:
		pass

func _unhandled_input(event):
	if(Input.is_action_just_pressed("ability_thing")):
		if(moving == true):
			moving = false
			#probably a sound cue or something
		elif(moving == false):
			moving = true
			#probably a sound cue or something
		else:
			pass #don't need anything here?
