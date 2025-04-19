extends Node2D  # Or Node2D depending on your scene
@onready var black_box: Sprite2D = $blackBox

var round_time := 0.0
var round_active := false
@onready var player: CharacterBody2D = $player

#Add Rope to Scene
var Rope = preload("res://scenes/rope.tscn")
@onready var ropeStart = Vector2(get_viewport_rect().size.x / 2,0)
var ropeEnd= Vector2.ZERO


func _ready():
	initialize_Rope()
	$VignetteRect.z_index=12


func _on_temporary_platform_game_start() -> void:
	start_round()
	print("gamestart")
	pass # Replace with function body.
	
func initialize_Rope():
	ropeEnd= player.position
	var rope = Rope.instantiate()
	add_child(rope)
	rope.spawnRope(ropeStart,ropeEnd)
	
func _process(delta):
	#if round_active:
	$ScoreLabel.text = "Score: %.2f" % GameState.score
		#round_time += delta
		#print("Time: ", round_time)  # For debugging
	round_time = GameState.round_time
	#Dim Screen
	black_box.modulate.a=player.calculateBreathRatio()
	#print("Player breath ratio:", player.calculateBreathRatio())
	$VignetteRect.material.set_shader_parameter("intensity", player.calculateBreathRatio())
	if Input.is_action_just_pressed("game_over"):
		game_over()

func start_round():
	GameState.round_time = 0.0
	round_active = true
	$VignetteRect.visible = true;
	$ScoreLabel.visible = true
	print("Round started!")

func game_over():
	round_active = false
	GameState.final_time = round_time
	get_tree().change_scene_to_file("res://scenes/gameOver.tscn")
