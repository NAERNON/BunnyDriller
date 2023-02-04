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
	var positions_de_la_prochaine_racine = $Serie.get_child(get_child_count() - 2).set_directions_possibles()
	nouvelle_racine.position = $Serie.get_child(get_child_count() - 2).position + set_racine_position(positions_de_la_prochaine_racine)
	if randi_range(1,3) == 1 :
		$Serie2.add_child(nouvelle_racine)
	else:
		$Serie.add_child(nouvelle_racine)
