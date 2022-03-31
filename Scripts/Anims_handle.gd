extends Node2D
onready var playerSprite = get_parent().get_node("Player_sprite")
onready var collisionArea = get_parent().get_node("CollisionArea")
onready var foot = get_parent().get_node("foot_raycast")
onready var state_machine = get_parent().get_node("StateM_handler")
onready var void_space = get_parent().get_node("landing_space")
onready var main_node = get_parent().get_node(".")
onready var left_foot
onready var right_foot

onready var temp_var = get_parent().get_node("VBoxContainer/Label2")
onready var temp_var2 = get_parent().get_node("VBoxContainer/Label3")
onready var temp_var3 = get_parent().get_node("VBoxContainer/Label4")
onready var temp_var4 = get_parent().get_node("VBoxContainer/Label5")
onready var temp_var5 = get_parent().get_node("VBoxContainer/Label6")
onready var temp_var7 = get_parent().get_node("VBoxContainer/Label7")
onready var temp_var8 = get_parent().get_node("VBoxContainer/Label8")

var is_jumping = false
var is_falling = false
var is_landing = false
var cur_animation = "none"
var is_climbing = false
var is_crouched = false
var with_weapon = true


func _process(_delta):
	left_foot = main_node.left_colliding
	right_foot = main_node.right_colliding
# 	temp_var7.text = str(main_node.temp_area)
	temp_var8.text = str("main node rotation: ", playerSprite.rotation_degrees)
	$AnimationPlayer.playback_speed = 1
	angle_rotation()
	if void_space.is_colliding():
		temp_var.text = str("void space: colliding")

	if foot.is_colliding():
		temp_var2.text = str("foots: colliding ")
	if left_foot:
		temp_var3.text = "left foot: colliding"
	if left_foot:
		temp_var4.text = "right foot: colliding"
	if main_node.is_on_floor():
		temp_var5.text = "main node collider: colliding"
	else:
		temp_var3.text = "left foot: not colliding"
		temp_var4.text = "right foot: not colliding"
		temp_var.text = "void space: not colliding"
		temp_var2.text = "foots: not colliding"
		temp_var5.text = "main node collider: not colliding"


func play_animation(animation):
	if cur_animation != animation:
		$AnimationPlayer.play(animation)
		cur_animation = animation


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
	var angle_value = main_node.ground_rotation
	var jumping_action = true if is_jumping and !is_falling else false
	var falling_action = true if is_falling and !is_jumping else false

	if !falling_action and !jumping_action:
		playerSprite.rotation_degrees = angle_value
	if jumping_action and !falling_action:
		playerSprite.rotation_degrees = 10 * playerSprite.scale.x
	if falling_action and !jumping_action:
		playerSprite.rotation_degrees = -10 * playerSprite.scale.x


func idle_animation():
	is_crouched = Input.is_action_pressed("ui_down")
	var is_iddle = GlobalVariables.keyboard_vector > 0 or GlobalVariables.keyboard_vector < 0 and !Input.is_action_pressed("ui_up")
	if is_iddle and !is_crouched and ground_check() and !is_landing:
		if !with_weapon:
			play_animation("idle")
		else:
			play_animation("Idle_WG")
		$AnimationPlayer.playback_speed = 0.4


func crouched_animation():
	if !with_weapon:
		play_animation("crouched")
	else:
		play_animation("crouching_WG")
		# yield(get_tree().create_timer(0.2), "timeout")
		# play_animation("crouched_WG")


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
