tool
extends Node2D

class_name Creature 

const Cell = preload("res://objects/cells.tscn")

var hex_field : HexField
var shape = 1

func _ready():
	hex_field = HexField.new()

func add_cell(q, r, s, type):
	var cell = Cell.instance()
	var hex = hex_field.add(q, r, s)
	cell.hex = hex
	
	var pos = hex_field.get_display_pos(hex)
	cell.position.x = pos.x
	cell.position.y = pos.y
	
	cell.type = type
	
	add_child(cell)

func _process(delta):
	pass

func stat():
	var armor = collect_attribute("armor")
	var attack = collect_attribute("attack")
	var health = collect_attribute("health")
	return {
		"armor": armor,
		"attack": attack,
		"health": health,
	}

func stat_diff(item):
	var cell = get_overlapped_cell(item)
	if not cell:
		return null
	
	return {
		"armor": item.armor - cell.armor,
		"attack": item.attack - cell.attack,
		"health": item.health - cell.health,
	}

func collect_attribute(name):
	var a = 0
	for c in get_children():
		a = a + c.get(name)
	return a
	
func hover_overlapped_cell(item):
	for i in get_children():
		i.unhover()
	var cell = get_overlapped_cell(item)
	if cell:
		return cell.hover()

func can_drop(item):
	if get_overlapped_cell(item):
		return true
	return false

func drop_item(item):
	var cell = get_overlapped_cell(item)
	add_cell(cell.hex.q, cell.hex.r, cell.hex.s, item.type)
	cell.queue_free()
	if cell:
		return cell.global_position
	return null

func get_overlapped_cell(item):
	var pos = hex_field.get_hex_pos(item.global_position - position)
	for i in get_children():
		if i.hex.q == pos.q and i.hex.r == pos.r:
			return i
	return null

func unhover_all():
	for i in get_children():
		i.unhover()

func to_dict():
	var cells = []
	for c in get_children():
		cells.append({
			"q": c.hex.q,
			"r": c.hex.r,
			"s": c.hex.s,
			"type": c.type
		})
	return {
		"shape": shape,
		"cells": cells
	}

func create_initial_shape(shape):
	if shape == 1:
		add_cell(0, 0, 0, CellType.TYPE_BASIC)
		add_cell(1, 0, 0, CellType.TYPE_EMPTY)
		add_cell(-1, 0, 0, CellType.TYPE_EMPTY)
		add_cell(0, 1, 0, CellType.TYPE_EMPTY)
		add_cell(-1, 1, 0, CellType.TYPE_EMPTY)

func load_field(state: GameState):
	shape = state.creature["shape"]
	var cells = state.creature["cells"]
	
	if shape == 1:
		load_cell(0, 0, 0, cells)
		load_cell(1, 0, 0, cells)
		load_cell(-1, 0, 0, cells)
		load_cell(0, 1, 0, cells)
		load_cell(-1, 1, 0, cells)
		

func load_cell(q, r, s, cells):
	var cell_type = CellType.TYPE_EMPTY
	for c in cells:
		if c["q"] == q and c["r"] == r:
			cell_type = c["type"]
	add_cell(q, r, s, cell_type)