tool
extends Node2D

const Empty = preload("res://assets/sprites/empty.png")
const Basic = preload("res://assets/sprites/basic.png")
const Eye = preload("res://assets/sprites/eye.png")

var hex
var type

var armor
var attack
var health

func _ready():
	switch_type(type)

func _process(_delta):
	pass

func switch_type(type):
	$eye.hide()
	$basic.hide()
	$Sprite.show()
	
	armor = 0
	attack = 0
	health = 0
	
	var t = Empty
	if type == CellType.TYPE_EMPTY:
		t = Empty
		$eye.hide()
		$basic.hide()
		$Sprite.show()
	elif type == CellType.TYPE_BASIC:
		t = Basic
		$eye.hide()
		$basic.show()
		$Sprite.hide()
		
		armor = 1
		attack = 0
		health = 10
		
	elif type == CellType.TYPE_EYE:
		t = Eye
		$eye.show()
		$basic.hide()
		$Sprite.hide()
		
		armor = 2
		attack = 3
		health = 5

	$Sprite.texture = t
	self.type = type

func hover():
	$Sprite.modulate.a = 0.5

func unhover():
	$Sprite.modulate.a = 1

func on_eye_animation_finished():
	if $eye.animation == "eye":
		$eye.play("idle")

func on_eye_anim_timer_timeout():
	$eye.play("eye")
	$eye_anim_timer.wait_time = rand_range(2.5, 5)

func on_basic_animation_finished():
	if $basic.animation == "move":
		$basic.play("idle")

func on_basic_anim_timer_timeout():
	$basic.play("move")
	$basic_anim_timer.wait_time = rand_range(2.5, 5)

