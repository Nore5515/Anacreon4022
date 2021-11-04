extends Button


var year = 4021
var won = false

func _on_EndYear_pressed():
	won = true
	for planet in get_tree().get_nodes_in_group("planet"):
		planet.endYear()
		if planet.team != get_node("/root/Global").playerTeam:
			won = false
	year += 1
	get_parent().get_node("Label").text = "Year: " + String(year)
	get_parent().get_parent().get_node("TradeArtManager").clearAllShips()
	get_parent().get_parent().get_node("TradeArtManager").addShips()
	
	if won:
		get_parent().get_node("YouWon").visible = true
	else:
		get_parent().get_node("Adjustments").updateDetails()

func adjustPlanetGrowth(planet):
	pass
