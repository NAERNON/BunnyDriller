extends Node2D

signal fin_du_tour_joueur
signal player_moved(position_y)
signal first_move_player

signal racine_coupee(pRacine)

var very_first_move = true
var first_move
var moving = false
var startDrill = false
var drilling = false
var input_buffer = []
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("Idle")
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	deplacement()
	if moving :
		if startDrill :
			$Drilling.play()
			startDrill = false
	else :
		$Drilling.stop()

func _input(event): 
	#Récupération de l'input dans un buffer
	if input_buffer.size() < 2 :
		if event.is_action_pressed("ui_haut") :
			input_buffer.push_back("H")
		elif event.is_action_pressed("ui_bas"):
			input_buffer.push_back("B")
		elif event.is_action_pressed("ui_gauche") :
			input_buffer.push_back("G")
		elif event.is_action_pressed("ui_droite"):
			input_buffer.push_back("D")
		


func deplacement(): 
	if not(input_buffer.is_empty()):
		if very_first_move:
			emit_signal("first_move_player")
			very_first_move = false
		var action = input_buffer[0]
		if not(moving) and not(action==null) :
			$Sprite.stop()
			$Sprite.play("Action")
			var deplacement = Vector2.ZERO
			if action == "H" :
				$Sprite.global_rotation_degrees = 0 
				$Sprite.flip_v = true 
				if not($RayCastHaut.is_colliding()) or $RayCastHaut.get_collider().get_parent().is_in_group("Racine"): 
					deplacement.y = - Global.pixelHauteur 
					if $RayCastHaut.is_colliding() and $RayCastHaut.get_collider().get_parent().is_in_group("Racine"):
						emit_signal("racine_coupee",$RayCastHaut.get_collider().get_parent())
			if action == "B" :
				$Sprite.global_rotation_degrees = 0
				$Sprite.flip_v = false 
				if not($RayCastBas.is_colliding()) or $RayCastBas.get_collider().get_parent().is_in_group("Racine"): 
					deplacement.y =  Global.pixelHauteur 
					if $RayCastBas.is_colliding() and $RayCastBas.get_collider().get_parent().is_in_group("Racine"):
						emit_signal("racine_coupee",$RayCastBas.get_collider().get_parent())
			if action == "G" :
				$Sprite.global_rotation_degrees = 90 
				$Sprite.flip_v = false 
				if not($RayCastGauche.is_colliding()) or $RayCastGauche.get_collider().get_parent().is_in_group("Racine"): 
					deplacement.x = - Global.pixelLargeur 
					if $RayCastGauche.is_colliding() and $RayCastGauche.get_collider().get_parent().is_in_group("Racine"):
						emit_signal("racine_coupee",$RayCastGauche.get_collider().get_parent())
			if action == "D" :
					$Sprite.global_rotation_degrees = -90 
					$Sprite.flip_v = false
					if not($RayCastDroite.is_colliding()) or $RayCastDroite.get_collider().get_parent().is_in_group("Racine"): 
						deplacement.x =  Global.pixelLargeur 
						if $RayCastDroite.is_colliding() and $RayCastDroite.get_collider().get_parent().is_in_group("Racine"):
							emit_signal("racine_coupee",$RayCastDroite.get_collider().get_parent())
			if deplacement != Vector2.ZERO:
				if first_move :
					startDrill = true
					first_move = false
			self.global_position += deplacement
			emit_signal("player_moved",self.global_position.y)
			moving = true
			input_buffer.remove_at(0)

func _on_timer_timeout():
	emit_signal("fin_du_tour_joueur")
	$Timer.start()


func _on_sprite_animation_finished():
	if $Sprite.animation == "Action" :
		moving = false
		first_move = true
		$Sprite.play("Idle")
