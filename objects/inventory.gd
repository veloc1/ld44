tool
extends Node2D

signal on_item_hovered(item)
signal on_item_start_dragged(item)

const InventoryItem = preload("res://objects/inventory_item.tscn")

const Columns = 3

var items = []
var hovered_item
var dragged_item
var is_dropped_on_creature = false

onready var tween = $Tween
onready var drop_tween = $drop_tween

func _ready():
	items.append(InventoryItem.instance())
	items.append(InventoryItem.instance())
	items.append(InventoryItem.instance())
	items.append(InventoryItem.instance())
	place_items()

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if dragged_item and not drop_tween.is_active():
		tween.interpolate_property(dragged_item, "global_position", dragged_item.global_position, mouse_pos, 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()

func place_items():
	for i in range(len(items)):
		var item = items[i]
		item.position = get_item_pos(i)
		add_child(item)

func get_item_pos(index) -> Vector2:
	return Vector2(index % Columns * 132, index / Columns * 132)

func _input(event):
	if drop_tween.is_active():
		return
	if event is InputEventMouseButton:
		if dragged_item and $mouse_timer.time_left == 0:
			if event.button_index == BUTTON_RIGHT:
				drop_back()
			else:
				drop()
		if hovered_item and not dragged_item and event.button_index == BUTTON_LEFT:
			drag()
			$mouse_timer.start()
	elif event is InputEventMouseMotion:
		if not dragged_item:
			if hovered_item:
				hovered_item = null
			for i in items:
				i.unhover()
				if i.intersects(event.position):
					i.hover()
					hovered_item = i
					emit_signal("on_item_hovered", i)
		else:
			get_parent().process_inventory_item(dragged_item)

func drag():
	dragged_item = hovered_item
	dragged_item.z_index = 100
	if hovered_item:
		hovered_item.unhover()
		hovered_item = null
	
	emit_signal("on_item_start_dragged", dragged_item)
	
func drop():
	var drop_pos = dragged_item.original_pos
	if get_parent().can_drop(dragged_item):
		is_dropped_on_creature = true
		drop_pos = get_parent().drop_item(dragged_item)
	_drop(drop_pos)

func drop_back():
	_drop(dragged_item.original_pos)
	
func _drop(pos):
	drop_tween.connect("tween_completed", self, "drop_ended")
	drop_tween.interpolate_property(dragged_item, "global_position", dragged_item.global_position, pos, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	drop_tween.start()

func drop_ended(_object, _node_path):
	get_parent().drop_ended()
	var d = dragged_item
	drop_tween.disconnect("tween_completed", self, "drop_ended")
	dragged_item.z_index = 0
	dragged_item = null
	if hovered_item:
		hovered_item.unhover()
		hovered_item = null
	if is_dropped_on_creature:
		items.remove(items.find(d))
		d.queue_free()
		is_dropped_on_creature = false
