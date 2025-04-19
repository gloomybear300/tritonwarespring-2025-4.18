# GameState.gd
extends Node

var final_time := 0.0
var round_time := 0.0
var score := 0.0
var skin = "default"
var rope_skins = {
	"default": [Color.SADDLE_BROWN, Color.BLACK],
	"red_white": [Color.RED, Color.WHITE],
	"gold":[Color.PALE_GOLDENROD,Color.GOLD,Color.GOLDENROD,Color.DARK_GOLDENROD],
	"triton_gold": [Color.NAVY_BLUE, Color.GOLDENROD],
	"rainbow": [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE],
	"murica":[Color.RED,Color.WHITE,Color.BLUE],
	"camo":[Color.DARK_GREEN,Color.SADDLE_BROWN,Color.DARK_KHAKI],
	"party":[Color.WEB_PURPLE,Color.CORAL,Color.ORANGE_RED,Color.GOLDENROD]
}
var skin_unlock_scores = {
	"default":0,
	"red_white":1000,
	"gold":10000,
	"triton_gold":20000,
	"rainbow":2000,
	"murica":3000,
	"camo":5000,
	"party":7000
	}
var skin_keys = rope_skins.keys()
var skin_index = 0

func _process(delta):
	round_time += delta
	score = round_time * 100
