extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	Fade.crossfade_execute()
