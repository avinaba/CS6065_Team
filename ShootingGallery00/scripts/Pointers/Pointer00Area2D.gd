extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "_on_Pointer00Area2D_area_entered")
	connect("area_exited", self, "_on_Pointer00Area2D_area_exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Pointer00Area2D_area_entered(area):
	# print("Collision with some area")
	if area.has_method("hit"):
		# Entered an Area entered another area with a "hit()" method
		# print("	Mouse entered a target's area")
		var scriptNode = get_tree().get_root().get_node("00_Demo_level")
		if scriptNode != null and scriptNode.has_method("setDampMouse"):
			scriptNode.setDampMouse()
		
		
func _on_Pointer00Area2D_area_exited(area):
	# print("Collision with some area")
	if area.has_method("hit"):
		# Exited an Area entered another area with a "hit()" method
		# print("	Mouse exited a target's area")
		var scriptNode = get_tree().get_root().get_node("00_Demo_level")
		if scriptNode != null and scriptNode.has_method("unsetDampMouse"):
			scriptNode.unsetDampMouse()



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
