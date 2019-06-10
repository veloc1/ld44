extends Node2D

func set_stat(original, diff):
	$armor.text = str(original.armor)
	$attack.text = str(original.attack)
	$health.text = str(original.health)
	
	if diff:
		$armor_diff.show()
		$attack_diff.show()
		$health_diff.show()
		
		set_diff_text($armor_diff, diff.armor)
		set_diff_text($attack_diff, diff.attack)
		set_diff_text($health_diff, diff.health)
	else:
		$armor_diff.hide()
		$attack_diff.hide()
		$health_diff.hide()

func set_diff_text(label: Label, val):
	var c
	var t
	if val > 0:
		c = Color.green
		t = "+" + str(val)
	elif val == 0:
		c = Color.darkgray
		t = str(val)
	else:
		c = Color.red
		t = str(val)
	label.add_color_override("font_color", c)
	label.text = t