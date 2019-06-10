extends Object

class_name GameState

var start_time : int
var creature : Dictionary

func to_dict():
	return {
		"start_time": start_time,
		"creature": creature
	}

func from_dict(data):
	start_time = data["start_time"]
	creature = {
		"shape": data["creature"]["shape"],
		"cells": data["creature"]["cells"]
	}