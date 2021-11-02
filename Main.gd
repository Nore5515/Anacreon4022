extends Node2D


var global

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	$Planet.desgPlanet("Independent World")
	get_node("CanvasLayer/Team1").text = global.playerTeam



func _on_Timer_timeout():
	$CanvasLayer/EndYear._on_EndYear_pressed()
