extends Button


export (String) var teamName
export (Color) var teamColor


func _ready():
	self.connect("pressed", self, "buttonPressed")

func buttonPressed():
	get_parent().get_node("Hub").assignTeam(teamName, teamColor)
