extends Node2D

func _ready():
	$AnimatedPoison.play()
	$AnimatedText.play()
	$Camera2D.enabled = true 


func _on_play_button_button_up():
	$Camera2D.enabled = false 
	get_tree().change_scene_to_file("res://scenes/game.tscn")
