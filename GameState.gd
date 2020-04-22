extends Node


# Declare member variables here. Examples:
var secret = -1
var winState = false
var guess = -1
var hist_count = -1
var n_options = -1
var difficulty = -1


func _init(d=1,max_n=5):
	secret = int(rand_range(1,max_n+1))
	print("This is the secret " + str(secret))
	difficulty = d
	n_options = 16 - difficulty 
	hist_count = 0
	print("GameState Ready!")
	#self.connect("msg", self,"_message_label")

func try(val):
	hist_count += 1
	return win_check(val)
	
func hint(val):
	if(secret < val):
		if(val-secret < 10):
			return "little bit lower, try again!"
		else:
			return "too low, try again!"
	else:
		if(secret-val < 10):
			return "little bit higher, try again!"
		else:
			return "too high, try again!"		

func win_check(val):
	return val == secret

func lose_check():
	return hist_count > n_options
		
# Called when the node enters the scene tree for the first time.
func ready():
	pass # Replace with function body.

func _get_secret():
	return secret
	
func _set_levelCorrection(n):
	if((n>0 && difficulty<9) || (n<0 && difficulty>2)):
		difficulty = difficulty + n


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
