extends Node2D

signal fin_du_tour_joueur
signal player_moved(position_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event): 
	var deplacement = Vector2.ZERO
	if event.is_action_pressed("ui_haut") and not($RayCastHaut.is_colliding()) :
		deplacement.y = - Global.pixelHauteur 
		$Sprite.global_rotation_degrees = 90 
		$Sprite.flip_h = false 
	if event.is_action_pressed("ui_bas") and not($RayCastBas.is_colliding()):
		deplacement.y =  Global.pixelHauteur 
		$Sprite.global_rotation_degrees = -90 
		$Sprite.flip_h = false 
	if event.is_action_pressed("ui_gauche") and not($RayCastGauche.is_colliding()):
		deplacement.x = - Global.pixelLargeur 
		$Sprite.global_rotation_degrees = 0 
		$Sprite.flip_h = false 
	if event.is_action_pressed("ui_droite") and not($RayCastDroite.is_colliding()):
		deplacement.x =  Global.pixelLargeur 
		$Sprite.global_rotation_degrees = 0 
		$Sprite.flip_h = true 
	self.global_position += deplacement
	emit_signal("player_moved",self.global_position.y)


func _on_timer_timeout():
	emit_signal("fin_du_tour_joueur")
	$Timer.start()
