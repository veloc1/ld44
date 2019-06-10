extends Node2D

var game_state: GameState
var save_load : SaveLoad

func _ready():
	save_load = SaveLoad.new()
	game_state = save_load.load_game()
	$creature.load_field(game_state)
	$creature_stat.set_stat($creature.stat(), null)
	
	$inventory.connect("on_item_hovered", self, "on_item_hovered")
	$inventory.connect("on_item_start_dragged", self, "on_item_start_dragged")

func process_inventory_item(item):
	$creature.hover_overlapped_cell(item)
	$creature_stat.set_stat($creature.stat(), $creature.stat_diff(item))

func on_item_hovered(item):
	$stat_popup.global_position.x = item.global_position.x
	$stat_popup.global_position.y = item.global_position.y
	$stat_popup.set_stat(item.armor, item.attack, item.health)
	$stat_popup.show()

func drop_ended():
	$creature.unhover_all()

func on_item_start_dragged(item):
	$stat_popup.hide()

func get_state():
	return game_state

func can_drop(item):
	return $creature.can_drop(item)

func drop_item(item):
	var drop_pos = $creature.drop_item(item)
	$creature_stat.set_stat($creature.stat(), null)
	game_state.creature = $creature.to_dict()
	save_load.save_game(game_state)
	return drop_pos
