extends Node2D



var selectedWorld
var world1
var world1Selecting = false
var world2
var world2Selecting = false


func setPlanet(Button):
	
	selectedWorld = Button
	if world1Selecting:
		world1 = selectedWorld
		world1Selecting = false
		get_parent().get_node("TradeNotes").text = "Okay, now please select World 2!"
		world2Selecting = true
	elif world2Selecting:
		world2 = selectedWorld
		world2Selecting = false
		get_parent().get_node("TradePanel").setWorlds(world1, world2)
		get_parent().get_node("TradeNotes").text = ""
	
func _on_SetMet_pressed():
	if selectedWorld != null:
		selectedWorld.desgPlanet("Mining World")

func _on_SetSup_pressed():
	if selectedWorld != null:
		selectedWorld.desgPlanet("Agri World")

func _on_SetChem_pressed():
	if selectedWorld != null:
		selectedWorld.desgPlanet("Chemical World")

func _input(event):
	if Input.is_action_pressed("esc"):
		if selectedWorld != null:
			selectedWorld.get_node("Details").visible = false
			selectedWorld = null
		for planet in get_tree().get_nodes_in_group("planet"):
			planet.get_node("Details").visible = false


func _on_SetInd_pressed():
	if selectedWorld != null:
		selectedWorld.desgPlanet("Independent World")



func _on_TradeRoute_pressed():
	var tradeNotes = get_parent().get_node("TradeNotes")
	if selectedWorld == null:
		tradeNotes.text = "Please select world 1!"
		world1Selecting = true
	if selectedWorld != null:
		tradeNotes.text = "Please hit 'esc' to deselect your current world."
