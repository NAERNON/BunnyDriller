extends Node2D
# sn = sous_niveau
@export var hauteur_sn = 270
@export var largeur_sn = 480

@onready var intro = preload("res://scenes/intro.tscn")

var liste_sn = []
var dernier_sn = 0 
var nb_sn = 4
var compteur_sn=0


# Called when the node enters the scene tree for the first time.
func _ready():
	ajouter_intro()
	load_sn() 
	for i in 10 : 
		var aleatoire = randi_range(1,4)
		while aleatoire == dernier_sn :
			aleatoire = randi_range(1,4)
		ajouter_sn(aleatoire)
		

func load_sn():
	for i in nb_sn :
		i+=1 
		var tmp_scene = load("res://niveaux/sn_"+str(i)+".tscn")
		liste_sn.push_back(tmp_scene)

func ajouter_sn(pIdentifiant):
	var new_sn = liste_sn[pIdentifiant-1].instantiate()
	new_sn.global_position = Vector2(0,compteur_sn * hauteur_sn)
	add_child(new_sn)
	compteur_sn += 1 
	dernier_sn = pIdentifiant
	

func ajouter_intro():
	var instance_sn = intro.instantiate()
	instance_sn.global_position = Vector2(0,compteur_sn * hauteur_sn)
	add_child(instance_sn)
	compteur_sn += 1 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

