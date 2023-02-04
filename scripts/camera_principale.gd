extends Camera2D

@export var hauteur_joueur = -5000
@export var duree_transision = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	suivre_joueur(hauteur_joueur)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func suivre_joueur(p_hauteur_joueur):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.global_position.x,p_hauteur_joueur),duree_transision)
	
