extends CanvasLayer

@onready var coinText = $coinLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coinText.set_text("Coins: " + str(global.amountOfCoins))
