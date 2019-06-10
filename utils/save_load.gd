extends Object

class_name SaveLoad

const save_path = "user://savegame.save"

func save_game(state: GameState):
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	save_game.store_line(to_json(state.to_dict()))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		return # Error! We don't have a save to load.
	
	var state = null
	save_game.open(save_path, File.READ)
	while not save_game.eof_reached():
		var line = save_game.get_line()
		if (len(line) > 0):
			var state_serialized = parse_json(line)
			state = GameState.new()
			state.from_dict(state_serialized)
		
	save_game.close()
	return state

func has_save():
	return load_game() != null