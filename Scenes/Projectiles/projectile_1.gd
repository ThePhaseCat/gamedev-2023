extends CharacterBody2D

var dir = "right"

var collision

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			print(name)
			if(name == "testEnemy"):
				collision.get_collider().healthDecreaseFromProjectile()
			queue_free()
