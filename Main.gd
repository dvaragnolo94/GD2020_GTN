extends Node


# Declare member variables here. Examples:
var GameState =  load("res://GameState.gd")
var gs


signal msg(arg)
#signal try(val)
# Called when the node enters the scene tree for the first time.
func _ready():	
	print("Main Ready!")
	self.connect("msg", self,"_message_label")
	pass # Replace with function body.

func _main(val):
	
	if(gs.try(val)):
		$TextEdit.visible = !$TextEdit.visible
		$Button.visible = !$Button.visible
		emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves")
	else:
		if(gs.lose_check()):
			$TextEdit.visible = !$TextEdit.visible
			$Button.visible = !$Button.visible
			emit_signal("msg","Sorry man, you've lost :( \n The number was " + str(gs.secret))
			
		else:
			emit_signal("msg",gs.hint(val))




func _message_label(arg):
	$Label.text = str(arg)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	_main(int($TextEdit.text))
	pass 


func _on_Play_pressed():
	gs = GameState.new($Start/HSlider.value)
	$Start.visible = !$Start.visible
	pass # Replace with function body.


func _on_HSlider_changed():

	print(gs.difficulty)
	pass # Replace with function body.
