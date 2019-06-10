tool
extends Node2D

const Size = 125 / 2

var is_hovered = false

var original_pos : Vector2

var type
var armor
var attack
var health

func _ready():
	$cells.switch_type(int(rand_range(1, 3)))
	type = $cells.type
	armor = $cells.armor
	attack = $cells.attack
	health = $cells.health

func _enter_tree():
	original_pos = global_position

func hover():
	is_hovered = true
	$hover.show()

func unhover():
	is_hovered = false
	$hover.hide()
	
func intersects(mouse_pos):
	if not is_inside_tree():
		return false

	var p = global_position
	
	return !(mouse_pos.x < p.x - Size \
		or mouse_pos.x > p.x + Size \
		or mouse_pos.y < p.y - Size \
		or mouse_pos.y > p.y + Size)
