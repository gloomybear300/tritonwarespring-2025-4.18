extends Control

@export var main_menu_scene : PackedScene
@export var game_scene : PackedScene

@onready var name_input: LineEdit = $CanvasLayer/VBoxContainer2/LineEdit
@onready var submit_button: Button = $CanvasLayer/VBoxContainer2/Button

var player_score: int = 0
var has_submitted: bool = false  # 🆕 Track if the player has submitted

func _ready():
	show_game_over(GameState.final_time)
	name_input.grab_focus()
	submit_button.pressed.connect(_on_submit_button_pressed)

func show_game_over(score: float):
	$CanvasLayer/ScoreLabel.text = "Score: %.2f" % GameState.score
	self.visible = true

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_main_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_submit_button_pressed() -> void:
	if has_submitted:
		print("Already submitted!")
		return

	var player_name = name_input.text.strip_edges()
	if player_name.is_empty():
		print("Please enter your name!")
		return

	save_score_to_leaderboard(player_name, GameState.score)
	show_leaderboard()
	has_submitted = true  # 🆕 Mark as submitted
	submit_button.disabled = true  # 🆕 Disable button so it can't be clicked again

func save_score_to_leaderboard(name: String, score: int):
	ScoreManager.add_score(name, score)

func show_leaderboard():
	print("Transitioning to leaderboard screen...")
