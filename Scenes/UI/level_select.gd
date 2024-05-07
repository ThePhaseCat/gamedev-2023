extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#will probably want a fade effect of some kind

func _on_level_1_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
	Fade.crossfade_execute()


func _on_level_2_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2_forest.tscn")
	Fade.crossfade_execute()


func _on_level_3_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level3_mountain_cave.tscn")
	Fade.crossfade_execute()


func _on_level_4_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level4_mansion.tscn")
	Fade.crossfade_execute()


func _on_main_menu_button_pressed():
	Fade.crossfade_prepare(1, "Diamond", false, false)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	Fade.crossfade_execute()
