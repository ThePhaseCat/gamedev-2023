extends Node2D

@onready var waterfall = $waterfall

# Called when the node enters the scene tree for the first time.
func _ready():
	waterfall.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
