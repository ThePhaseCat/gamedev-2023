extends Node2D

@onready var animation = $AnimationPlayer
@onready var projectile = $projectile_thing

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile.play("default")
	animation.play("Cutscene1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func finished():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level4_mansion.tscn")
	Fade.crossfade_execute()
