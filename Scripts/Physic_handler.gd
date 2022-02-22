extends Node2D

var gravity_dir = Vector2(0, -1)
var keyboard_input = Vector2(0, 0)

const JUMPFORCE = -750
const MAX_SPEED = 500.0
const ACCELERATION = 50.0
onready var main_node = get_parent().get_node(".")
onready var moviment_handle = get_parent().get_node("movement_handle")
var snap = false
const slope_slide_threshold := 45.0


func _physics_process(_delta):
	var snap_vector = Vector2(0, 45) if snap else Vector2()
	GlobalVariables.move_and_slide = main_node.move_and_slide_with_snap(keyboard_input, snap_vector, gravity_dir, slope_slide_threshold)
	print(keyboard_input.x)
	keyboard_input.x = lerp(keyboard_input.x, 0, 0.16)
	snapping_fixer()
	apply_gravity()


func keyboard_inputs():
	GlobalVariables.keyboard_vector = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	lerp_animation()


func lerp_animation():
	print(keyboard_input.x)

	if GlobalVariables.keyboard_vector == 1:
		yield(get_tree().create_timer(0.02), "timeout")
		keyboard_input.x = min(keyboard_input.x + ACCELERATION, MAX_SPEED)

	elif GlobalVariables.keyboard_vector != 1:
		yield(get_tree().create_timer(0.02), "timeout")
		keyboard_input.x = max(keyboard_input.x + -ACCELERATION, -MAX_SPEED)


func snapping_fixer():
	if main_node.is_on_floor() and !snap:
		snap = true


func apply_gravity():
	var GRAVITY = 45 if keyboard_input.y <= 605 else 0

	if snap:
		keyboard_input.y = GRAVITY
	else:
		keyboard_input.y += GRAVITY
