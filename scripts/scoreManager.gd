extends Node

const SAVE_PATH := "user://leaderboard.save"
const MAX_ENTRIES := 10

var leaderboard: Array = []

func _ready():
	load_leaderboard()
func clear_leaderboard():
	leaderboard.clear()  # Clear the array
	save_leaderboard()   # Save the empty leaderboard to file

func add_score(name: String, score: int):
	leaderboard.append({"name": name, "score": score})
	leaderboard.sort_custom(func(a, b): return a["score"] > b["score"])
	if leaderboard.size() > MAX_ENTRIES:
		leaderboard.resize(MAX_ENTRIES)
	save_leaderboard()

func save_leaderboard():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(leaderboard)
		file.close()

func load_leaderboard():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			leaderboard = file.get_var()
			file.close()

func get_highest_score() -> int:
	var best_score = 0
	for entry in ScoreManager.leaderboard:
		best_score = max(best_score, entry["score"])
	return best_score
