extends StaticBody2D

const min_speed = -3.0
const max_speed = -10.0
const total_difficulty_time = 120.0  # Time in seconds to reach max speed

var speed = 0.0  # Will be set in _ready()

func _ready():
	# Get game time since start
	var game_time = GameState.round_time

	# Normalize the game time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)

	# Interpolate speed based on game time (ease-in optional)
	speed = lerp(min_speed, max_speed, progress * progress)  # ease-in

func _process(delta: float) -> void:
	position.x += speed
