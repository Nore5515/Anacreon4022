extends Control


var currentPlanet
export (bool) var displayOnly = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setPlanet(planet):
	
	#print ("values are:", planet.chemPer, ",", planet.metPer, ",", planet.supPer, ",", planet.fightersPer)
	currentPlanet = planet
	if currentPlanet.shipLock:
		$LockShips.text = "Unlock Ships %"
		$LockShips/lock.visible = true
	else:
		$LockShips.text = "Lock Ships %"
		$LockShips/lock.visible = false
		
	updateDetails()

func updatePlanet(chem,met,sup,fig):
	currentPlanet.changePerBy("chem", 0.2)
	#currentPlanet.changePerBy("sup", -0.2)
	#currentPlanet.changePerBy("met", 0.5)
	#currentPlanet.changePerBy("met", 1.5)
	#currentPlanet.changePerBy("sup", -1.5)
	if !displayOnly:
		currentPlanet.chemPer = chem
		currentPlanet.metPer = met
		currentPlanet.supPer = sup
		currentPlanet.fightersPer = fig
	updateDetails()

func updateDetails():
	if currentPlanet != null:
		$ChemSlider.value = currentPlanet.chemPer * 100
		$MetSlider.value = currentPlanet.metPer * 100
		$SupSlider.value = currentPlanet.supPer * 100
		$FigSlider.value = currentPlanet.fightersPer * 100
		$ChemSlider/ChemLabel.text = "Chemicals: " + String($ChemSlider.value/100)
		$MetSlider/MetLabel.text = "Metals: " + String($MetSlider.value/100)
		$SupSlider/SupLabel.text = "Supplies: " + String($SupSlider.value/100)
		$FigSlider/FigLabel.text = "Fighters: " + String($FigSlider.value/100)
		#$ChemSlider.value = currentPlanet.chemPer * 100
		#$MetSlider.value = currentPlanet.metPer * 100
		#$SupSlider.value = currentPlanet.supPer * 100
		#$FigSlider.value = currentPlanet.fightersPer * 100

func balanceValues():
	pass


var clicking = false
var typeToChange = ""
var changeToAmount = -1

func _input(event):
	if event.is_action_pressed("mouseClick"):
		clicking = true
	elif event.is_action_released("mouseClick"):
		clicking = false
		if typeToChange != "" && changeToAmount != -1:
			if currentPlanet != null:
				print ("Released and changing!", typeToChange, changeToAmount)
				currentPlanet.changePerTo(typeToChange, changeToAmount)
				updateDetails()
				typeToChange = ""
				changeToAmount = -1


# NEED A WAY TO DETECT CHANGE ONLY WHEN LETTING GO
func _on_ChemSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.chemPer = $ChemSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		if currentPlanet.shipLock:
			$MetSlider.value -= remainder * 0.5
			$SupSlider.value -= remainder * 0.5
		else:
			$MetSlider.value -= remainder * 0.33
			$SupSlider.value -= remainder * 0.33
			$FigSlider.value -= remainder * 0.34
			
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$ChemSlider.value = 100 - ($MetSlider.value + $SupSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	elif currentPlanet != null && displayOnly:
		if clicking:
			typeToChange = "chem"
			changeToAmount = value/100
			#print (typeToChange, ": ", changeToAmount)
		
		
		#currentPlanet.changePerTo("chem", value/100)
		#updateDetails()

func _on_MetSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.metPer = $MetSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value +$FigSlider.value)-100
		if currentPlanet.shipLock:
			$ChemSlider.value -= remainder * 0.5
			$SupSlider.value -= remainder * 0.5
		else:
			$ChemSlider.value -= remainder * 0.33
			$SupSlider.value -= remainder * 0.33
			$FigSlider.value -= remainder * 0.34
			
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$MetSlider.value = 100 - ($ChemSlider.value + $SupSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	elif currentPlanet != null && displayOnly:
		if clicking:
			typeToChange = "met"
			changeToAmount = value/100
			#print (typeToChange, ": ", changeToAmount)
	
func _on_SupSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.supPer = $SupSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		if currentPlanet.shipLock:
			$ChemSlider.value -= remainder * 0.5
			$MetSlider.value -= remainder * 0.5
		else:
			$ChemSlider.value -= remainder * 0.33
			$MetSlider.value -= remainder * 0.33
			$FigSlider.value -= remainder * 0.34
			
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$SupSlider.value = 100 - ($MetSlider.value + $ChemSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	elif currentPlanet != null && displayOnly:
		if clicking:
			typeToChange = "sup"
			changeToAmount = value/100
			#print (typeToChange, ": ", changeToAmount)
	
func _on_FigSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.fightersPer = $FigSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		$ChemSlider.value -= remainder * 0.5
		$MetSlider.value -= remainder * 0.5
		$SupSlider.value -= remainder * 0.5
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	elif currentPlanet != null && displayOnly:
		if clicking:
			typeToChange = "fig"
			changeToAmount = value/100
			#print (typeToChange, ": ", changeToAmount)


func _on_ConfirmChange_pressed():
	updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)


func _on_LockShips_pressed():
	if currentPlanet != null:
		print ("Lockswap", currentPlanet.shipLock)
		if currentPlanet.shipLock:
			currentPlanet.shipLock = false
			$LockShips/lock.visible = false
			$LockShips.text = "Lock Ships %"
		else:
			currentPlanet.shipLock = true
			$LockShips/lock.visible = true
			$LockShips.text = "Unlock Ships %"
		updateDetails()
