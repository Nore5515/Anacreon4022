extends Node2D


var allTrades = {
	
}

func addTrade (from, to):
	allTrades[from] = to

func removeTrade (from, to):
	allTrades.keys().erase(from)

func clearAllShips():
	for child in get_children():
		call_deferred("queue_free", child)
		
func addShips():
	for key in allTrades.keys():
		var sprite = Sprite.new()
		sprite.texture = load("res://Imports/ship.png")
		add_child(sprite)
		sprite.scale = Vector2(0.1, 0.1)
		sprite.position = (key + allTrades[key]) * 0.5
		sprite.look_at(allTrades[key])
		sprite.rotate(PI*0.5)
		
