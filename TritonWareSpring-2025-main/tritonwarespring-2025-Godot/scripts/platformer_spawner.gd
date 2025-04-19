extends Node

@onready var point: Marker2D = $point
@onready var platform_scene = preload("res://scenes/platform.tscn")  # Regular platform
@onready var fragile_platform_scene = preload("res://scenes/fragile_platform.tscn")  # Fragile platform

@onready var coin_scene = preload("res://scenes/coin.tscn")

@onready var wait: float = 0.8
var timer: float = wait
var platformError = 200

# How long it takes to reach max fragility chance
const total_difficulty_time = 30.0
const min_fragile_chance = 0.1
const max_fragile_chance = 0.9

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		spawn()
		timer = wait * randf_range(0.5, 1.2)

func spawn():
	var game_time = GameState.round_time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)
	var fragile_chance = lerp(min_fragile_chance, max_fragile_chance, progress * progress)
	print(fragile_chance)

	var platform = null
	if randf() < fragile_chance:
		platform = fragile_platform_scene.instantiate()
		print("Spawning fragile platform")
	else:
		platform = platform_scene.instantiate()
		print("Spawning regular platform")

	# Set platform position
	platform.global_position = point.global_position
	platform.global_position.y += randf_range(-platformError, platformError)

	# Add platform to the scene
	$/root/Game.add_child(platform)

	# --- Spawn 0-3 coins above the platform ---
	var coin_count = randi() % 4  # Random between 0 and 3 inclusive
	var spacing = 40.0  # Space between coins horizontally

	for i in range(coin_count):
		var coin = coin_scene.instantiate()

		# Position coins above the platform
		var offset_x = (i - (coin_count - 1) / 2.0) * spacing  # Center coins
		coin.global_position = platform.global_position + Vector2(offset_x, -60)  # 40px above platform

		$/root/Game.add_child(coin)
