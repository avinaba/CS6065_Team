extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	one_shot = true # Emit once
	
	
func _input(event):
	if event is InputEventJoypadButton:  
		# Emit particle on XBox RT or B press 
		if (event.pressed == true and 
			(event.button_index == JOY_R2 or 
			event.button_index ==  JOY_L2 or # Account for handed-ness 
			event.button_index == JOY_XBOX_B) # Account for Trigger vs. button press motor/mechanical input delay
			) :
			self.position = get_parent().get_node("Pointer01Area2D").position
			emitting = true
			lifetime = 0.06
			
	
	# Check for Keyboard event
	if event is InputEventKey and is_visible_in_tree():  
		
		# if space is pressed and released
		if event.scancode == KEY_SPACE and event.pressed == false: 
			# Keyboard debug for Joystick
			var keyboardDebug = false
			
			var scriptNode = get_tree().get_root().get_node("Global_logic_node")
			if scriptNode != null and scriptNode.has_method("isDebugJoyWithKeyboardActive"):
				keyboardDebug = scriptNode.isDebugJoyWithKeyboardActive()
				
				# if debug is on
				if keyboardDebug:
					# Emit particle on "spacebar" release
					self.position = get_parent().get_node("Pointer01Area2D").position
					emitting = true
					lifetime = 0.06
