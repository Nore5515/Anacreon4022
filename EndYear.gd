extends Button


var year = 4021

func _on_EndYear_pressed():
	for planet in get_tree().get_nodes_in_group("planet"):
		planet.endYear()
	year += 1
	get_parent().get_node("Label").text = "Year: " + String(year)
	get_parent().get_parent().get_node("TradeArtManager").clearAllShips()
	get_parent().get_parent().get_node("TradeArtManager").addShips()


func adjustPlanetGrowth(planet):
	pass
