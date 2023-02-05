extends Node2D

@onready var racine_instances = preload("res://scenes/racine.tscn")


enum directions {
	NORD,
	EST,
	SUD,
	OUEST
}

enum type {
	POUSSE, 
	NEUTRE
}

# Plus chance division est haute moins il y a de chance d'un nouveau croisement
var chance_division = 50

var orientation_parent = directions.SUD
var orientation_self = directions.OUEST

var liste_enfants = []
var coordonees_parent = Vector2.ZERO
var coordonees = Vector2.ZERO
var type_racine = type.POUSSE

var directions_possibles = ["bas", "gauche", "droite"]

var est_pousse = true

func _ready():
	self.global_position = Vector2(coordonees.x * Global.pixelHauteur ,coordonees.y * Global.pixelLargeur)
	$DureeVie.start(Global.dureePousses)
	joue_anim_pousse()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func joue_anim_pousse() :
	match orientation_self :
		directions.SUD :
			$Sprite.play("vertical_end")
		directions.OUEST :
			$Sprite.play("horizontal_left_end")
		directions.EST :
			$Sprite.play("horizontal_right_end")

func joue_anim_neutre() :
	if orientation_self == orientation_parent :
		match orientation_self :
			directions.SUD :
				$Sprite.play("vertical")
			directions.OUEST :
				$Sprite.play("horizontal_left")
			directions.EST :
				$Sprite.play("horizontal_right")
	else : 
		if orientation_parent == directions.SUD and orientation_self == directions.OUEST:
			$Sprite.play("corner_down_left")
		elif orientation_parent == directions.SUD and orientation_self == directions.EST :
			$Sprite.play("corner_down_right")
		elif orientation_parent == directions.OUEST and orientation_self == directions.SUD:
			$Sprite.play("corner_left_down")
		elif orientation_parent == directions.EST and orientation_self == directions.SUD :
			$Sprite.play("corner_right_down")

func nouvelle_pousse():
	if type_racine == type.POUSSE :
		var nouvelle_racine = racine_instances.instantiate()
		nouvelle_racine.coordonees = self.coordonees + get_direction_vecteur(self.orientation_self)
		nouvelle_racine.orientation_parent = self.orientation_self
		nouvelle_racine.coordonees_parent = self.coordonees
		nouvelle_racine.orientation_self = get_direction()
		liste_enfants.push_back(nouvelle_racine)
		get_parent().add_child(nouvelle_racine)
		var chance = randi_range(0,chance_division)
		if chance == 0 :
			
			var doublon_racine = racine_instances.instantiate()
			doublon_racine.coordonees = self.coordonees + get_direction_vecteur(self.orientation_self)
			doublon_racine.orientation_parent = self.orientation_self
			doublon_racine.coordonees_parent = self.coordonees
			remove_direction(nouvelle_racine.orientation_self)
			doublon_racine.orientation_self = get_direction()
			liste_enfants.push_back(doublon_racine)
			get_parent().add_child(doublon_racine)
		joue_anim_neutre()
	type_racine = type.NEUTRE

func get_direction_vecteur(pOrientation): 
	match pOrientation :
		directions.SUD :
			return Vector2.DOWN
		directions.NORD :
			return Vector2.DOWN
		directions.OUEST :
			return Vector2.LEFT
		directions.EST :
			return Vector2.RIGHT
	return Vector2.ZERO
	

func get_direction() : 
	var ray_gauche = $RayCastGauche.is_colliding()
	var ray_droite = $RayCastDroite.is_colliding()
	var ray_down = $RayCastBas.is_colliding()
	var return_value = directions.SUD
	set_directions_possibles()
	

	if directions_possibles.size() > 0:
		var direction_choisie = directions_possibles[randi_range(0,directions_possibles.size()-1)]
		match direction_choisie :
			"bas":
				return directions.SUD 
			"gauche":
				return directions.OUEST 
			"droite":
				return directions.EST 


func remove_direction(pDirection):
	match pDirection :
		directions.SUD :
			directions_possibles.erase("bas")
		directions.EST :
			directions_possibles.erase("droite")
		directions.OUEST :
			directions_possibles.erase("gauche")
	
func set_directions_possibles():
#	if est_pousse:s
	if $RayCastBas.is_colliding():
		directions_possibles.erase("bas")
	if $RayCastGauche.is_colliding():
		directions_possibles.erase("gauche")
	if $RayCastDroite.is_colliding():
		directions_possibles.erase("droite")
	if orientation_self == directions.EST:
		directions_possibles.erase("gauche")
	if orientation_self == directions.OUEST:
		directions_possibles.erase("droite")
	#		print(str(self), directions_possibles)
	return directions_possibles

func mort_recursive():
	if not(liste_enfants.is_empty()) :
		for i in liste_enfants :
			if i != null :
				i.mort_recursive()
	queue_free()


func _on_timer_for_raycasts_timeout():
	set_directions_possibles()
	$TimerForRaycasts.queue_free()


func _on_duree_vie_timeout():
	nouvelle_pousse()

