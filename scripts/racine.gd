extends Node2D

var directions_possibles = ["bas", "gauche", "droite"]

var est_pousse = true

func _ready():
	$TimerForRaycasts.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func set_directions_possibles():
	if est_pousse:
		if $RayCastBas.is_colliding():
			directions_possibles.erase("bas")
		if $RayCastGauche.is_colliding():
			directions_possibles.erase("gauche")
		if $RayCastDroite.is_colliding():
			directions_possibles.erase("droite")
		#		print(str(self), directions_possibles)
		return directions_possibles



func _on_timer_for_raycasts_timeout():
	set_directions_possibles()
	$TimerForRaycasts.queue_free()
