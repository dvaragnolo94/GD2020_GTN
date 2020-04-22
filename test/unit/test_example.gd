extends "res://addons/gut/test.gd"

var GameState =  load("res://GameState.gd")
var gs = GameState.new()

func test_correct_answer():
	assert_true(gs.try(gs.secret), "Correct Number")

func test_wrong_answer():
	assert_false(gs.try(randi()%11+1), "Wrong Number")

func test_too_much_attemps():
	for i in range (0,10):
		gs.try(randi()%11+1)	
	assert_true(gs.lose_check(), "Too much attemps")
