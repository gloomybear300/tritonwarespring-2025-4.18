extends Node

@onready var point: Marker2D = $point
@onready var platform_scene = preload("res://scenes/platform.tscn")  # Regular platform
@onready var fragile_platform_scene = preload("res://scenes/fragile_platform.tscn")  # Fragile platform
@onready var bouncy_platform_scene = preload("res://scenes/bouncy_platform.tscn")
@onready var wall_platform_scene = preload("res://scenes/wall_platform.tscn")
@onready var coin_scene = preload("res://scenes/coin.tscn")

var rng = RandomNumberGenerator.new()


var platformDict= {}
var platformProbDict={}
var averageDistBetweenPlatforms=300
var wait:float = 0
var timer: float = 0
var platformError = 225
var platform:Object = null
var coin:Object = null
#Platform Speed
const min_speed = -2.5
const max_speed = -8.0
const total_difficulty_time = 180 # Time in seconds to reach max speed
var speed = min_speed  # Will be set in _ready()

# How long it takes to reach max fragility chance
const min_fragile_chance = 10
const max_fragile_chance = 70

var default_chance=70
var fragile_chance=min_fragile_chance
var bouncy_chance=20
var wall_chance = 10

func _ready() -> void:
	rng.randomize()
	platformDict={
		"default":platform_scene,
		"fragile":fragile_platform_scene,
		"bouncy":bouncy_platform_scene,
		"wall":wall_platform_scene,
		#"seesaw":seesaw_scene,
	}
	platformProbDict = {
		"default":default_chance,
		"fragile":fragile_chance,
		"bouncy":bouncy_chance,
		"wall":wall_chance,
		#"seesaw":10
	}

func _process(delta: float) -> void:
	timer -= delta
	var game_time = GameState.round_time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)
	wait=1.4
	if timer <= 0:
		
		
		spawn()
		spawn_coins()
		timer = wait * randf_range(0.8, 1.6)
		
func spawn_coins():
	var game_time = GameState.round_time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)
	speed = lerp(min_speed, max_speed, progress * progress)  # ease-incoi
	
	var y = randf_range(-platformError, platformError)
	
	for i in range(randf_range(0,4)):
		coin = coin_scene.instantiate()
		coin.global_position = point.global_position
		coin.global_position.x += i * 40
		
		coin.global_position.y  += y
		coin.speed = speed 
		
		$/root/Game.add_child(coin)
	
	
func spawn():
	var game_time = GameState.round_time
	var progress = clamp(game_time / total_difficulty_time, 0.0, 1.0)
	fragile_chance = lerp(min_fragile_chance, max_fragile_chance, progress * progress)  # Ease-in if you want
	speed = lerp(min_speed, max_speed, progress * progress)  # ease-in
	platform = platformDict[pick_weighted_choice(platformDict,platformProbDict)].instantiate()
	platform.global_position = point.global_position
	platform.global_position.y += randf_range(-platformError, platformError)
	platform.speed=speed
	$/root/Game.add_child(platform)
	
	# Pick a weighted random choice
func pick_weighted_choice(dict: Dictionary, weights: Dictionary) -> String:
	var keys = dict.keys()
	var total_weight = 0.0
	var cumulative = []

	for key in keys:
		total_weight += weights.get(key, 0)
		cumulative.append(total_weight)

	var pick = randf() * total_weight
	for i in cumulative.size():
		if pick < cumulative[i]:
			return keys[i]
	return keys[0]  # fallback
