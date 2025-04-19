# GameState.gd
extends Node

var final_time := 0.0
var round_time := 0.0
var score := 0.0
var skin = "default"
var rope_skins = {
	"default": [Color.SADDLE_BROWN, Color.BLACK],
	"red_white": [Color.RED, Color.WHITE],
	"blue_gold": [Color.DODGER_BLUE, Color.GOLD],
	"rainbow": [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE],
	"forest": [Color.DARK_GREEN, Color.FOREST_GREEN],
	"sunset": [Color.ORANGE_RED, Color.GOLDENROD, Color.MEDIUM_PURPLE],
	"ice": [Color.LIGHT_CYAN, Color.ALICE_BLUE],
	"fire": [Color.DARK_RED, Color.ORANGE_RED, Color.GOLD],
	"candy": [Color.HOT_PINK, Color.LIGHT_PINK],
	"toxic": [Color.LIME, Color.DARK_GREEN],
	"space": [Color.BLACK, Color.DARK_VIOLET, Color.MIDNIGHT_BLUE],
	"lava": [Color.CRIMSON, Color.DARK_ORANGE, Color.MAROON],
	"desert": [Color.SANDY_BROWN, Color.KHAKI],
	"neon": [Color.FUCHSIA, Color.LIME],
	"storm": [Color.SLATE_GRAY, Color.LIGHT_SLATE_GRAY],
	"night": [Color.BLACK, Color.SLATE_GRAY],
	"golden": [Color.GOLD, Color.GOLD]
};
var skin_unlock_scores = {
	"default": 0,
	"red_white": 1000,
	"blue_gold": 2000,
	"rainbow": 3000,
	"forest": 4000,
	"sunset": 5000,
	"ice": 6000,
	"fire": 7000,
	"candy": 8000,
	"toxic": 9000,
	"space": 10000,
	"lava": 11000,
	"desert": 12000,
	"neon": 13000,
	"storm": 14000,
	"night": 15000,
	"golden": 50000,
}

var skin_keys = rope_skins.keys()
var skin_index = 0

func _process(delta):
	round_time += delta
	score = round_time * 100
