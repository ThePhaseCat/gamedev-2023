extends Node2D

@onready var animation = $AnimationPlayer
@onready var coinSound = $coinSound
var already_collected: bool = false
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("up_and_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var name = body.get_name()
	if (name == "player"):
		if(already_collected == true):
			pass
		else:
			sprite.visible = false
			global.amountOfCoins = global.amountOfCoins + 1
			coinSound.play()


func _on_coin_sound_finished():
	queue_free()
