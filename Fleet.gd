extends Node2D


var mouseOver = false
var selected = false

var destination = Vector2()
var destIcon

var fuel = 100.0
var fighters = 0

var team = ""
var teamColor 

func assignTeam(teamName, color):
	team = teamName
	teamColor = color
	modulate = teamColor

func select():
	selected = true
	$icon.visible = true
	updateStatus()
	get_parent().get_node("CanvasLayer/RefuelFleet").visible = true
	get_parent().get_node("CanvasLayer/StockFleet").visible = true
	get_parent().get_node("CanvasLayer/InvadeFleet").visible = true

func deselect():
	selected = false
	$icon.visible = false
	get_parent().get_node("CanvasLayer/FleetStatus").text = ""
	get_parent().get_node("CanvasLayer/RefuelFleet").visible = false
	get_parent().get_node("CanvasLayer/StockFleet").visible = false
	get_parent().get_node("CanvasLayer/InvadeFleet").visible = false

func updateStatus():
	#print (fighters)
	var thing = "FLEET STATUS\n" \
		+ "Fighters - " + String(fighters) + "\n"\
		+ "Transports - 0\n"\
		+ "Jumpships - 0\n"\
		+ "Jumptransports - 0\n"\
		+ "Fuel: " + String(stepify(fuel, 0.01))
	get_parent().get_node("CanvasLayer/FleetStatus").text = thing

func _process(delta):
	var movement = destination - position
	movement = movement / movement.length()
	position += movement
	look_at(destination)
	rotate(PI*0.5)
	fuel -= 0.5 * delta
	
	if team != get_node("/root/Global").playerTeam:
		print ("AI ACTION!", position)
		aiAct()
	
	if selected:
		updateStatus()
	
		if (getNearestPlanet().get_global_rect().position - (self.position + Vector2(50, 25))).length() <= 80:
			if ($inRange.visible == false):
				get_parent().get_node("CanvasLayer/Hub").fleetPlanet = getNearestPlanet()
			$inRange.visible = true
			get_parent().get_node("CanvasLayer/RefuelFleet").disabled = false
			get_parent().get_node("CanvasLayer/StockFleet").disabled = false
			get_parent().get_node("CanvasLayer/InvadeFleet").disabled = false
		else:
			$inRange.visible = false
			get_parent().get_node("CanvasLayer/RefuelFleet").disabled = true
			get_parent().get_node("CanvasLayer/StockFleet").disabled = true
			get_parent().get_node("CanvasLayer/InvadeFleet").disabled = true


func aiAct():
	if destIcon == null:
		print ("Creating new dest!")
		if getNearestUnalignedPlanet() == null:
			pass
		else:
			var instance = Sprite.new()
			instance.modulate = modulate
			instance.texture = load("res://Imports/icon.png")
			instance.scale = Vector2(0.023, 0.023)
			get_parent().call_deferred("add_child", instance)
			instance.position = getNearestUnalignedPlanet().rect_position
			destIcon = instance
			destination = instance.position

func getNearestPlanet():
	var nearest 
	for planet in get_tree().get_nodes_in_group("planet"):
		if nearest == null:
			nearest = planet
		else:
			if (self.position-planet.get_global_rect().position).length() < (self.position - nearest.get_global_rect().position).length():
				nearest = planet
	
	return nearest


func getNearestUnalignedPlanet():
	var nearest 
	for planet in get_tree().get_nodes_in_group("planet"):
		if planet.team == get_node("/root/Global").playerTeam || planet.team == get_node("/root/Global").aiTeam:
			pass
		else:
			if nearest == null:
				nearest = planet
			else:
				if (self.position-planet.get_global_rect().position).length() < (self.position - nearest.get_global_rect().position).length():
					nearest = planet
	
	return nearest
	

func _input(event):
	if event.is_action_pressed("mouseClick"):
		if mouseOver:
			if team == get_node("/root/Global").playerTeam:
				select()
		else:
			if selected:
				if destIcon == null:
					var instance = Sprite.new()
					instance.texture = load("res://Imports/icon.png")
					instance.scale = Vector2(0.023, 0.023)
					get_parent().call_deferred("add_child", instance)
					instance.position = get_global_mouse_position()
					destIcon = instance
					destination = get_global_mouse_position()
				else:
					destIcon.queue_free()
					var instance = Sprite.new()
					instance.texture = load("res://Imports/icon.png")
					instance.scale = Vector2(0.023, 0.023)
					get_parent().call_deferred("add_child", instance)
					instance.position = get_global_mouse_position()
					destIcon = instance
					destination = get_global_mouse_position()
	if event.is_action_pressed("esc") || event.is_action_pressed("rightClick"):
		if selected:
			deselect()

func _on_Area2D_mouse_entered():
	mouseOver = true


func _on_Area2D_mouse_exited():
	mouseOver = false
