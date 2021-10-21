extends Node2D


var mouseOver = false
var selected = false

var destination = Vector2()
var destIcon


func select():
	selected = true
	$icon.visible = true

func deselect():
	selected = false
	$icon.visible = false

func _process(delta):
	var movement = destination - position
	movement = movement / movement.length()
	position += movement
	look_at(destination)
	rotate(PI*0.5)

func _input(event):
	if event.is_action_pressed("mouseClick"):
		if mouseOver:
			select()
		else:
			if selected:
				if destIcon == null:
					var instance = Sprite.new()
					instance.texture = load("res://Imports/icon.png")
					instance.scale = Vector2(0.023, 0.023)
					get_parent().call_deferred("add_child", instance)
					instance.position = event.position
					destIcon = instance
					destination = event.position
				else:
					destIcon.queue_free()
					var instance = Sprite.new()
					instance.texture = load("res://Imports/icon.png")
					instance.scale = Vector2(0.023, 0.023)
					get_parent().call_deferred("add_child", instance)
					instance.position = event.position
					destIcon = instance
					destination = event.position
	if event.is_action_pressed("esc"):
		if selected:
			deselect()

func _on_Area2D_mouse_entered():
	mouseOver = true


func _on_Area2D_mouse_exited():
	mouseOver = false
