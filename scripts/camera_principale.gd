extends Camera2D

#variable à changer avec un signal du joueur et sa position
@export var hauteur_joueur = 0
@export var duree_transision = 0.33

func _ready():
	suivre_joueur(get_parent().get_node("Joueur").position.y)

func _process(delta):
	pass

func suivre_joueur(p_hauteur_joueur):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.global_position.x,p_hauteur_joueur),duree_transision)
	

func _on_joueur_player_moved(position_y):
	suivre_joueur(position_y)
