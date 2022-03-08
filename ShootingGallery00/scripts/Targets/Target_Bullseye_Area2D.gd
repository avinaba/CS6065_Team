extends Area2D

#signal hoverPointer00
#signal hoverPointer01
#
#signal hitPointer00
#signal hitPointer01

var isHit = false # Flag whether this target has been hit or not
export var stayInHitSeconds = 0.3 # Delay for feedback of successful target hit 
var elapsedInHitSeconds = 0 #Book-keeping var

var postHit = false # Flag, whether this target needs to be destroyed
export var stayInPostHitSeconds = 0.2 
var elapsedInPostHitSeconds = 0 

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Function that identifies hit-able Nodes
func hit():
	isHit = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not postHit:
		if not isHit:
			# Set animation state to default 
			$AnimatedSprite.animation = "default"
			# Listen for hit
		
		else: # On hit
			# Set animation state to iSHit
			$AnimatedSprite.animation = "isHit"
			
			# Accumulate delay
			elapsedInHitSeconds += delta
			# Check if elapsed time is enough transition to "postHit"
			if(elapsedInHitSeconds > stayInHitSeconds):
				postHit = true
				# Reset counter
				elapsedInHitSeconds = 0
	
	else: # Transitioned to postHit state 
		# Set animation state to postHit
		$AnimatedSprite.animation = "postHit"
		
		# Accumulate delay
		elapsedInPostHitSeconds += delta
		# Check if elapsed time is enough transition to "postHit"
		if(elapsedInPostHitSeconds > stayInPostHitSeconds):
			self.hide()
			# TODO: Destroy this node
			pass
		
