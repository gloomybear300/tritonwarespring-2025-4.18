extends StaticBody2D


var speed = 0.0 
var xvel=0

const fall_delay = 0.3  # Time in seconds before the platform starts falling
var is_broken = false  # To track if the platform has already broken
var gravity = 20  # Custom gravity for falling platforms
var falling_speed = 0  # Speed at which the platform falls
var fall_timer = 0.0  # Timer to handle the fall delay


@onready var ray_cast: RayCast2D = $RayCast2D  # Reference the RayCast2D node
@onready var area: Area2D = $Area2D  # Reference the Area2D node for detection
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # Reference the platform's collision shape



func _process(delta: float) -> void:
	var prevPos=position.x
	position.x += speed
	xvel=(position.x-prevPos)/delta
	
	# If the platform is broken, start applying gravity to make it fall
	if is_broken:
		if fall_timer > 0:
			# Count down the timer before the platform starts falling
			fall_timer -= delta
		else:
			apply_falling()  # Apply falling logic after the delay


# This function will make the platform fall and disappear
func broken():
	is_broken = true
	# Remove the platform's collision shape to allow it to fall through
	collision_shape.disabled = true
	fall_timer = fall_delay
	# Optionally, make the platform disappear after some time if desired
	# queue_free()  # Uncomment this line if you want the platform to disappear after breaking


# Apply falling logic to the platform (gravity or custom falling)
func apply_falling():
	falling_speed += gravity * get_process_delta_time()  # Apply gravity to the falling speed
	position.y += falling_speed  # Move the platform down by the falling speed
	
func get_speed():
	return xvel

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		broken()  # Make the platform fall when the player touches it
