extends Panel

var world1
var world2

func setWorlds(_world1, _world2):
	rect_position = Vector2(0, 125)
	world1 = _world1
	world2 = _world2
	var world1details = ""
	var world2details = ""
	world1details += world1.worldName
	world2details += world2.worldName
	
	world1details += "\nChemicals: " + String(world1.chemicals) + "(+" + String(world1.chemicalGrowth) + "/-" + String(world1.chemDraw) + ")"
	world2details += "\nChemicals: " + String(world2.chemicals) + "(+" + String(world2.chemicalGrowth) + "/-" + String(world2.chemDraw) + ")"
	world1details += "\nMetals: " + String(world1.metals) + "(+" + String(world1.metalsGrowth) + "/-" + String(world1.metDraw) + ")"
	world2details += "\nMetals: " + String(world2.metals) + "(+" + String(world2.metalsGrowth) + "/-" + String(world2.metDraw) + ")"
	world1details += "\nSupplies: " + String(world1.supplies) + "(+" + String(world1.suppliesGrowth) + "/-" + String(world1.supDraw) + ")"
	world2details += "\nSupplies: " + String(world2.supplies) + "(+" + String(world2.suppliesGrowth) + "/-" + String(world2.supDraw) + ")"
	
	if world1.chemTrades.keys().has(world2.worldName):
		chemTrade = -world1.chemTrades[world2.worldName]
	else:
		chemTrade = 0
	
	$namew1.text = world1details
	$namew2.text = world2details


func _on_Done_pressed():
	
	var line = false
	var exporter
	var importer
	# Outgoing chems
	if chemTrade > 0:
		world1.addTrades(world2, "chem", -chemTrade)
		world2.addTrades(world1, "chem", chemTrade)
		line = true
		exporter = world1
		importer = world2
	elif chemTrade < 0:
		world1.addTrades(world2, "chem", chemTrade)
		world2.addTrades(world1, "chem", -chemTrade)
		line = true
		exporter = world2
		importer = world1
	else:
		world1.removeTrades(world2)
		world2.removeTrades(world1)
	rect_position = Vector2(-1000,125)

	if line:
		var line2d = Line2D.new()
		get_parent().get_parent().add_child(line2d)
		var world1Pos = world1.rect_position
		var world2Pos = world2.rect_position
		world1Pos.x += world1.rect_size.x * 0.5
		world1Pos.y += world1.rect_size.y * 0.5
		world2Pos.x += world2.rect_size.x * 0.5
		world2Pos.y += world2.rect_size.y * 0.5
		line2d.add_point(world1Pos, 0)
		line2d.add_point(world2Pos, 1)
		line2d.modulate = Color(0.3, 0.3, 1.0, 0.2)
		
		var exporterPos = exporter.rect_position
		var importerPos = importer.rect_position
		exporterPos.x += exporter.rect_size.x * 0.5
		exporterPos.y += exporter.rect_size.y * 0.5
		importerPos.x += importer.rect_size.x * 0.5
		importerPos.y += importer.rect_size.y * 0.5
		get_parent().get_parent().get_node("TradeArtManager").addTrade(exporterPos, importerPos)


# In means going from 2 to 1
# Out means going from 1 to 2

# positive means outgoing
# negative means incoming

var chemTrade = 0 

func _on_1inChem_pressed():
	chemTrade -= 1
	updateChemstuff()

func _on_1outChem_pressed():
	chemTrade += 1
	updateChemstuff()

func _on_maxOutChem_pressed():
	chemTrade = world1.chemicalGrowth
	updateChemstuff()

func _on_maxInChem_pressed():
	chemTrade = -world2.chemicalGrowth
	updateChemstuff()

# If you are trading more than you are net gaining, give a warning
func updateChemstuff():
	if chemTrade > 0:
		$chemstuff.text = String(chemTrade) + ">"
		if (world1.chemicalGrowth - world1.chemDraw) < chemTrade:
			$chemstuff.text += "!!!"
	elif chemTrade < 0:
		$chemstuff.text = "<" + String(chemTrade)
		if (-(world2.chemicalGrowth - world2.chemDraw)) > chemTrade:
			$chemstuff.text += "!!!"
	else:
		$chemstuff.text = "0"

func _on_zero_pressed():
	chemTrade = 0
	updateChemstuff()
