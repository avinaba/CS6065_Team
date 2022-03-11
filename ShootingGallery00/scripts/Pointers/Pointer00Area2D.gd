extends Area2D


# Called when the node enters the scene tree for the first time.
#func _ready():
#	connect("body_entered", self, "_on_pointer00HitArea_body_entered")
#	pass # Replace with function body.

#func _on_pointer00HitArea_body_entered(body):
#	print("Collision with some area")
#	# Check mouse is down
#	if Input.ismousebutton_pressed(BUTTON_LEFT): 
#		print("		Click on some area")
#		if body.has_method("hit"):
#			# Click with Area entered another area with a "hit()" method
#			print("			Click on target")
#			body.hit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




#func _on_Pointer00Area2D_area_entered(area):
#	print("Collision with some area")
#	# Check mouse is down
#	if Input.is_mouse_button_pressed(BUTTON_LEFT): 
#		print("		Click on some area")
#		if area.has_method("hit"):
#			# Click with Area entered another area with a "hit()" method
#			print("			Click on target")
#			area.hit()


func _input(event):
	if event is InputEventMouseButton:  
		# Emit particle on mouse left click release 
		if event.pressed == true and event.button_index == BUTTON_LEFT:
			# Check Pointer00HitArea2D overlaps with any other Area2D
			var hoveringOverAreaArray = get_overlapping_areas ( )
			# print("On click, overlaps found: " + str(hoveringOverAreaArray.size()))
			# Get main script's node to increment score
			var scriptNode = get_tree().get_root().get_node("00_Demo_level")
			var hasIncrement00 = false
			if scriptNode != null:
				hasIncrement00 = scriptNode.has_method("incrementPointer00Score") # Loop invariant
			
			for area in hoveringOverAreaArray:
				if area.has_method("hit"):
					# print("			Click on target")
					area.hit()
					# Increment score with a tiny guard clause
					if hasIncrement00:
						scriptNode.incrementPointer00Score()
