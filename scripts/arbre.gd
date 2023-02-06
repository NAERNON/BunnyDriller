extends Node2D

@onready var racine = preload("res://scenes/racine.tscn")


var chance_division = 10
var spawn_speed = 2

func _ready():
	get_parent().get_node("CameraPrincipale").enabled = true
	init_tree()


enum type {
	POUSSE, 
	NEUTRE
}

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

func init_tree():
	var nouvelle_pousse = racine.instantiate()
	add_child(nouvelle_pousse)
	
	

func get_count_pousses():
	var count = 0
	for _i in self.get_children ():
		if _i.is_in_group("Racine") and _i.type_racine == type.POUSSE :
			count += 1
	return count

func _on_joueur_racine_coupee(pRacine):
	if pRacine.parent != null :
		pRacine.parent.child_died()
	pRacine.mort_recursive()
	$Delay.start(2)

func contact_eau(): 
	self.chance_division = 10
	Global.dureePousses += 0.1

func contact_toxic(): 
	game_over()

func game_over() : 
	get_parent().get_node("CameraPrincipale").enabled = false
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")

func _on_delay_timeout():
	if get_count_pousses() < 1: 
		game_over()


func _on_joueur_first_move_player():
	$RootsEffect.play();
