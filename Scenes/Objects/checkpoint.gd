extends Node2D

var checkpointPosX: int = 0
var checkpointPosY: int = 0
@onready var sprite = $Sprite
var isThisCheckpointActive: bool = false
@onready var checkpointSound = $checkpointSound

# Called when the node enters the scene tree for the first time.
func _ready():
	checkpointPosX = position.x
	checkpointPosY = position.y
	sprite.frame = 0
	if(global.checkpointPosition == Vector2(checkpointPosX, checkpointPosY)):
		sprite.frame = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var name = body.get_name()
	if(name == "player"):
		checkpointSound.play()
		global.checkpointPosition = Vector2(checkpointPosX, checkpointPosY)
		global.hasPlayerHitCheckpoint = true
		sprite.frame = 1
