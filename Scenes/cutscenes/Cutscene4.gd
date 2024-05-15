extends Node2D

@onready var animation = $AnimationPlayer
@onready var boneHead = $bone/boneHead
@onready var projectile = $AnimatedSprite2D
@onready var fire = $fire

# Called when the node enters the scene tree for the first time.
func _ready():
	boneHead.play("default")
	projectile.play("default")
	fire.play("default")
	MusicManager.playCutscene4()
	animation.play("cutscene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func finished():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/UI/win_screen.tscn")
	Fade.crossfade_execute()
