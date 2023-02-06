extends Node2D

var character_animation_delay = 1.5
var start_character_delay = false

func _ready():
	$light_back.play()
	$light_front.play()
	$AnimatedSprite2D.play("default")

func _process(_delta):
	if start_character_delay:
		character_animation_delay -= _delta
		if character_animation_delay < 0:
			start_character_delay = false
			$character.play()

func _on_play_button_pressed():
	$AnimationPlayer.play("soundscape_fadeout")
	$light_back.stop()
	$light_front.stop()
	$PlayButton.disabled = true
	$StartSound.play()
	start_character_delay = true



func _on_soundscape_fadeout_finished(anim_name):
	$Soundscape.stop()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

