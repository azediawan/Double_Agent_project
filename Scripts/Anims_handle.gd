extends Node2D
onready var playerSprite = get_parent().get_node("Player_sprite")
onready var collisionArea = get_parent().get_node("CollisionArea")
onready var foot = get_parent().get_node("foot_raycast")
onready var state_machine = get_parent().get_node("StateM_handler")
onready var void_space = get_parent().get_node("landing_space")
onready var main_node = get_parent().get_node(".")
onready var physic_handler = get_parent().get_node("Physic_handler")
onready var left_foot
onready var right_foot
var is_jumping = false
var is_falling = false
var is_landing = false
var cur_animation = "none"
var is_climbing = false
var is_crouched = false
var with_weapon = true
var dangerous_fall = false


# var edge_fall = false
func _ready():
	GlobalVariables.anims_handle_node = self
	pass


func _process(_delta):
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label10, "sa porra de edge fall", dangerous_fall)
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label3, "main node rotation: ", playerSprite.rotation_degrees)
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label7, "void space colliding: ", bool(void_space.is_colliding()))
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label8, "foot colliding: ", bool(foot.is_colliding()))
	GlobalVariables.logger.show_in_game(GlobalVariables.logger.label9, "Main node colliding: ", main_node.is_on_floor())

	left_foot = main_node.left_foot_colliding
	right_foot = main_node.right_foot_colliding
	delay_animation(1)
	angle_rotation()


func play_animation(animation):
	if cur_animation != animation:
		$AnimationPlayer.play(animation)
		cur_animation = animation


func delay_animation(time: float):
	$AnimationPlayer.playback_speed = time


func ground_check():
	if void_space.is_colliding() and foot.is_colliding():
		return true
	else:
		play_animation("idle")
		return false


func anim_dir():
	if Input.is_action_pressed("ui_left"):
		playerSprite.scale.x = 1
		collisionArea.scale.x *= -1
	if Input.is_action_pressed("ui_right"):
		playerSprite.scale.x = -1
		collisionArea.scale.x *= -1


func angle_rotation():
	var self_angle_value = main_node.ground_rotation
	var normalize_angle = lerp(0, self_angle_value, 0.4)
	var jumping_action = true if is_jumping and !is_falling else false
	var falling_action = true if is_falling and !is_jumping else false
	var on_air_value = 12 if jumping_action and !falling_action else -16
	# var new_rotate_params = on_air_value if !no_safe_landing() else -55
	playerSprite.rotation_degrees = on_air_value * playerSprite.scale.x

	if physic_handler.hill_climb_exaustion():
		delay_animation(0.55)

	if !falling_action and !jumping_action and foot.is_colliding():
		playerSprite.rotation_degrees = normalize_angle


func idle_animation():
	is_crouched = Input.is_action_pressed("ui_down")
	var is_iddle = GlobalVariables.keyboard_vector > 0 or GlobalVariables.keyboard_vector < 0 and !Input.is_action_pressed("ui_up")
	if is_iddle and !is_crouched and ground_check() and !is_landing:
		if !with_weapon:
			play_animation("idle")
		else:
			play_animation("Idle_WG")
		delay_animation(0.4)


func crouched_animation():
	if !with_weapon:
		play_animation("crouched")
	else:
		play_animation("crouching_WG")


func walking_animation():
	anim_dir()

	if !is_landing and foot.is_colliding() and GlobalVariables.move_and_slide.x != 0 and GlobalVariables.keyboard_vector != 0:
		if !with_weapon:
			play_animation("Move")
		else:
			play_animation("walking_WG")
	else:
		idle_animation()


func jump_animation():
	if !with_weapon:
		play_animation("jump")
	else:
		play_animation("Jump_WG")
	is_crouched = Input.is_action_pressed("ui_down")
	is_jumping = true
	yield(get_tree().create_timer(0.2), "timeout")
	is_jumping = false


func on_air_animations():
	var _land_or_crouch
	is_crouched = Input.is_action_pressed("ui_down")
	anim_dir()
	if !is_jumping and can_fall():
		can_fall()

	if can_land() and !is_jumping:
		_land_or_crouch = crouched_animation() if is_crouched else can_land()


func can_fall():
	var global_player_y = GlobalVariables.move_and_slide.y
	if global_player_y < 0:
		is_falling = false
		return false
	if global_player_y > 0 and !main_node.is_on_floor() and !is_landing:
		is_falling = true
		with_weapon = false
		play_animation("falling")
		return true


func can_land():
	if !void_space.is_colliding() and is_jumping:
		return false
	if void_space.is_colliding() and !is_jumping:
		# physic_handler.edge_falling_push = 20000
		if !with_weapon:
			play_animation("landing")
		else:
			play_animation("Landing_WG")
		is_falling = false
		is_landing = true

		yield(get_tree().create_timer(0.22), "timeout")
		is_landing = false
		return true
