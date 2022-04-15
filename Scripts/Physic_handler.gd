extends Node2D

var gravity_dir = Vector2(0, -1)
var keyboard_input = Vector2(0, 0)

const JUMPFORCE = -750
var MAX_SPEED = 400.0
const ACCELERATION = 8.0
var speed = 0
onready var main_node = get_parent().get_node(".")
onready var movement_handle = get_parent().get_node("movement_handle")
onready var playerSprite = main_node.get_node("Player_sprite")
var anims_handler = GlobalVariables.anims_handle_node
var snap = false
const slope_slide_threshold := 45.0
var left_foot_colliding
var right_foot_colliding
var can_fall
var edge_falling_push: int


func _physics_process(_delta) -> void:
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label2, "current speed: ", keyboard_input.x)
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label11, "borderfall state ", edge_falling())
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label12, "scale x player ", main_node.get_node("Player_sprite").scale.x)
	left_foot_colliding = main_node.left_foot_colliding
	right_foot_colliding = main_node.right_foot_colliding
	var snap_vector = Vector2(0, 45) if snap else Vector2()
	GlobalVariables.move_and_slide = main_node.move_and_slide_with_snap(keyboard_input, snap_vector, gravity_dir, slope_slide_threshold)

	keyboard_input.x = speed * GlobalVariables.keyboard_vector
	can_fall = edge_falling_push if edge_falling() else 0
	keyboard_input.x += can_fall
	snapping_fixer()
	apply_gravity()
	edge_falling()

func edge_falling():
	if main_node.is_on_floor() and main_node.ground_rotation == 0 and keyboard_input.x == 0 :
		if !left_foot_colliding or !right_foot_colliding and main_node.is_on_floor():
			if !left_foot_colliding and right_foot_colliding:
				edge_falling_push = -1000
			

			if !right_foot_colliding and left_foot_colliding:
				edge_falling_push = 1000
			
			elif !right_foot_colliding and !left_foot_colliding:
				edge_falling_push = 0
			return true
		else:
			edge_falling_push = 0
			return false


func stop_player():
	speed = 0


func hill_climb_exaustion():
	var going_left = true if main_node.left_foot_colliding and main_node.get_node("Player_sprite").scale.x == 1 else false
	var going_right = true if main_node.right_foot_colliding and main_node.get_node("Player_sprite").scale.x == -1 else false
	if main_node.ground_rotation >= 28 and going_left or main_node.ground_rotation <= -28 and going_right:
		MAX_SPEED = 250
		return true
	else:
		MAX_SPEED = 400
		return false


func keyboard_inputs():
	GlobalVariables.keyboard_vector = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	aceleration_calc()


func aceleration_calc():
	if speed > MAX_SPEED:
		speed = MAX_SPEED

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
