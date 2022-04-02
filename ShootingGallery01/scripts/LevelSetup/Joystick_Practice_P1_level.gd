extends Node

# For cleaner logs
var levelEnded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var numberOfActiveTargets = []
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# print("in _on_HitToBegin_Button_pressed")
	if scriptNode == null: 
		# print("Could not find global logic!!")
		pass
	
	# Calling parent helper functions
	if scriptNode != null:
		
		if scriptNode.has_method("getActiveTargetList"):
			numberOfActiveTargets = scriptNode.getActiveTargetList()
			
			if numberOfActiveTargets.size() == 0 and levelEnded == false:
				
				# Show OS mouse cursor 
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
				# Hide custom joystick pointer
				if scriptNode.has_node("Pointer01Area2D"):
					scriptNode.get_node("Pointer01Area2D").hide()
				
				# Hide custom joystick pointer fire effect
				if scriptNode.has_node("pointer_01_on_RT_particle2D"):
					scriptNode.get_node("pointer_01_on_RT_particle2D").hide()
				
				# Disable scoring for Joystick 
				if scriptNode.has_method("disableScoringForJoystick"):
					scriptNode.disableScoringForJoystick()
				
				# Log Score 
				if scriptNode.has_method("logScore"):
					scriptNode.logScore()
				
				# Log Hit-Ratio
				if scriptNode.has_method("logHitRatio"):
					scriptNode.logHitRatio() 
				
				# Show the post play screen 
				get_node("post_play_screen").show()
				
				levelEnded = true

func joystickFiredOnBeginButton():
	# print("				Joystick button hit!!!")
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# print("in _on_HitToBegin_Button_pressed")
	if scriptNode == null: 
		# print("Could not find global logic!!")
		pass
	
	# Calling parent helper functions
	if scriptNode != null:
		# Enable scoring 
		if scriptNode.has_method("enableScoringForJoystick"):
			scriptNode.enableScoringForJoystick()
			
		# Enable hitting 
		if scriptNode.has_method("enableActiveTargets"):
			scriptNode.enableActiveTargets()
			
		# Hide the pre play sceen
		get_node("pre_play_screen").hide()
	


func _on_Begin_Begin_Multiplayer_game_00_pressed():
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# print("in _on_Begin_Practice_Mouse_button_00_pressed")
	if scriptNode == null: 
		# print("Could not find global logic!!")
		pass
	
	# Calling parent helper functions
	if scriptNode != null:
		# Change global state to "First multiplayer game post swapping"
		if (scriptNode.has_method("setGlobalState") and scriptNode.has_method("getStateIdFromName") ):
			var nextStateId =  scriptNode.getStateIdFromName("Game 6 - Level 1")
			# Change global state 
			if nextStateId != -1:
				scriptNode.setGlobalState(nextStateId)
