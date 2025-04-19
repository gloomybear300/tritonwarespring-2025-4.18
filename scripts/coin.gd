extends Area2D

const min_speed = -3.0
const max_speed = -10.0
const total_difficulty_time = 120.0  # Time in seconds to reach max speed

var speed = 0.0  # Will be set in _ready()

var player: Object = null

func _ready():
	# Get game time since start
	var game_time = GameState.round_time

	# Normalize the game time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)

	# Interpolate speed based on game time (ease-in optional)
	speed = lerp(min_speed, max_speed, progress * progress)  # ease-in
	
	# Enable collision monitoring so we can use get_overlapping_areas()
	monitoring = true
	monitorable = true

func _process(_delta: float) -> void:
	position.x += speed
	for area in get_overlapping_areas():
		if area.is_in_group("player"):
			print("intersecting")
			_on_area_entered(area)  # Call manually
	if player:
		global_position = global_position.move_toward(player.global_position,140*_delta)


func _on_area_entered(area: Area2D) -> void:
	print("in")
	if area.is_in_group('player'):
		GameState.score += 100
		print("collect coin")
		queue_free();


func _on_p_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player=body

func _on_p_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player=null
