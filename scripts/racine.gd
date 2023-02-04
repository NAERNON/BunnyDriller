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

var orientation_parent = directions.SUD
var orientation_enfant = directions.OUEST

var liste_enfants = []
var coordonees_parent = Vector2.ZERO
var coordonees = Vector2.ZERO
var type_racine = type.POUSSE

var directions_possibles = ["bas", "gauche", "droite"]

var est_pousse = true

func _ready():
	self.global_position = Vector2(coordonees.x * Global.pixelHauteur ,coordonees.y * Global.pixelLargeur)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func nouvelle_pousse():
	if type_racine == type.POUSSE :
		var nouvelle_racine = racine_instances.instantiate()
		nouvelle_racine.coordonees = Vector2(self.coordonees.x + 1 , self.coordonees.y + 1) 
		get_parent().add_child(nouvelle_racine)
	type_racine = type.NEUTRE


func set_directions_possibles():
#	if est_pousse:s
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


func _on_duree_vie_timeout():
	nouvelle_pousse()
