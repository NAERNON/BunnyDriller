extends Node2D

@onready var racine = preload("res://scenes/racine.tscn")


func _ready():
	pass


func _process(delta):
	pass

func set_racine_position(directions_possible):
	var prochaine_direction = randi_range(0, directions_possible.size() - 1)
	if directions_possible[prochaine_direction] == "gauche":
		return Vector2(-24,0)
	if directions_possible[prochaine_direction] == "droite":
		return Vector2(24,0)
	if directions_possible[prochaine_direction] == "bas":
		return Vector2(0, 24)


func spawn_racine():
	var nouvelle_racine = racine.instantiate()


#	print(get_child(get_child_count() - 1).est_pousse)
#	print(nouvelle_racine.est_pousse)
	
	var positions_de_la_prochaine_racine = get_child(get_child_count() - 1).set_directions_possibles()
	
#	nouvelle_racine.position = get_child(get_child_count() - 1).position + set_racine_position(get_child(get_child_count() - 2).set_directions_possibles())
	nouvelle_racine.position = get_child(get_child_count() - 1).position + set_racine_position(positions_de_la_prochaine_racine)
	add_child(nouvelle_racine)
#
#	for r in get_child_count() - 2:
#		get_child(r).est_pousse = false

	

#		r.est_pousse = false
	

	
	
#	print(get_child(get_child_count() - 1))
