extends Node2D

onready var anims_handle = get_parent().get_node("Anims_handle")
onready var moviment_handle = get_parent().get_node("movement_handle")
var player_state := 3
onready var label = get_parent().get_node("Label")
enum { Walking, Jumping, Falling, Idle, Crouching, Landing, Climbing }
var states = []


func change_player_state(value):
	if value == "walk":
		player_state = 0
	elif value == "jump":
		player_state = 1
	elif value == "fall":
		player_state = 2
	elif value == "crouch":
		player_state = 4
	elif value == "landing":
		player_state = 5
	elif value == "climb":
		player_state = 6
	else:
		player_state = 3
	label.text = value


# test values
func _process(_delta):
	# print(states[0])

	match player_state:
		Walking:
			anims_handle.walking_animation()
			pass
		Jumping:
			# anims_handle.jump_animation()
			anims_handle.jump_animation()

			pass
		Falling:
			# anims_handle.falling_animation()
			anims_handle.on_air_animations()
			pass
		Idle:
			anims_handle.idle_animation()

			pass
		Crouching:
			anims_handle.crouched_animation()

			pass
		Landing:
			# anims_handle.landing_animation()
			anims_handle.on_air_animations()

			pass
		Climbing:
			pass
