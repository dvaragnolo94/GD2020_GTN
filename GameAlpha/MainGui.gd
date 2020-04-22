extends VBoxContainer
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
		$Game/Label/TextEdit.visible = false
		$Game/Button.visible = false
		emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves")
	else:
		if(gs.lose_check()):
			$Game/Label/TextEdit.visible = false
			$Game/Button.visible = false
			emit_signal("msg","Sorry man, you've lost :( \n The number was " + str(gs.secret))
			
		else:
			emit_signal("msg",gs.hint(val))

func _message_label(arg):
	$Game/Label.text = str(arg)
	 
	
func _on_Play_pressed():
	gs = GameState.new($Menu/Difficulty/HSlider.value)
	$Menu.visible = false
	$Game.visible = true
	


func _on_Button_pressed():
	_main(int($Game/Label/TextEdit.text))



func _on_HSlider_value_changed(value):
		$Menu/Difficulty/LevelDiff.text = str($Menu/Difficulty/HSlider.value)
