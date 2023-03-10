extends Node2D

@onready var racine_instances = preload("res://scenes/racine.tscn")
@onready var sprite_racine = preload("res://scenes/sprite_racine.tscn")
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

var orientation_parent = directions.SUD
var orientation_self = directions.SUD
var orientation_enfant = directions.SUD

var parent = null
var liste_enfants = []
var coordonees_parent = Vector2.ZERO
var coordonees = Vector2.ZERO
var type_racine = type.POUSSE

var directions_possibles = ["bas", "gauche", "droite"]
var is_dup = false

func _ready():
	$Area2D/CollisionShape2D.disabled = true


func joue_anim_pousse() :
	match orientation_self :
		directions.SUD :
			$Sprite.play("vertical_end")
		directions.OUEST :
			$Sprite.play("horizontal_left_end")
		directions.EST :
			$Sprite.play("horizontal_right_end")

func joue_anim_neutre() :
	if orientation_enfant == orientation_self :
		match orientation_enfant :
			directions.SUD :
				$Sprite.play("vertical")
			directions.OUEST :
				$Sprite.play("horizontal_left")
			directions.EST :
				$Sprite.play("horizontal_right")
	else : 
		if orientation_self == directions.SUD and orientation_enfant == directions.OUEST:
			$Sprite.play("corner_down_left")
		elif orientation_self == directions.SUD and orientation_enfant == directions.EST :
			$Sprite.play("corner_down_right")
		elif orientation_self == directions.OUEST and orientation_enfant == directions.SUD:
			$Sprite.play("corner_left_down")
		elif orientation_self == directions.EST and orientation_enfant == directions.SUD :
			$Sprite.play("corner_right_down")

func dupp_sprite() :
	var sprite_instance = sprite_racine.instantiate()
	add_child(sprite_instance)
	orientation_enfant = liste_enfants[0].orientation_self
	if orientation_enfant == orientation_self :
		match orientation_enfant :
			directions.SUD :
				sprite_instance.play("vertical")
			directions.OUEST :
				sprite_instance.play("horizontal_left")
			directions.EST :
				sprite_instance.play("horizontal_right")
	else : 
		if orientation_self == directions.SUD and orientation_enfant == directions.OUEST:
			sprite_instance.play("corner_down_left")
		elif orientation_self == directions.SUD and orientation_enfant == directions.EST :
			sprite_instance.play("corner_down_right")
		elif orientation_self == directions.OUEST and orientation_enfant == directions.SUD:
			sprite_instance.play("corner_left_down")
		elif orientation_self == directions.EST and orientation_enfant == directions.SUD :
			sprite_instance.play("corner_right_down")


func nouvelle_pousse():
	if type_racine == type.POUSSE :
		var nouvelle_racine = racine_instances.instantiate()
		nouvelle_racine.orientation_parent = self.orientation_self
		nouvelle_racine.coordonees_parent = self.coordonees
		nouvelle_racine.parent = self
		liste_enfants.push_back(nouvelle_racine)
		if not(directions_possibles.is_empty()) :
			get_parent().add_child(nouvelle_racine)
			var chance = randi_range(0,get_parent().chance_division)
			if chance == 0 :
				get_parent().chance_division = get_parent().chance_division*4
				var doublon_racine = racine_instances.instantiate()
				doublon_racine.orientation_parent = self.orientation_self
				doublon_racine.coordonees_parent = self.coordonees
				doublon_racine.is_dup = true
				#remove_direction(nouvelle_racine.orientation_self)
				#doublon_racine.orientation_self = get_direction()
				#doublon_racine.coordonees = self.coordonees + get_direction_vecteur(self.orientation_self)
				doublon_racine.parent = self
				liste_enfants.push_back(doublon_racine)
				get_parent().add_child(doublon_racine)
	if Global.dureePousses > 0:
		Global.dureePousses -= 0.01
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
	var return_value = directions.SUD
	if parent != null :
		parent.set_directions_possibles()
		if parent.directions_possibles.size() > 0:
			var direction_choisie = parent.directions_possibles[randi_range(0,parent.directions_possibles.size()-1)]
			match direction_choisie :
				"bas":
					return directions.SUD 
				"gauche":
					return directions.OUEST 
				"droite":
					return directions.EST 
	return directions.SUD


func remove_direction(pDirection):
	match pDirection :
		directions.SUD :
			directions_possibles.erase("bas")
		directions.EST :
			directions_possibles.erase("droite")
		directions.OUEST :
			directions_possibles.erase("gauche")
	
func set_directions_possibles():
	if $RayCastBas.is_colliding():
		if $RayCastBas.get_collider().get_parent().is_in_group("Eau") :
			directions_possibles = ["bas"]
			get_parent().contact_eau()
		elif $RayCastBas.get_collider().get_parent().is_in_group("Toxic") :
			directions_possibles = ["bas"]
			get_parent().contact_toxic()
		else :
			directions_possibles.erase("bas")
	if $RayCastGauche.is_colliding():
		if $RayCastGauche.get_collider().get_parent().is_in_group("Eau") :
			directions_possibles = ["gauche"]
			get_parent().contact_eau()
		elif $RayCastGauche.get_collider().get_parent().is_in_group("Toxic") :
			directions_possibles = ["gauche"]
			get_parent().contact_toxic()
		else :
			directions_possibles.erase("gauche")
	if $RayCastDroite.is_colliding():
		if $RayCastDroite.get_collider().get_parent().is_in_group("Eau") :
			directions_possibles = ["droite"]
			get_parent().contact_eau()
		elif $RayCastDroite.get_collider().get_parent().is_in_group("Toxic") :
			directions_possibles = ["droite"]
			get_parent().contact_toxic()
		else :
			directions_possibles.erase("droite")
	if orientation_self == directions.EST:
		directions_possibles.erase("gauche")
	if orientation_self == directions.OUEST:
		directions_possibles.erase("droite")
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

func child_died():
	joue_died()

func joue_died() :
	match orientation_self :
		directions.SUD :
			$Sprite.play("scar_vertical")
		directions.OUEST :
			$Sprite.play("scar_horizontal_left")
		directions.EST :
			$Sprite.play("scar_horizontal_right")


func _on_delay_raycast_timeout():
	orientation_self = get_direction()
	if( parent != null):
		parent.orientation_enfant = orientation_self
		parent.joue_anim_neutre()
		if is_dup :
			parent.dupp_sprite()
	coordonees = coordonees_parent + get_direction_vecteur(orientation_self)
	self.global_position = Vector2(coordonees.x * Global.pixelHauteur + get_parent().global_position.x,coordonees.y * Global.pixelLargeur + get_parent().global_position.y)
	joue_anim_pousse()




func _on_sprite_animation_finished():
	if type_racine == type.POUSSE :
		$Area2D/CollisionShape2D.disabled = false
		$DureeVie.start(Global.dureePousses)
	else : 
		$RayCastBas.queue_free()
		$RayCastDroite.queue_free()
		$RayCastGauche.queue_free()
		$RayCastHaut.queue_free()
