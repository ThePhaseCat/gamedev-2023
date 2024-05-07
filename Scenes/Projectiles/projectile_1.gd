extends CharacterBody2D



var dir = "right"

var collision

var moving = true

@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(global.pauseOn == false):
		if(moving == true):
			if(dir == "right"):
				move_and_collide(Vector2(2,0))
				collision = move_and_collide(Vector2(2, 0))
				if(collision):
					var name = collision.get_collider().name
					print(name)
					if(name == "testEnemy"):
						collision.get_collider().healthDecreaseFromProjectile()
					elif(name == "player"):
						return #do nothing
					queue_free()
			elif(dir == "left"):
				move_and_collide(Vector2(-2,0))
				collision = move_and_collide(Vector2(-2, 0))
				if(collision):
					var name = collision.get_collider().name
					if(name == "testEnemy"):
						collision.get_collider().healthDecreaseFromProjectile()
					elif(name == "player"):
						return #do nothing
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

func timeToDeath():
	queue_free()
