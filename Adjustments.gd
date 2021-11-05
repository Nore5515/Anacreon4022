extends Control


var currentPlanet
export (bool) var displayOnly = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setPlanet(planet):
	$ChemSlider.value = planet.chemPer * 100
	$MetSlider.value = planet.metPer * 100
	$SupSlider.value = planet.supPer * 100
	$FigSlider.value = planet.fightersPer * 100
	print ("values are:", planet.chemPer, ",", planet.metPer, ",", planet.supPer, ",", planet.fightersPer)
	currentPlanet = planet
	updateDetails()

func updatePlanet(chem,met,sup,fig):
	currentPlanet.chemPer = chem
	currentPlanet.metPer = met
	currentPlanet.supPer = sup
	currentPlanet.fightersPer = fig
	updateDetails()

func updateDetails():
	if currentPlanet != null:
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

func _on_ChemSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.chemPer = $ChemSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		$MetSlider.value -= remainder * 0.5
		$SupSlider.value -= remainder * 0.5
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$ChemSlider.value = 100 - ($MetSlider.value + $SupSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)

func _on_MetSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.metPer = $MetSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value +$FigSlider.value)-100
		$ChemSlider.value -= remainder * 0.5
		$SupSlider.value -= remainder * 0.5
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$MetSlider.value = 100 - ($ChemSlider.value + $SupSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	
func _on_SupSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.supPer = $SupSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		$ChemSlider.value -= remainder * 0.5
		$MetSlider.value -= remainder * 0.5
		if ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value) > 100:
			$SupSlider.value = 100 - ($MetSlider.value + $ChemSlider.value + $FigSlider.value)
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
	
func _on_FigSlider_value_changed(value):
	if currentPlanet != null && !displayOnly:
		#currentPlanet.fightersPer = $FigSlider.value/100
		var remainder = ($ChemSlider.value + $MetSlider.value + $SupSlider.value+$FigSlider.value)-100
		$ChemSlider.value -= remainder * 0.5
		$MetSlider.value -= remainder * 0.5
		$SupSlider.value -= remainder * 0.5
		updateDetails()
		#updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)


func _on_ConfirmChange_pressed():
	updatePlanet($ChemSlider.value/100, $MetSlider.value/100, $SupSlider.value/100, $FigSlider.value/100)
