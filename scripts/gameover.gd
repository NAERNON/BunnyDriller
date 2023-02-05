extends Node2D

func _ready():
	$AnimatedPoison.play()
	$AnimatedText.play()


func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
