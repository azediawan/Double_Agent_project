extends Node2D

var gravity_dir = Vector2(0, -1)
var keyboard_input = Vector2(0, 0)

const JUMPFORCE = -750
var MAX_SPEED = 400.0
const ACCELERATION = 8.0
var speed = 0
onready var temp_var3 = get_parent().get_node("VBoxContainer/Label9")
onready var main_node = get_parent().get_node(".")
onready var moviment_handle = get_parent().get_node("movement_handle")

var snap = false
const slope_slide_threshold := 45.0


func _physics_process(_delta) -> void:
	temp_var3.text = str("current speed: ", speed)
	var snap_vector = Vector2(0, 45) if snap else Vector2()
	GlobalVariables.move_and_slide = main_node.move_and_slide_with_snap(keyboard_input, snap_vector, gravity_dir, slope_slide_threshold)
	# keyboard_input.x = lerp(keyboard_input.x, 0, 5)
	keyboard_input.x = speed * GlobalVariables.keyboard_vector
	snapping_fixer()
	apply_gravity()
	hill_climb_exaustion()
	if (
		Input.is_action_just_released("ui_right")
		or Input.is_action_just_released("ui_left")
		or Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left")
	):
		speed = 0
		GlobalVariables.move_and_slide.x = 0
	# print(keyboard_input.x)


func hill_climb_exaustion():
	var going_left = true if main_node.right_foot_colliding and main_node.get_node("Player_sprite").scale.x == 1 else false
	var going_right = true if main_node.left_foot_colliding and main_node.get_node("Player_sprite").scale.x == -1 else false
	if main_node.ground_rotation >= 28 and going_left or main_node.ground_rotation <= -28 and going_right:
		MAX_SPEED = 250
	else:
		MAX_SPEED = 400


func keyboard_inputs():
	GlobalVariables.keyboard_vector = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	aceleration_calc()


func aceleration_calc():
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	# if GlobalVariables.keyboard_vector == 1:
	# 	yield(get_tree().create_timer(0.01), "timeout")
	# 	speed += ACCELERATION

	if GlobalVariables.keyboard_vector != 0:
		yield(get_tree().create_timer(0.01), "timeout")
		speed += ACCELERATION


func snapping_fixer():
	if main_node.is_on_floor() and !snap:
		snap = true


func apply_gravity():
	var GRAVITY = 45 if keyboard_input.y <= 605 else 0

	if snap:
		keyboard_input.y = GRAVITY
	else:
		keyboard_input.y += GRAVITY
