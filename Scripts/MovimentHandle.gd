extends Node2D
onready var main_node = get_parent().get_node(".")
onready var animationHandle = get_parent().get_node("Anims_handle")
onready var foot = get_parent().get_node("foot_raycast")
onready var state_machine = get_parent().get_node("StateM_handler")
onready var void_space = get_parent().get_node("landing_space")
onready var physic_handler = get_parent().get_node("Physic_handler")


func _physics_process(_delta):
	state_machine.change_player_state("idle")
	keyboard_actions()


func keyboard_actions():
	movement()
	jump()
	crouched()
	falling_or_landing()
	climb()
	arms_mode()


func crouched():
	if Input.is_action_pressed("ui_down") and main_node.is_on_floor():
		state_machine.change_player_state("crouch")
		physic_handler.keyboard_input.x = 0


func jump():
	if !Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_up") and main_node.is_on_floor() and physic_handler.snap:
		physic_handler.snap = false
		physic_handler.keyboard_input.y = physic_handler.JUMPFORCE
		state_machine.change_player_state("jump")


func falling_or_landing():
	if !main_node.is_on_floor():
		var state_value
		physic_handler.snap = false
		state_value = "landing" if void_space.is_colliding() else "fall"
		state_machine.change_player_state(state_value)


func movement():
	var correct_anim = "walk" if GlobalVariables.move_and_slide.x != 0 else "idle"
	var is_moving = true if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") else false
	if is_moving:
		physic_handler.keyboard_inputs()
		state_machine.change_player_state(correct_anim)
		physic_handler.snap = true if foot.is_colliding() else false


func climb():
	if Input.is_action_pressed("ui_accept") and main_node.is_on_floor():
		state_machine.change_player_state("climb")
		pass


func arms_mode():
	if Input.is_action_pressed("right_click"):
		animationHandle.with_weapon = true
		print("teste")
