extends Control


var isPauseActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_pause():
	if(isPauseActive == false):
		visible = true
		isPauseActive = true
		global.pauseOn = true
		print("hi")
		print(self.visible)
		#get_tree().paused = true

func _on_resume_button_pressed():
	if(isPauseActive == true):
		#get_tree().paused = false
		self.hide()
		global.pauseOn = false
		isPauseActive = false


func _on_retry_button_pressed():
	if(isPauseActive == true):
		global.pauseOn = false
		isPauseActive = false
		get_tree().reload_current_scene()


func _on_quit_button_pressed():
	if(isPauseActive == true):
		global.pauseOn = false
		isPauseActive = false
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
