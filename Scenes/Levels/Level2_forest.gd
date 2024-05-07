extends Node2D

@onready var waterfall = $waterfall

# Called when the node enters the scene tree for the first time.
func _ready():
	waterfall.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_switch_switch_level():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level3_mountain_cave.tscn")
