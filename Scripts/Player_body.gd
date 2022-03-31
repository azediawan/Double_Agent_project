extends KinematicBody2D
var ground_rotation = 0

onready var testeca = get_node("VBoxContainer/Label7")
var left_colliding = false
var right_colliding = false
var wtf


func _process(_delta):
	testeca.text = str("ground rotation: ", ground_rotation)
	# var both_legs_on_ground = true if left_colliding and right_colliding else false
	# if both_legs_on_ground:
	# 	ground_rotation = 0
	# right_collider(null)
	# left_collider(null)


func left_collider(body):
	left_colliding = true
	ground_rotation = body.rotation_degrees


func right_collider(body):
	right_colliding = true
	ground_rotation = body.rotation_degrees


func left_collider_exit(_body):
	left_colliding = false


func right_collider_exit(_body):
	right_colliding = false
