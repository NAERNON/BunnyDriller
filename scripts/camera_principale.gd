extends Camera2D

#variable à changer avec un signal du joueur et sa position
@export var hauteur_joueur = 0
@export var duree_transision = 1

func _ready():
	suivre_joueur(get_parent().get_node("Joueur").position.x)

func _process(delta):
	pass

func suivre_joueur(p_hauteur_joueur):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.global_position.x,p_hauteur_joueur),duree_transision)
	
