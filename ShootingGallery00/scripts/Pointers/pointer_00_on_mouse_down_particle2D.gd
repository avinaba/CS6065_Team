extends CPUParticles2D

# Hacky solution,
# Change with ref: https://www.reddit.com/r/godot/comments/881rhn/i_want_to_emit_a_spray_of_particles_every_time_a/

# Called when the node enters the scene tree for the first time.
func _ready():
	one_shot = true # Emit once


func _input(event):
	if event is InputEventMouseButton:  
		# Emit particle on mouse left click release 
		if event.pressed == true and event.button_index == BUTTON_LEFT:
			# self.position = event.position
			self.position = get_parent().get_node("Pointer00Area2D").position
			emitting = true
			lifetime = 0.06

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
