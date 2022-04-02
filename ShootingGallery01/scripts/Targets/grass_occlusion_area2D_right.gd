extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TRANSPARENT_OPACITY = 0.4
var DEFAULT_OPACITY = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "_on_grass_area_entered")
	connect("area_exited", self, "_on_grass_area_exited")

func _on_grass_area_entered(area):
	# print("Collision with some area")
	if area.has_method("hit"):
		# Entered an Area entered another area with a "hit()" method
		# print("	Mouse entered a target's area")
		# Change opacity of grasses on bot-left
		get_parent().get_node("grass_bot_right").modulate.a  = TRANSPARENT_OPACITY
		get_parent().get_node("grass_bot_right_shadow").modulate.a  = TRANSPARENT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01Avatar").modulate.a  = TRANSPARENT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01Score").modulate.a  = TRANSPARENT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01ScoreAreaBg").modulate.a  = TRANSPARENT_OPACITY
		
func _on_grass_area_exited(area):
	# print("Collision with some area")
	var noHiddenBullseye = true
	var hoveringOverAreaArray = get_overlapping_areas ( )
	# If there's no overlap restore opactiy
	if hoveringOverAreaArray.size() == 0: 
		get_parent().get_node("grass_bot_right").modulate.a  = DEFAULT_OPACITY
		get_parent().get_node("grass_bot_right_shadow").modulate.a  = DEFAULT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01Avatar").modulate.a  = DEFAULT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01Score").modulate.a  = DEFAULT_OPACITY
		get_parent().get_parent().get_node("ScoreUI/Pointer01ScoreAreaBg").modulate.a  = DEFAULT_OPACITY
	
	else:
		# Check if any of the overlapping areas are bulseyes
		for area in hoveringOverAreaArray:		
			if area.has_method("hit"):
				noHiddenBullseye = false
				break
		
		# Change opacity of grasses on bot-left back to normal
		if noHiddenBullseye:
			get_parent().get_node("grass_bot_right").modulate.a  = DEFAULT_OPACITY
			get_parent().get_node("grass_bot_right_shadow").modulate.a  = DEFAULT_OPACITY
			get_parent().get_parent().get_node("ScoreUI/Pointer01Avatar").modulate.a  = DEFAULT_OPACITY
			get_parent().get_parent().get_node("ScoreUI/Pointer01Score").modulate.a  = DEFAULT_OPACITY
			get_parent().get_parent().get_node("ScoreUI/Pointer01ScoreAreaBg").modulate.a  = DEFAULT_OPACITY
