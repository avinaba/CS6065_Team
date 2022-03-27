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
			
			# Flag to check whatever has been hit is a bulsseye 
			var isBullseyeHit = false
			
			# Get main script's node to increment score
			var scriptNode = get_tree().get_root().get_node("00_Demo_level")
			var hasIncrement00 = false
			var hasDecrement00 = false
			var hasGetElapsedTime = false 
			if scriptNode != null:
				hasIncrement00 = scriptNode.has_method("incrementPointer00Score") # Loop invariant
				hasDecrement00 = scriptNode.has_method("decrementPointer00Score") # Loop invariant
				hasGetElapsedTime = scriptNode.has_method("getElapsedTime") # Loop invariant

			
			# Note: Change the logic here to disable multiple bullseye breaks with one shot
			for area in hoveringOverAreaArray:
				if area.has_method("hit"):
					# print("			Click on target")
					area.hit()
					isBullseyeHit = true
					# Increment score with a tiny guard clause
					if hasIncrement00:
						scriptNode.incrementPointer00Score()
			
			# Note: Right now the cursror can either overlap with a bullseye or another cursor 
			if isBullseyeHit == false:
				if hasDecrement00: 
					scriptNode.decrementPointer00Score()
				# Log fire event with miss 
				if hasGetElapsedTime:
					print("[" + str(scriptNode.getElapsedTime()) + "][FIRE] Mouse fired at: (" + str(self.position.x) + ", " + str(self.position.y) + "), bullseye hit: FALSE")
			
			else:
				if hasGetElapsedTime:
					print("[" + str(scriptNode.getElapsedTime()) + "][FIRE] Mouse fired at: (" + str(self.position.x) + ", " + str(self.position.y) + "), bullseye hit: TRUE")
