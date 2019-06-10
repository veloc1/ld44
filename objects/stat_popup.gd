extends Node2D

func set_stat(arm, att, health):
	$armor_l.text = String(arm)
	$att_l.text = String(att)
	$health_l.text = String(health)