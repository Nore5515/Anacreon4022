extends Button

export (String) var worldName = "Anacreon"
export (String) var worldClass = "K-Type"
export (String) var worldDesg = "Mining World"
export (String) var worldTech = "Warp"
export (float) var techMod = 1.0
var status = ""
#pt = 0.01
#p = 0.05
#pa = 0.1
#a = 0.25
#pw = 0.5
#w = 1.0

var chemicals = 0
var metals = 0
var supplies = 0

var chemLaborMod = 1
var metLaborMod = 2
var supLaborMod = 4

var chemicalGrowth = 100.0
var metalsGrowth = 100.0
var suppliesGrowth = 100.0

var chemDraw = 0.0
var metDraw = 0.0
var supDraw = 0.0

var chemTrades = {}
var netChemExchange = 0

var metTrades = {}
var netMetExchange = 0

var supTrades = {}
var netSupExchange = 0

var chemDanger = ""
var metDanger = ""
var supDanger = ""

var team = ""

var efficency = 1.0
export (float) var industry = 150
var idealIndustry = 150
export (float) var population = 4.0 #billions

var chemPer = 0.25
var metPer = 0.50
var supPer = 0.25

var shipLock = false

var fighters = 0
var fightersPer = 0.0
var fighterGrowth = 0

export (bool) var changedTeamThisYear = false

var disasters = []

func _ready():
	init()

func setTeam(teamName, teamColor):
	team = teamName
	modulate = teamColor

func init():
	if (worldTech == "Pre-Tech"):
		techMod = 0.01
	elif (worldTech == "Primitive"):
		techMod = 0.05
	elif (worldTech == "Pre-Atomic"):
		techMod = 0.1
	elif (worldTech == "Atomic"):
		techMod = 0.25
	elif (worldTech == "Pre-Warp"):
		techMod = 0.5
	elif (worldTech == "Warp"):
		techMod = 1.0
	if worldClass == null:
		worldClass = "Independent World"
	#updateDetails()

func addTrades(planetName, type, amount):
	if (type == "chem"):
		if chemTrades.keys().has(planetName):
			chemTrades[planetName] += amount
		else:		
			chemTrades[planetName] = amount
	elif (type == "met"):
		if metTrades.keys().has(planetName):
			metTrades[planetName] += amount
		else:
			metTrades[planetName] = amount
	elif (type == "sup"):
		if supTrades.keys().has(planetName):
			supTrades[planetName] += amount
		else:
			supTrades[planetName] = amount
	
	netChemExchange = 0
	for key in chemTrades.keys():
		netChemExchange += chemTrades[key]
	
	netMetExchange = 0
	for key in metTrades.keys():
		netMetExchange += metTrades[key]
		
	netSupExchange = 0
	for key in supTrades.keys():
		netSupExchange += supTrades[key]


func removeTrades(planetName):
	if chemTrades.keys().has(planetName):
		chemTrades.erase(planetName)
	if metTrades.keys().has(planetName):
		metTrades.erase(planetName)
	if supTrades.keys().has(planetName):
		supTrades.erase(planetName)

func desgPlanet(newDesg):
	if newDesg == worldDesg:
		# No change
		pass
	else:
		if newDesg == "Mining World":
			chemPer = 0.25
			metPer = 0.50
			supPer = 0.25
		elif newDesg == "Agri World":
			chemPer = 0.25
			metPer = 0.25
			supPer = 0.50
		elif newDesg == "Chemical World":
			chemPer = 0.50
			metPer = 0.25
			supPer = 0.25
		elif newDesg == "Independent World":
			chemPer = 0.33
			metPer = 0.33
			supPer = 0.34
		worldDesg = newDesg
		efficency = 1 - (1/(0.95+efficency))
		efficency = stepify(efficency, 0.01)
		if efficency < 0.1:
			efficency = 0.1
		chemicalGrowth = chemPer * industry * efficency
		metalsGrowth = metPer * industry * efficency
		suppliesGrowth = supPer * industry * efficency
		updateDetails()

func _on_Planet_pressed():
	$Details.visible = !$Details.visible
	get_tree().get_nodes_in_group("hub")[0].setPlanet(self)
	get_tree().get_nodes_in_group("sliders")[0].setPlanet(self)


func endYear():
	
	disasters = []
	
	metDraw += (fightersPer*5) * metalsGrowth
	
	chemicals += ceil(chemicalGrowth-chemDraw)
	metals += ceil(metalsGrowth-metDraw)
	supplies += ceil(suppliesGrowth-supDraw)
	efficency += 1 / (1.0 + efficency) * 0.1
	efficency = stepify(efficency, 0.01)
	if efficency < 0.1:
		efficency = 0.1
	elif efficency > 1.0:
		efficency = 1.0
	
	chemicalGrowth = chemPer * industry * efficency * chemLaborMod
	metalsGrowth = metPer * industry * efficency * metLaborMod
	suppliesGrowth = supPer * industry * efficency * supLaborMod
	chemDraw = population * techMod * 2.5
	chemDraw = stepify(chemDraw, 0.01)
	metDraw = population * 2.5 * techMod
	metDraw = stepify(metDraw, 0.01)
	supDraw = population * 5 * techMod
	supDraw = stepify(supDraw, 0.01)
	
	if netChemExchange < 0:
		chemDraw -= netChemExchange
	else:
		chemicalGrowth += netChemExchange
		
	if netMetExchange < 0:
		metDraw -= netMetExchange
	else:
		metalsGrowth += netMetExchange
		
	if netSupExchange < 0:
		supDraw -= netSupExchange
	else:
		suppliesGrowth += netSupExchange
	
	$warningIcon.visible = false
	status = ""
	if chemicals < 0:
		chemicals = 0
		efficency = efficency * 0.9
		status += "Chem Shortages   "
		disasters.append("ChemDrought")
		$warningIcon.visible = true
	if metals < 0:
		metals = 0
		industry = industry * 0.8
		status += "Industrial Collapse   "
		disasters.append("IndustrialCollapse")
		$warningIcon.visible = true
	if supplies < 0:
		supplies = 0
		population = population * 0.8
		status += "Famine   "
		disasters.append("Famine")
		$warningIcon.visible = true

	if metals > 0:
		fighters += floor(fightersPer * industry * efficency * 0.1)
	
	population += 1.1 * ((26-population)/26)
	idealIndustry = population * 20 * techMod
	if (idealIndustry > industry):
		industry += (idealIndustry - industry) * 0.25
		if (idealIndustry - industry) < 15:
			industry = idealIndustry
	
	
	if chemDraw > chemicalGrowth:
		chemDanger = "!"
		if chemicals - chemDraw * 10 < 0:
			chemDanger = "!!!"
	else:
		chemDanger = ""
	if metDraw > metalsGrowth:
		metDanger = "!"
		if metals - metDraw * 10 < 0:
			metDanger = "!!!"
	else:
		metDanger = ""
	if supDraw > suppliesGrowth:
		supDanger = "!"
		if supplies - supDraw * 10 < 0:
			supDanger = "!!!"
	else:
		supDanger = ""

	
	if team != get_node("/root/Global").playerTeam:
		
		if team != "":
			AIaction()
		
		"""if team != "" && changedTeamThisYear == false:
			print ("Teaming!")
			var nearest = getNearestUnalignedPlanet()
			if nearest == null:
				print ("No unaligned planets!")
			else: 
				if nearest.team == "":
					nearest.setTeam(team, modulate)
					nearest.changedTeamThisYear = true"""
	
	changedTeamThisYear = false

	
	updateDetails()



#### AI MIND
var aiMemory = {
	"daysWithSup": 0,
	"famineScars": 0,
	"fleetDelay": 100,
}

func AIaction():
	#print ("================\nAi Acting!")
	
	aiMemory.fleetDelay -= fighters
	if aiMemory.fleetDelay <= 0:
		aiMemory.fleetDelay = 100
		var fleetType = load("res://Fleet.tscn")
		var instance = fleetType.instance()
		instance.assignTeam(get_node("/root/Global").aiTeam, get_node("/root/Global").aiColor)
		get_parent().call_deferred("add_child", instance)
		instance.position.x = rect_position.x
		instance.position.y = rect_position.y
		instance.fighters += fighters
		fighters = 0
		updateDetails()
	
	if disasters.has("Famine"):
		#print ("FAMINE!!!!")
		aiMemory.famineScars += 1
		aiMemory.daysWithSup = 0
		if supPer < 0.8:
			#changePerTo("sup", 0.8)
			changePerBy("sup", 0.3)
		elif supPer >= 0.8:
			#changePerTo("sup", 1.0)
			changePerBy("sup", 0.3)
		print ("New sup per: ", supPer)
	elif supDanger != "":
		if supPer < 0.7:
			#changePerTo("sup", supPer + 0.2)
			changePerBy("sup", 0.2)
		elif supPer >= 0.7 && supPer <= 0.9:
			#changePerTo("sup", supPer + 0.1)
			changePerBy("sup", 0.1)
		elif supPer >= 0.9:
			#changePerTo("sup", 1.0)
			changePerBy("sup", 1.0)
		aiMemory.daysWithSup = 0
		#print ("Starvation danger! Raising sup%...")
		#print ("New sup per: ", supPer)
	else:
		#print ("Food supply steady...")
		aiMemory.daysWithSup += 1
		if (aiMemory.famineScars*2) + 3 < aiMemory.daysWithSup:
			#print ("It's time to switch production!") 
			if supPer > 0.2:
				#print (supPer, "current sup per")
				#changePerTo("sup", supPer - 0.2)
				changePerBy("sup", -0.2)          # CHANGED!		
				#print (supPer, "post sup per")
			else:
				pass
				#print ("not enough sup production!")
			aiMemory.daysWithSup = 0

"""
currentPlanet.changePerBy("chem", 0.2)
	currentPlanet.changePerBy("sup", -0.2)
	currentPlanet.changePerBy("met", 0.5)
	currentPlanet.changePerBy("met", 1.5)
	currentPlanet.changePerBy("sup", -1.5)
"""

func changePerBy(perType, amountIncoming):
	
	var arrayOfPers = [chemPer, metPer, supPer, fightersPer]
	var indexChangedPer = -1
	if perType == "chem":
		indexChangedPer = 0
	elif perType == "met":
		indexChangedPer = 1
	elif perType == "sup":
		indexChangedPer = 2
	elif perType == "fig":
		indexChangedPer = 3
	else:
		print ("ERR; changePerBy, perType does not match any known types")
	
	var indexLabels = ["chem", "met", "sup", "fig"]
	
	#print ("god")
	
	var amount = amountIncoming
	# if trying to change over100/under0, change to reasonable
	if arrayOfPers[indexChangedPer] + amount > 1.0:
		print ("Too large! Reducing amount to add to 1.0")
		amount = (1.0-(arrayOfPers[indexChangedPer]))
	elif arrayOfPers[indexChangedPer] + amount < 0.0:
		print ("Too small! Reducing amount to add to 0.0")
		amount = -(arrayOfPers[indexChangedPer])
	
	
	#currentPlanet.chemPer = $ChemSlider.value/100
	var remainder = (chemPer + metPer + supPer + fightersPer + amount)-1.0
	print ("Remainder:" , remainder)
	
	### IDEA WHILE LOOP
	arrayOfPers[indexChangedPer] += remainder
	var initialRemainder = remainder
	
	
	var negative = false
	if initialRemainder < 0:
		negative = true
	else:
		negative = false
	
	var allNegative = false
	var divideBy = 1.0/(arrayOfPers.size()-1.0)
	print ("DIVIDE BY\t", divideBy)
	# Until remainder is distributed, keep looping
	var zeroedElements = 0
	while (abs(remainder) > 0):
		initialRemainder = remainder
		if shipLock:
			for n in 3:
				if n == indexChangedPer:
					pass
				else:
					if (arrayOfPers[n] - initialRemainder * 0.5) <= 0:
						remainder -= arrayOfPers[n]
						arrayOfPers[n] = 0
					else:
						arrayOfPers[n] -= initialRemainder * 0.5
						remainder -= initialRemainder * 0.5
				if negative && remainder > 0:
					#print ("DONE", arrayOfPers)
					remainder = 0
				if !negative && remainder < 0:
					#print ("DONE", arrayOfPers)
					remainder = 0
		# All
		else:
			allNegative = true
			#print ("---New loop---\nZeroed elements: ", zeroedElements)
			var i = 0
			
			
			if (zeroedElements + 1) == arrayOfPers.size():
				pass
				#print ("Cannot divide by zero!")
			else:
				divideBy = 1.0/(arrayOfPers.size()-(1.0 + zeroedElements))
				zeroedElements = 0
				for n in arrayOfPers.size():
					# Chem Met Sup Fig is the order of pers in the array.
					#print ("Iteration ", i)
					#print ("Loop Stats: \n\tRemainder: ", remainder, "\n\tInitial remainder: ", initialRemainder, "\n\tReduction value: ", initialRemainder * divideBy, "\n\tPer stats: ", arrayOfPers)
					i += 1
					if abs(remainder) <= 0.00001:
						# Could this not be stepify (remainder, 0.01)?
						#print ("Absolute value of remainder is less than 0.01, rounding to 0.")
						remainder = 0
					else:
						#print ("Absolute value of remainder is above 0.01, continuing.")
						if n == indexChangedPer:
							pass#print ("This is the value that has been changed, and we are ignoring.")
						else:
							if (arrayOfPers[n] - initialRemainder * divideBy) <= 0 && remainder > arrayOfPers[n]:
								#print ("The ", indexLabels[n], " per would go negative if reduced by the reduction amount.")
								#print ("Remainder was instead reduced by the per's current value, and the per was set to 0.")
								remainder -= arrayOfPers[n]
								arrayOfPers[n] = 0
								zeroedElements += 1
							else:
								#print ("The ", indexLabels[n], " per and the remainder were reduced by the reduction amount.")
								arrayOfPers[n] -= initialRemainder * divideBy
								remainder -= initialRemainder * divideBy
								# Remove?
								allNegative = false
							#print ("New ", indexLabels[n], " per is now: ", arrayOfPers[n])
							#print ("New remainder is now: ", remainder)
					
					## Not necessary?
					if negative && remainder > 0:
						#print ("DONE", arrayOfPers)
						remainder = 0
					if !negative && remainder < 0:
						#print ("DONE", arrayOfPers)
						remainder = 0
				
			# This shouldn't exist...
			if allNegative:
				remainder = 0
				#print ("GAAAA")
	
	var total = 0
	for n in arrayOfPers.size():
		total += arrayOfPers[n]

	var totalWithoutChanged = 0
	for n in arrayOfPers.size():
		if n == indexChangedPer:
			# Skip the index that we're currently changing
			pass
		else:
			totalWithoutChanged += arrayOfPers[n]


	if (total) > 1.0 || total < 0.0:
		print ("Total Per does not add up correctly. This is a minor issue if it happens once...")
		#arrayOfPers[indexChangedPer] = 1.0 - (totalWithoutChanged)
	
	print ("End Results:\n\t", arrayOfPers, "\n\tTotal: ", total)

	if perType == "chem":
		indexChangedPer = 0
	elif perType == "met":
		indexChangedPer = 1
	elif perType == "sup":
		indexChangedPer = 2
	elif perType == "fig":
		indexChangedPer = 3
		
	chemPer = arrayOfPers[0]
	metPer = arrayOfPers[1]
	supPer = arrayOfPers[2]
	fightersPer = arrayOfPers[3]
	
	# UPDATE PERS WITH ARRAY OF PERS
	updateDetails()


func changePerTo(perType, amount):
	var arrayOfPers = [chemPer, metPer, supPer, fightersPer]
	var indexChangedPer = -1
	if perType == "chem":
		indexChangedPer = 0
	elif perType == "met":
		indexChangedPer = 1
	elif perType == "sup":
		indexChangedPer = 2
	elif perType == "fig":
		indexChangedPer = 3
	else:
		print ("ERR; changePerBy, perType does not match any known types")
	
	var changeBy = amount-arrayOfPers[indexChangedPer]
	changePerBy(perType, changeBy)


func getNearestUnalignedPlanet():
	var nearest 
	for planet in get_tree().get_nodes_in_group("planet"):
		if planet == self:
			pass
		elif planet.team != "":
			pass
		else:
			if nearest == null:
				nearest = planet
			else:
				if (self.get_global_rect().position-planet.get_global_rect().position).length() < (self.get_global_rect().position - nearest.get_global_rect().position).length():
					nearest = planet
	
	return nearest

func updateDetails():
	
	var string = "NAME: " + worldName
	string += "\nCLASS: " + worldClass
	string += "\nDESG: " + worldDesg
	string += "\nTech: " + worldTech
	string += "\nEfficency: " + String(efficency)
	string += "\nIndustry: " + String(stepify(industry,0.1)) + " (" + String((stepify(idealIndustry,0.1))) + ")"
	string += "\nPopulation: " + String(stepify(population,0.1)) + " Billions"
	string += "\nStatus: " + status
	string += "\n\n" + chemDanger + "Chemicals: " + String(chemicals) + " [" + String(chemicalGrowth-chemDraw) + "] (+" + String(chemicalGrowth) + ")  (-" + String (chemDraw) + ")"
	string += "\n" + metDanger + "Metals: " + String(metals) + " [" + String(metalsGrowth-metDraw) + "] (+" + String(metalsGrowth) + ")  (-" + String (metDraw) + ")"
	string += "\n" + supDanger + "Supplies: " + String(supplies) + " [" + String(suppliesGrowth-supDraw) + "]  (-" + String (supDraw) + ")"
	string += "\n" + "Fighters: " + String(fighters) + " [" + String(fighterGrowth) + "]"
	string += "\n\nTRADES: " + String(chemTrades)
	$Details.text = string
