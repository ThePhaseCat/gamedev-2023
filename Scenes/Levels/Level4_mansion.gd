extends Node2D

@onready var lava = $lava

# Called when the node enters the scene tree for the first time.
func _ready():
	lava.play("default")
	MusicManager.playLevel4()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_switch_switch_level():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/cutscenes/Cutscene4.tscn")
	Fade.crossfade_execute()
