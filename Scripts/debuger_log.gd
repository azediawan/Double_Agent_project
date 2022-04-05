extends VBoxContainer

onready var label1 = get_node("Label")
onready var label2 = get_node("Label2")
onready var label3 = get_node("Label3")
onready var label4 = get_node("Label4")
onready var label5 = get_node("Label5")
onready var label6 = get_node("Label6")
onready var label7 = get_node("Label7")
onready var label8 = get_node("Label8")
onready var label9 = get_node("Label9")
onready var label10 = get_node("Label10")
onready var label11 = get_node("Label11")
onready var label12 = get_node("Label12")
onready var label13 = get_node("Label13")


func _ready():
	GlobalVariables.logger = self

	pass


func show_in_game(label_pos, argument, value):
	var no_nulls = true if label_pos != null and argument != null and value != null else false
	if no_nulls:
		label_pos.text = str(argument, value)
