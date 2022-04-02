extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Control vars
var isPlayer1IdDirty = false
var isPlayer2IdDirty = false 
var isSequenceSelected = false

var isJoystickConnected = false
var bulletDisconnectedColour = Color("#66392d35")
var bulletConnectedColour = Color("#9BB46D")

# Called when the node enters the scene tree for the first time.
func _ready():
	# var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# Add options to sequence selector
	get_node("Select_seq_dropdown").add_item("Select sequence", -1)
	get_node("Select_seq_dropdown").add_item("Sequence 1", 1)
	get_node("Select_seq_dropdown").add_item("Sequence 2", 2)
	get_node("Select_seq_dropdown").add_item("Sequence 3", 3)
	get_node("Select_seq_dropdown").add_item("Sequence 4", 4)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# Calling parent helper function
	if scriptNode != null:
		if scriptNode.has_method("checkXboXJoystickConnectionStatus"):
			isJoystickConnected = scriptNode.checkXboXJoystickConnectionStatus()
	
	# Show state of joystick connection 
	if isJoystickConnected == false:
		get_node("Gamepad_connection_bullet").set_frame_color(bulletDisconnectedColour)
		get_node("Gamepad_connection_status").text = "Disconnected"
	
	if isJoystickConnected == true:
		get_node("Gamepad_connection_bullet").set_frame_color(bulletConnectedColour)
		get_node("Gamepad_connection_status").text = "Connected"
		
	# Manage state for player Id input 
	if get_node("Player_1_ID_input").text == "": 
		isPlayer1IdDirty = false
	else:
		isPlayer1IdDirty = true
		
	if get_node("Player_2_ID_input").text == "": 
		isPlayer2IdDirty = false
	else:
		isPlayer2IdDirty = true
	
	# Manage state for dropdown input 
	if get_node("Select_seq_dropdown").get_selected_id() == 0:
		isSequenceSelected = false
	else:
		isSequenceSelected = true
	
	if (isJoystickConnected and
	isPlayer1IdDirty and
	isPlayer2IdDirty and 
	isSequenceSelected): 
		get_node("Begin_Practice_Mouse_button_00").disabled = false
	else: 
		get_node("Begin_Practice_Mouse_button_00").disabled = true


func _on_Begin_Practice_Mouse_button_00_pressed():
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# print("in _on_Begin_Practice_Mouse_button_00_pressed")
	if scriptNode == null: 
		# print("Could not find global logic!!")
		pass
	
	# Calling parent helper functions
	if scriptNode != null:
		
		# Set player 1 ID
		if scriptNode.has_method("setPlayer1Id"):
			scriptNode.setPlayer1Id(get_node("Player_1_ID_input").text)
			
		# Set player 2 ID
		if scriptNode.has_method("setPlayer2Id"):
			scriptNode.setPlayer2Id(get_node("Player_2_ID_input").text)
		
		# Log player ids
		if scriptNode.has_method("logPlayerIds"):
			scriptNode.logPlayerIds()
		
		# Set sequence number 
		if scriptNode.has_method("setSequenceNumber"):
			scriptNode.setSequenceNumber(get_node("Select_seq_dropdown").get_selected_id())
		
		# initialise sequence configuration
		if scriptNode.has_method("initConditionConfigArray"):
			scriptNode.initConditionConfigArray()
		
		# Log Condition sequence
		if scriptNode.has_method("logConditionConfigArray"):
			scriptNode.logConditionConfigArray()
			
		# Change global state to "Mosue Practice for Player 1"
		if (scriptNode.has_method("setGlobalState") and scriptNode.has_method("getStateIdFromName") ):
			var nextStateId =  scriptNode.getStateIdFromName("Mouse Practice P1")
			# Change global state 
			if nextStateId != -1:
				scriptNode.setGlobalState(nextStateId)
