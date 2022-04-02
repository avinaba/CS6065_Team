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

var hasLinerVelocity = false
func getHasLinearVelocity():
	return hasLinerVelocity

func enableLinearVelocity():
	hasLinerVelocity = true
func disableLinearVelocity():
	hasLinerVelocity = false
	
var linearVelocity = Vector2(0.0, 0.0) 
 
func getLinearVelocity():
	return linearVelocity

func setLinearVelocity(input_velocity: Vector2):
	linearVelocity = input_velocity
	
var linearVelocityScaling = 20

var isVelocityRandomized = false 
func getIsVelocityRandomized():
	return isVelocityRandomized

func enableRandomizedVelocity():
	isVelocityRandomized = true

func disableRandomizedVelcity():
	isVelocityRandomized = false 

# Draw from a unifrom distribution of [ -0.5 to +0.5 ] * randomVelocityScale and add to current linearVelocity every changeVelocityDelta seconds
var randomVelocityScale = 20 
var changeVelocityDelta = 0.5 # seconds
var elapsedVelocityNotChangedTime = 0 # Bookkeeping

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Function that identifies hit-able Nodes
func hit():
	isHit = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if isVelocityRandomized: 
		elapsedVelocityNotChangedTime += delta # Keep time 
		
		# Change velocity at reglar intervals
		if elapsedVelocityNotChangedTime > changeVelocityDelta: 
			# Change speed 
			linearVelocity += ( randf() - 1 ) * randomVelocityScale * linearVelocity.normalized()
			
			# Change direction
			linearVelocity = linearVelocity.rotated(deg2rad(90 * randf()))
			elapsedVelocityNotChangedTime = 0
	
	# Move according to linear velocity
	if hasLinerVelocity:
		position += linearVelocity * delta * linearVelocityScaling
		
		var radius = $CollisionShape2D.shape.radius
		
		# Constrain to visible area lossless bounce
		if position.x - radius <= 0 or position.x + radius >= OS.get_screen_size().x:
			linearVelocity.x *= -1 # Reflect X direction
		
		if position.y - radius <= 0 or position.y + radius >= OS.get_screen_size().y:
			linearVelocity.y *= -1 # Reflect X direction
	# elif hasVariableVelocity: 
		# TODO: 
		
	
	
	if not postHit:
		if not isHit:
			# Set animation state to default 
			$AnimatedSprite.animation = "default"
			# Listen for hit
		
		else: # On hit
			# Remove all velocity, conversely could add downward acceleration 
			disableLinearVelocity()
			
			# Set animation state to iSHit
			$AnimatedSprite.animation = "isHit"
			
			# Disable further collision
			$CollisionShape2D.disabled = true  
			
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
		
