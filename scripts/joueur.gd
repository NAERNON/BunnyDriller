extends Node2D

signal fin_du_tour_joueur
signal player_moved(position_y)

var moving = false
var input_buffer = []
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("Idle")
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	deplacement()

func _input(event): 
	#Récupération de l'input dans un buffer
	
	if event.is_action_pressed("ui_haut") :
		input_buffer.push_back("H")
	elif event.is_action_pressed("ui_bas"):
		input_buffer.push_back("B")
	elif event.is_action_pressed("ui_gauche") :
		input_buffer.push_back("G")
	elif event.is_action_pressed("ui_droite"):
		input_buffer.push_back("D")
		
	print(input_buffer)


func deplacement(): 
	if not(input_buffer.is_empty()):
		var action = input_buffer[0]
		if not(moving) and not(action==null) :
			$Sprite.stop()
			$Sprite.play("Action")
			var deplacement = Vector2.ZERO
			if action == "H" and not($RayCastHaut.is_colliding()) :
				deplacement.y = - Global.pixelHauteur 
				$Sprite.global_rotation_degrees = 0 
				$Sprite.flip_v = true 
			if action == "B"  and not($RayCastBas.is_colliding()):
				deplacement.y =  Global.pixelHauteur 
				$Sprite.global_rotation_degrees = 0
				$Sprite.flip_v = false 
			if action == "G" and not($RayCastGauche.is_colliding()):
				deplacement.x = - Global.pixelLargeur 
				$Sprite.global_rotation_degrees = 90 
				$Sprite.flip_v = false 
			if action == "D"  and not($RayCastDroite.is_colliding()):
				deplacement.x =  Global.pixelLargeur 
				$Sprite.global_rotation_degrees = -90 
				$Sprite.flip_v = false 
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
		$Sprite.play("Idle")
