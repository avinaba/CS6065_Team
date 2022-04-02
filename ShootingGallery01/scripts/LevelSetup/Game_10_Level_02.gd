extends Node

var player1IsReady = false
var player1IsReadyText = "Waiting for player with gamepad to hit ready!"

var player2IsReady = false
var player2IsReadyText = "Waiting for player with mouse to hit ready!"

var bothPlayerReadyScriptDone = false

# For cleaner logs
var levelEnded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Check if level needs to start 
	if player1IsReady and player2IsReady and (bothPlayerReadyScriptDone == false):
		var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
		# print("in _on_HitToBegin_Button_pressed")
		if scriptNode == null: 
			# print("Could not find global logic!!")
			pass
		
		# Calling parent helper functions
		if scriptNode != null:
			# Enable scoring 
			if scriptNode.has_method("enableScoringForMouse"):
				scriptNode.enableScoringForMouse()
			
			if scriptNode.has_method("enableScoringForJoystick"):
				scriptNode.enableScoringForJoystick()
				
			# Enable hitting 
			if scriptNode.has_method("enableActiveTargets"):
				scriptNode.enableActiveTargets()
				
			# Hide the pre play sceen
			get_node("pre_play_screen").hide()
			
			
			var numberOfActiveTargets = []
			
			if scriptNode.has_method("getActiveTargetList"):
				numberOfActiveTargets = scriptNode.getActiveTargetList()
			
			var linearVelocity = 5 # Loop invariant
			var velocityVector = Vector2(linearVelocity, 0) # Loop invariant
			if numberOfActiveTargets.size() != 0:
				for bullseye_node in numberOfActiveTargets:
					# Enable Linear movement (downward)
					var randomAngleInDegree = 360*randf()
					if bullseye_node.has_method("setLinearVelocity") and bullseye_node.has_method("enableLinearVelocity") :
						bullseye_node.setLinearVelocity(velocityVector.rotated(deg2rad(randomAngleInDegree)))
						bullseye_node.enableLinearVelocity()
					
			
			bothPlayerReadyScriptDone = true
	
	# Check if level needs to end 
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
				
				# Hide custom mouse pointer
				if scriptNode.has_node("Pointer00Area2D"):
					scriptNode.get_node("Pointer00Area2D").hide()
				
				# Hide custom mouse pointer fire effect
				if scriptNode.has_node("pointer_00_on_mouse_down_particle2D"):
					scriptNode.get_node("pointer_00_on_mouse_down_particle2D").hide()
				
				# Disable scoring for Mouse 
				if scriptNode.has_method("disableScoringForMouse"):
					scriptNode.disableScoringForMouse()
				
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
	player2IsReady = true
	get_node("pre_play_screen/instruction_02").text = player2IsReadyText


func mouseFiredOnBeginButton():
	player1IsReady = true
	get_node("pre_play_screen/instruction_02").text = player1IsReadyText


func _on_Begin_Begin_Multiplayer_game_00_pressed():
	var scriptNode = get_tree().get_root().get_node("Global_logic_node")
	
	# print("in _on_Begin_Practice_Mouse_button_00_pressed")
	if scriptNode == null: 
		# print("Could not find global logic!!")
		pass
	
	# Calling parent helper functions
	if scriptNode != null:
		# Change global state to "Game 10 - Level 3"
		if (scriptNode.has_method("setGlobalState") and scriptNode.has_method("getStateIdFromName") ):
			var nextStateId =  scriptNode.getStateIdFromName("Game 10 - Level 3")
			# Change global state 
			if nextStateId != -1:
				scriptNode.setGlobalState(nextStateId)
