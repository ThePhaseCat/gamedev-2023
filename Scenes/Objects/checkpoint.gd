extends Node2D

var checkpointPosX: int = 0
var checkpointPosY: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	checkpointPosX = position.x
	checkpointPosY = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var name = body.get_name()
	if(name == "player"):
		global.checkpointPosition = Vector2(checkpointPosX, checkpointPosY)
		global.hasPlayerHitCheckpoint = true
		print("checkpoint hit!")
