extends KinematicBody2D
onready var foot = get_node("foot_raycast")
onready var testeca = get_node("VBoxContainer/Label7")
onready var right_cast = get_node("right_cast")
onready var left_cast = get_node("left_cast")
onready var temp_var3 = get_node("VBoxContainer/Label4")
onready var temp_var4 = get_node("VBoxContainer/Label5")
var ground_rotation = 0
var left_foot_colliding: bool
var right_foot_colliding: bool


func _process(_delta):
	testeca.text = str("ground rotation: ", ground_rotation)
	var foot_colliding_obj = foot.get_collider()
	if foot_colliding_obj != null:
		ground_rotation = foot_colliding_obj.rotation_degrees
	if right_cast.is_colliding() != null or left_cast.is_colliding() != null:
		left_foot_colliding = left_cast.is_colliding()
		right_foot_colliding = right_cast.is_colliding()
		temp_var3.text = str("left foot: ", bool(left_cast.is_colliding()))
		temp_var4.text = str("right foot: ", bool(right_cast.is_colliding()))
	# var both_legs_on_ground = true if left_colliding and right_colliding else false
	# if both_legs_on_ground:
	# 	ground_rotation = 0
	# right_collider(null)
	# left_collider(null)


func left_collider(_body):
	left_foot_colliding = true


func right_collider(_body):
	right_foot_colliding = true


func left_collider_exit(_body) -> void:
	left_foot_colliding = false


func right_collider_exit(_body) -> void:
	right_foot_colliding = false
