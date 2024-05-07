extends Node2D


signal switchLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var name = body.get_name()
	#print(name)
	if(name == "player"):
		emit_signal("switchLevel")
