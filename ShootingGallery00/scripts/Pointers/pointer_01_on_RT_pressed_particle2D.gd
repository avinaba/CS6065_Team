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
