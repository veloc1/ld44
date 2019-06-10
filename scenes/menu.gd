extends Control

var game_state: GameState
var save_load : SaveLoad

func _ready():
	save_load = SaveLoad.new()
	game_state = save_load.load_game()
	
	if has_saved_game():
		$VBoxContainer/continue.show()
	else:
		$VBoxContainer/continue.hide()

func start_new_game():
	game_state = GameState.new()
	game_state.start_time = OS.get_system_time_secs()
	$creature.create_initial_shape(1)
	game_state.creature = $creature.to_dict()
	save_load.save_game(game_state)
	
	get_tree().change_scene("res://scenes/edit.tscn")

func continue_game():
	get_tree().change_scene("res://scenes/edit.tscn")

func has_saved_game():
	return game_state != null

func _on_exit_pressed():
	$exit_dialog.popup_centered()

func _on_new_game_pressed():
	if has_saved_game():
		$restart_dialog.popup_centered()
	else:
		start_new_game()

func _on_exit_dialog_confirmed():
	get_tree().quit()

func _on_restart_dialog_confirmed():
	start_new_game()

func _on_continue_pressed():
	continue_game()
