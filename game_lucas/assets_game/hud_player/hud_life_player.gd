extends Control

func _process(delta):
	update_value_bar_life()

func update_value_bar_life():
	$bar_life_progress.value = atributos_player_singleton.life_player
 
