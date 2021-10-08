extends Node2D


export (int) var planetCount
export (float) var radius

var planet = load("res://Planet.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	for i in range(planetCount):
		var r = radius * sqrt(rng.randf())
		var theta = rng.randf() * 2 * PI
		var x = position.x + (r * cos(theta))
		var y = position.y + (r * sin(theta))
		var instance = planet.instance()
		get_parent().call_deferred("add_child", instance)
		instance.rect_position.x = x
		instance.rect_position.y = y
		instance = randomizePlanet(instance)

func randomizePlanet(p):
	p.worldName = worldNames[rng.randi_range(0, worldNames.size()-1)]
	p.worldTech = worldTechs[rng.randi_range(0, worldTechs.size()-1)]
	p.init()
	p.population = 10 * p.techMod
	p.industry = p.population * 10 * p.techMod
	p.desgPlanet("Independent World")
	p.init()
	return p

var worldNames = ["Earth", "Mars", "Venus", "Mercury", "Alpha Centari", "Dune"]
var worldTechs = ["Pre-Tech", "Primitive", "Primitive", "Pre-Atomic", "Pre-Atomic", "Pre-Atomic", "Atomic", "Atomic", "Pre-Warp", "Warp"]
