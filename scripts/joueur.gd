extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event): 
	var deplacement = Vector2.ZERO
	if event.is_action_pressed("ui_haut"):
		deplacement.y = - Global.pixelHeigth 
	if event.is_action_pressed("ui_bas"):
		deplacement.y =  Global.pixelHeigth 
	if event.is_action_pressed("ui_gauche"):
		deplacement.x = - Global.pixelHeigth 
	if event.is_action_pressed("ui_droite"):
		deplacement.x =  Global.pixelHeigth 
	self.global_position += deplacement
