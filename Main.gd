extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$Planet.desgPlanet("Independent World")



func _on_Timer_timeout():
	$CanvasLayer/EndYear._on_EndYear_pressed()
