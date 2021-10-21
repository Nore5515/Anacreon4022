extends Node2D


var allTrades = {
	
}

var ships = {}

func addTrade (from, to):
	allTrades[from] = to

func removeTrade (from, to):
	allTrades.keys().erase(from)

func clearAllShips():
	for child in get_children():
		call_deferred("queue_free", child)
	for ship in ships:
		ship.queue_free()
	ships = {}
		
func addShips():
	for key in allTrades.keys():
		var sprite = Sprite.new()
		sprite.texture = load("res://Imports/ship.png")
		add_child(sprite)
		sprite.scale = Vector2(0.1, 0.1)
		sprite.position = (key + allTrades[key]) * 0.5
		sprite.look_at(allTrades[key])
		sprite.rotate(PI*0.5)
		ships[sprite] = [key, allTrades[key]]
		
func _process(delta):
	for ship in ships.keys():
		var direction = Vector2(ships[ship][1].x - ships[ship][0].x, ships[ship][1].y - ships[ship][0].y)
		direction = direction / direction.length()
		ship.position += direction
		if (ship.position-ships[ship][1]).length() < 3:
			ship.position = ships[ship][0]
