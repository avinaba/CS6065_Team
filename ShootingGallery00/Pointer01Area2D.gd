extends Area2D


func _input(event):
	if event is InputEventJoypadButton:  
		# Emit particle on XBox RT or B press 
		if (event.pressed == true and 
			(event.button_index == JOY_R2 or 
			event.button_index ==  JOY_L2 or # Account for handed-ness 
			event.button_index == JOY_XBOX_B) # Account for Trigger vs. button press motor/mechanical input delay
			) :
			# Check Pointer01HitArea2D overlaps with any other Area2D
			var hoveringOverAreaArray = get_overlapping_areas ( )
			# print("On click, overlaps found: " + str(hoveringOverAreaArray.size()))
			# Get main script's node to increment score
			var scriptNode = get_tree().get_root().get_node("00_Demo_level")
			var hasIncrement01 = false
			if scriptNode != null:
				hasIncrement01 = scriptNode.has_method("incrementPointer01Score") # Loop invariant
				
			for area in hoveringOverAreaArray:
				if area.has_method("hit"):
					# print("			Click on target")
					area.hit()
					# Increment score with a tiny guard clause
					if hasIncrement01:
						scriptNode.incrementPointer01Score()

