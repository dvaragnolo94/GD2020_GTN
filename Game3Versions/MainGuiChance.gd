extends VBoxContainer
var GameState =  load("res://GameState.gd")
var gs
# Different lore, based on Chance
var lore = ["Good Morning Sir!\n Let me introduce myself: i'm Hon Salo, the second commander of this spaceship.\n I'm here to explain the plan: we have to go to the planet Caruscont,\n and rescue our spy CC-9 from the enemies. Right now we have to prepare the spaceship\n and set the correct amount of fuel","We are arrived! now we have only to enter in that prison,\n open that door and... Oh F**k! the door is locked with a code:\n we have to find the combination!","The enemies are behind us!\n We have to change our path, find a new path to home with new coordinates!","It's done!\n thank you sir for your help, see you in the next mission!'"]
var loreUnlucky = ["Good Morning Sir!\n Let me introduce myself: i'm Hon Salo, the second commander of this spaceship.\n I'm here to explain the plan: we have to go to the planet Caruscont,\n and rescue our spy CC-9 from the enemies. Right now we have to prepare the spaceship\n and set the correct amount of fuel, but this is a new model:\n pay more attention than normal!","We are arrived! now we have only to enter in that prison,\n open that door and... Oh F**k! the door is locked with a code:\n we have to find the combination! Unlucky, this is a new model, very hard to unlock!","There are a lot of enemies are behind us!\n We have to change our path, find a new path to home with new coordinates, very fast!!!","It's done!\n thank you sir for your help, see you in the next mission!'"]
var loreLucky = ["Good Morning Sir!\n Let me introduce myself: i'm Hon Salo, the second commander of this spaceship.\n I'm here to explain the plan: we have to go to the planet Caruscont,\n and rescue our spy CC-9 from the enemies. Right now we have to prepare the spaceship\n and set the correct amount of fuel.\n Here there are some instruction, maybe could help ","We are arrived! now we have only to enter in that prison,\n open that door and... Oh F**k! the door is locked with a code:\n we have to find the combination! Luckly is an old model, easy to unlock","Only one spaceship saw us!\n We have to change our path, find a new path to home\n with new coordinates!","It's done!\n thank you sir for your help, see you in the next mission!'"]

# Result of roll d6 Chance
var loreChance = 4

var loreStep = 0
var blasterUsed = false
signal msg(arg)

# Called when the node enters the scene tree for the first time.
func _ready():	
	print("Main Ready!")
	self.connect("msg", self,"_message_label")
	pass # Replace with function body.

func _main(val):	
	if(gs.try(val)):
		$Game/Continue.visible = true
		$Tutorial/Back.visible = true
		$Game/Grid.visible = false
		if(gs.hist_count<4):
			$Game/HBoxContainer/BlasterItem.visible=true
			emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves and now you have Blaster (1 use, drop half grid)!")
		else:
			emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves")
	else:
		if(gs.lose_check()):
			$Game/Continue.visible = false
			$Game/Grid.visible = false
			emit_signal("msg","Sorry man, you've lost :( \n The number was " + str(gs.secret))
		else:
			emit_signal("msg",gs.hint(val))

func _message_label(arg):
	$Game/Label.text = str(arg)
	$Tutorial/Label.text = str(arg)
		
func _on_Play_pressed():
	$Lore.visible = false
	$Menu.visible = false
	$Game.visible = true
	$Tutorial.visible = false
	loreStep = loreStep + 1	
	delete_children($Game/Grid)
	$Game/Label.text = "Try a number from 1 to 100"
	
	# Calculus of the size of the Grid based on the roll of d6
	if(loreChance>5):
		print("Lucky")
		gs = GameState.new($Menu/Difficulty/HSlider.value,loreStep*20+20)
		_create_grid($Game/Grid,loreStep*20+20)
	elif(loreChance<2):
		print("Unlucky")
		gs = GameState.new($Menu/Difficulty/HSlider.value,loreStep*20+60)
		_create_grid($Game/Grid,loreStep*20+60)
	else:
		print("Normal")
		gs = GameState.new($Menu/Difficulty/HSlider.value,loreStep*20+40)
		_create_grid($Game/Grid,loreStep*20+40)
	
	$Game/Continue.visible = false
	$Game/Grid.visible = true
	
func _create_grid(grid,num):
	for j in range(0,num/10):
		var node = HBoxContainer.new()
		node.name = "SubGrid" + str(j)
		node.alignment = ALIGN_CENTER
		grid.add_child(node)
		for i in range(10*j,10*(j+1)):	
			var b = Button.new()
			b.text = str(i+1)
			b.name = "btn"+ b.text + "Grid"
			b.connect("pressed",self,"_on_Button_pressed",[b])
			node.add_child(b)

func _on_HSlider_value_changed(value):
		$Menu/Difficulty/LevelDiff.text = str($Menu/Difficulty/HSlider.value)

func _on_Button_pressed(target):
	#target.visible = false
	_main(int(target.text))
	var guessvalue = int(target.text)
	var secretvalue = gs._get_secret()
	for m in $Game/Grid.get_children():
		for n in m.get_children():
			var lookedvalue = int(n.text)
			if((guessvalue>secretvalue && lookedvalue>=guessvalue) || (guessvalue<secretvalue && lookedvalue<=guessvalue) && n.text != "X"):
				n.text = "X"
				n.add_color_override("font_color", Color(255,0,0,1))

func _on_Start_pressed():
	$Menu.visible = false
	$Game.visible = false
	$Lore.visible = true
	$Tutorial.visible = false
	
	loreChance = int(rand_range(1,6))
	#loreChance = 6
	print("Chance result is " + str(loreChance))
	if(loreChance>5):
		$Lore/LoreLabel.text = loreLucky[loreStep]
	elif(loreChance<2):
		$Lore/LoreLabel.text = loreUnlucky[loreStep]
	else:
		$Lore/LoreLabel.text = lore[loreStep]		
	
	if (loreStep==lore.size()-1): $Lore/Play.visible = false

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_Tutorial_pressed():
	$Menu.visible = false
	$Game.visible = false
	$Lore.visible = false
	$Tutorial.visible = true	
	gs = GameState.new($Menu/Difficulty/HSlider.value,5)
	_create_grid($Tutorial/TutorialGrid,10)

func _on_Back_pressed():
	delete_children($Tutorial/TutorialGrid)
	$Menu.visible = true
	$Game.visible = false
	$Lore.visible = false
	$Tutorial.visible = false	

func _on_BlasterItem_button_down():
	var centerNumber = (loreStep*20+40)/2
	var secretvalue = gs._get_secret()
	for m in $Game/Grid.get_children():
		for n in m.get_children():
			var lookedvalue = int(n.text)
			if((centerNumber>=secretvalue && lookedvalue>centerNumber) || (centerNumber<=secretvalue && lookedvalue<centerNumber) && n.text != "X"):
				n.text = "X"
				n.add_color_override("font_color", Color(255,0,0,1))
	$Game/HBoxContainer/BlasterItem.visible = false

