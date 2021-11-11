extends Node2D

#world1.addTrades(world2.worldName, "chem", -chemTrade)
#		world2.addTrades(world1.worldName, "chem", chemTrade)

# Array of TradeRoutes
var tradeLines = []

class TradeRoute:
	var pos1: Vector2
	var pos2: Vector2
	var team: String

func getAllTrades():
	var trades = []
	var routes = []
	
	var route
	
	for x in get_tree().get_nodes_in_group("planet"):
		if x.chemTrades.keys().size() > 0:
			trades.append(x.chemTrades)
			#route = TradeRoute.new()
			#route.pos1 = 
		if x.metTrades.keys().size() > 0:
			trades.append(x.metTrades)
		if x.supTrades.keys().size() > 0:
			trades.append(x.supTrades)

	return trades

	

func _on_Timer_timeout():
	print(getAllTrades())
