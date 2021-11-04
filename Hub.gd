extends Node2D



var selectedWorld
var world1
var world1Selecting = false
var world2
var world2Selecting = false

var trading = false
var attacking = false

func setPlanet(Button):
	
	selectedWorld = Button
	get_parent().get_node("Adjustments").setPlanet(selectedWorld)
	
	get_parent().get_node("CreateFleet").disabled = false
	if world1Selecting:
		world1 = selectedWorld
		world1Selecting = false
		get_parent().get_node("TradeNotes").text = "Okay, now please select World 2!"
		world2Selecting = true
	elif world2Selecting:
		world2 = selectedWorld
		world2Selecting = false
		if trading:
			get_parent().get_node("TradePanel").setWorlds(world1, world2)
		if attacking:
			world2.team = world1.team
			world2.modulate = world1.modulate
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
		get_parent().get_node("CreateFleet").disabled = true
		if selectedWorld != null:
			selectedWorld.get_node("Details").visible = false
			selectedWorld = null
		for planet in get_tree().get_nodes_in_group("planet"):
			planet.get_node("Details").visible = false
	
	if Input.is_action_pressed("r"):
		if get_parent().get_node("EndYear").won:
			get_tree().change_scene("res://MainMenu.tscn")


func _on_SetInd_pressed():
	if selectedWorld != null:
		selectedWorld.desgPlanet("Independent World")



func _on_TradeRoute_pressed():
	var tradeNotes = get_parent().get_node("TradeNotes")
	trading = true
	attacking = false
	if selectedWorld == null:
		tradeNotes.text = "Please select world 1!"
		world1Selecting = true
	if selectedWorld != null:
		tradeNotes.text = "Please hit 'esc' to deselect your current world."


func assignTeam(teamName, teamColor):
	if selectedWorld != null:
		selectedWorld.setTeam(teamName, teamColor)


func _on_RefuelFleet_pressed():
	for child in get_tree().get_nodes_in_group("fleet"):
		if child.selected:
			child.fuel = 100


func _on_LaunchAttack_pressed():
	trading = false
	attacking = true
	var tradeNotes = get_parent().get_node("TradeNotes")
	if selectedWorld == null:
		tradeNotes.text = "Please select world 1!"
		world1Selecting = true
	if selectedWorld != null:
		tradeNotes.text = "Please hit 'esc' to deselect your current world."


func _on_CreateFleet_pressed():
	if selectedWorld != null && selectedWorld.fighters > 0:
		var fleetType = load("res://Fleet.tscn")
		var instance = fleetType.instance()
		get_parent().get_parent().call_deferred("add_child", instance)
		instance.position.x = selectedWorld.rect_position.x
		instance.position.y = selectedWorld.rect_position.y
		instance.fighters += selectedWorld.fighters
		selectedWorld.fighters = 0
		selectedWorld.updateDetails()
		#instance.updateStatus()


func _on_StockFleet_pressed():
	for child in get_tree().get_nodes_in_group("fleet"):
		if child.selected:
			if selectedWorld != null:
				child.fighters += selectedWorld.fighters
				selectedWorld.fighters = 0
				selectedWorld.updateDetails()
