extends Object

class_name HexField

const size = Vector2(125.0/2, 125.0/2)

const f1 = sqrt(3)
const f2 = f1 / 2
const f3 = 3.0 / 2.0
const f4 = f1 / 3.0
const f5 = 1.0 / 3.0
const f6 = 2.0 / 3.0

var shape = 1
var hexes = []

func _ready():
	pass # Replace with function body.

func add(q, r, s):
	var hex = Hex.new(q, r, s)
	hexes.append(hex)
	return hex

func get_display_pos(hex: Hex) -> Vector2:
	var x = size.x * (f1 * hex.q + f2 * hex.r)
	var y = size.y * (f3 * hex.r)
	return Vector2(x, y)

func get_hex_pos(pos: Vector2) -> Hex:
	var x = (f4 * pos.x - f5 * pos.y) / size.x 
	var y = (f6 * pos.y) / size.y
	return Hex.new(int(round(x)), int(round(y)), int(round(- x - y)))