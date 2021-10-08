extends Camera2D

var movement = Vector2(0,0)
export (float) var speed = 10.0
var zoomScale = 1.0

func _input(event):
	movement = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		#self.translate(Vector2(0,-20))
		movement += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		#self.translate(Vector2(0,20))
		movement += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		#self.translate(Vector2(-20,0))
		movement += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		#self.translate(Vector2(20,0))
		movement += Vector2(1, 0)
	
	if Input.is_action_pressed("scrollUp"):
		zoomScale -= 0.1
	if Input.is_action_pressed("scrollDown"):
		zoomScale += 0.1

func _process(delta):
	self.translate(movement * speed)
	zoom = Vector2(zoomScale, zoomScale)
