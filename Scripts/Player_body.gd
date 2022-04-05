extends KinematicBody2D
onready var foot = get_node("foot_raycast")
onready var right_cast = get_node("right_cast")
onready var left_cast = get_node("left_cast")
var ground_rotation = 0
var left_foot_colliding: bool
var right_foot_colliding: bool


func _process(_delta):
	var foot_colliding_obj = foot.get_collider()
	if foot_colliding_obj != null:
		ground_rotation = foot_colliding_obj.rotation_degrees
	if right_cast.is_colliding() != null or left_cast.is_colliding() != null:
		left_foot_colliding = left_cast.is_colliding()
		right_foot_colliding = right_cast.is_colliding()

	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label4, "floor rotation: ", ground_rotation)
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label5, "right foot is colliding: ", right_foot_colliding)
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label6, "left foot is colliding: ", left_foot_colliding)


func left_collider(_body):
	left_foot_colliding = true


func right_collider(_body):
	right_foot_colliding = true


func left_collider_exit(_body) -> void:
	left_foot_colliding = false


func right_collider_exit(_body) -> void:
	right_foot_colliding = false
