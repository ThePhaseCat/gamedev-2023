extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	#play sound maybe? idk
	get_tree().quit()


func _on_start_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
	Fade.crossfade_execute()


func _on_level_select_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/UI/level_select.tscn")
	Fade.crossfade_execute()
