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
			for area in hoveringOverAreaArray:
				if area.has_method("hit"):
					# print("			Click on target")
					area.hit()

