extends Node2D
onready var playerSprite = get_parent().get_node("Player_sprite")
onready var collisionArea = get_parent().get_node("CollisionArea")
onready var foot = get_parent().get_node("foot_raycast")
onready var state_machine = get_parent().get_node("StateM_handler")
onready var void_space = get_parent().get_node("landing_space")
onready var main_node = get_parent().get_node(".")

var is_jumping = false
var is_falling = false
var is_landing = false
var cur_animation = "none"
var is_climbing = false
var is_crouched = false


func _process(_delta):
	$AnimationPlayer.playback_speed = 1


func play_animation(animation):
	if cur_animation != animation:
		$AnimationPlayer.play(animation)
		cur_animation = animation


func anim_dir():
	if Input.is_action_pressed("ui_left"):
		playerSprite.flip_h = true
		collisionArea.scale.x *= -1
	if Input.is_action_pressed("ui_right"):
		playerSprite.flip_h = false
		collisionArea.scale.x *= -1


func idle_animation():
	is_crouched = Input.is_action_pressed("ui_down")
	var is_iddle = GlobalVariables.keyboard_vector > 0 or GlobalVariables.keyboard_vector < 0 and !Input.is_action_pressed("ui_up")
	if is_iddle and !is_crouched and foot.is_colliding() and !is_landing:
		play_animation("idle")
		$AnimationPlayer.playback_speed = 0.4


func crouched_animation():
	play_animation("crouched")


func walking_animation():
	anim_dir()
	if !is_landing and foot.is_colliding() and GlobalVariables.move_and_slide.x != 0:
		play_animation("Move")


func jump_animation():
	play_animation("jump")
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
		play_animation("falling")
		return true


func can_land():
	if !void_space.is_colliding() and is_jumping:
		return false
	if void_space.is_colliding() and !is_jumping:
		play_animation("landing")
		is_falling = false
		is_landing = true
		yield(get_tree().create_timer(0.22), "timeout")
		is_landing = false
		return true
