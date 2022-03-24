extends Node2D
onready var playerSprite = get_parent().get_node("Player_sprite")
onready var collisionArea = get_parent().get_node("CollisionArea")
onready var foot = get_parent().get_node("foot_raycast")
onready var state_machine = get_parent().get_node("StateM_handler")
onready var void_space = get_parent().get_node("landing_space")
onready var main_node = get_parent().get_node(".")
onready var left_foot = get_parent().get_node("left_foot")
onready var right_foot = get_parent().get_node("right_foot")

var is_jumping = false
var is_falling = false
var is_landing = false
var cur_animation = "none"
var is_climbing = false
var is_crouched = false
var with_weapon = true


func _process(_delta):
	$AnimationPlayer.playback_speed = 1
	angle_rotation()


func play_animation(animation):
	if cur_animation != animation:
		$AnimationPlayer.play(animation)
		cur_animation = animation


func anim_dir():
	if Input.is_action_pressed("ui_left"):
		playerSprite.scale.x = 1
		collisionArea.scale.x *= -1
	if Input.is_action_pressed("ui_right"):
		playerSprite.scale.x = -1
		collisionArea.scale.x *= -1


func angle_rotation():
	# var wich_foot = true if left_foot.is_colliding() else false
	var left_is_colliding = left_foot.is_colliding()
	var right_is_colliding = right_foot.is_colliding()

	if foot.is_colliding() and left_is_colliding and right_is_colliding:
		playerSprite.rotation_degrees = 0
		collisionArea.rotation_degrees = 0
		# return true
	if !foot.is_colliding():
		var jumping_action = true if is_jumping and !is_falling else false
		var falling_action = true if is_falling and !is_jumping else false
		var angle_value = 10 if jumping_action else -10
		if falling_action or jumping_action:
			playerSprite.rotation_degrees = angle_value * playerSprite.scale.x
			collisionArea.rotation_degrees = angle_value * playerSprite.scale.x

	# elif is_jumping and !is_falling and !foot.is_colliding():
	# 	playerSprite.rotation_degrees = 10 * playerSprite.scale.x
	# 	collisionArea.rotation_degrees = 10 * playerSprite.scale.x
	# elif is_falling and !is_jumping and !foot.is_colliding():
	# 	playerSprite.rotation_degrees = -10 * playerSprite.scale.x
	# 	collisionArea.rotation_degrees = -10 * playerSprite.scale.x

	elif !is_jumping and !is_landing and !is_falling:
		if left_is_colliding and !right_is_colliding:
			playerSprite.rotation_degrees = 15
			collisionArea.rotation_degrees = 15

		elif right_is_colliding and !left_is_colliding:
			playerSprite.rotation_degrees = -15
			collisionArea.rotation_degrees = -15


func idle_animation():
	is_crouched = Input.is_action_pressed("ui_down")
	var is_iddle = GlobalVariables.keyboard_vector > 0 or GlobalVariables.keyboard_vector < 0 and !Input.is_action_pressed("ui_up")
	if is_iddle and !is_crouched and foot.is_colliding() and !is_landing:
		if !with_weapon:
			play_animation("idle")
		else:
			play_animation("Idle_WG")
		$AnimationPlayer.playback_speed = 0.4


func crouched_animation():
	play_animation("crouched")


func walking_animation():
	anim_dir()
	if !is_landing and foot.is_colliding() and GlobalVariables.move_and_slide.x != 0:
		if !with_weapon:
			play_animation("Move")
		else:
			play_animation("walking_WG")


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
		if !with_weapon:
			play_animation("landing")
		else:
			play_animation("Landing_WG")
		is_falling = false
		is_landing = true
		yield(get_tree().create_timer(0.22), "timeout")
		is_landing = false
		return true
