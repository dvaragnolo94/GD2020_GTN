extends VBoxContainer
var GameState =  load("res://GameState.gd")
var gs

# Different lore, based on the choice of the player
var lore = ["Good Morning Sir!\n Let me introduce myself: i'm Hon Salo, the second commander of this spaceship.\n I'm here to explain the plan: we have to go to the planet Caruscont,\n and rescue our spy CC-9 from the enemies. Right now we have to prepare the spaceship\n and set the correct amount of fuel.\nDo we take the cheaper (A) or the expensive (B) one?","We are arrived! now we have only to enter in that prison,\n open that door and... Oh F**k! the door is locked with a code:\n we have to find the combination! \n Do you want to loot the guard killed before (B)\n or try without go back (A)?","The enemies are behind us!\n We have to change our path, find a new path to home with new coordinates!\n Try right (A) or left(B)?","It's done!\n thank you sir for your help, see you in the next mission!'"]
var loreUnlucky = ["Maybe was better the expensive one, but ok...","Ok, start to unlock!","Oh S**t, there are more enemies there!","It's done!\n thank you sir for your help, see you in the next mission!'"]
var loreLucky = ["Good Choice! We have to save lives, not out bank account!","We are lucky, it has a part of combination in the pockets!","Perfect, there are some asteroids there, we could hide ourself easly!","It's done!\n thank you sir for your help, see you in the next mission!'"]

var loreChoice = 4
var loreStep = 0
var levelCorrection = 0
var blasterUsed = false
signal msg(arg)

var bg2 = preload("res://GUI/bg1.jpg")
var bg3 = preload("res://GUI/bg3.jpg")
var guessButton = preload("res://GUI/guess.png")
var wrongButton = preload("res://GUI/wrong.png")
var background 

# Called when the node enters the scene tree for the first time.
func _ready():	
	print("Main Ready!")
	background = get_node("Background")
	self.connect("msg", self,"_message_label")
	pass # Replace with function body.

func _main(val):	
	if(gs.try(val)):
		$Game/Continue.visible = true
		$Tutorial/Back.visible = true
		$Game/Grid.visible = false
		if(gs.hist_count<4 && !blasterUsed):
			levelCorrection = levelCorrection + 1
			$Game/HBoxContainer/BlasterItem.visible=true
			emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves and now you have Blaster (1 use, drop half grid)!")
		else:
			emit_signal("msg","Got It! Good Job! \n You win with " + str(gs.hist_count) + " moves")
	else:
		if(gs.lose_check()):
			$Game/Continue.visible = false
			$Game/Grid.visible = false
			$Game/Restart.visible = true
			emit_signal("msg","Sorry man, you've lost :( \n The number was " + str(gs.secret))
			
		else:
			emit_signal("msg",gs.hint(val))

func _message_label(arg):
	$Game/Label.text = str(arg)
	$Tutorial/Label.text = str(arg)
	 
	
func _on_Play_pressed():
	$Lore/Play.visible = false
	$Game/Restart.visible = false
	game_view("game")
	loreStep = loreStep + 1	
	delete_children($Game/Grid)
	$Game/Label.text = "Try a number!"
	background.set_texture(bg3)
	# Calculus of the size of the Grid, based on choice of the player
	if(loreChoice>5):
		print("Lucky")
		gs = GameState.new($Menu/Difficulty/HSlider.value + levelCorrection,loreStep*20+20)
		_create_grid($Game/Grid,loreStep*20+20)
	elif(loreChoice<2):
		print("Unlucky")
		gs = GameState.new($Menu/Difficulty/HSlider.value + levelCorrection,loreStep*20+60)
		_create_grid($Game/Grid,loreStep*20+60)
	else:
		print("Normal")
		gs = GameState.new($Menu/Difficulty/HSlider.value + levelCorrection,loreStep*20+40)
		_create_grid($Game/Grid,loreStep*20+40)
	#print(gs.n_options)
	
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
			#b.text = str(i+1)
			b.name = "btn_"+ str(i+1) + "_Grid"
			b.set_button_icon(guessButton)
			b.connect("pressed",self,"_on_Button_pressed",[b])
			node.add_child(b)


func _on_HSlider_value_changed(value):
		$Menu/Difficulty/LevelDiff.text = str($Menu/Difficulty/HSlider.value + levelCorrection)

func _on_Button_pressed(target):
	var buttonValue = int(target.name.split("_",true)[1])
	_main(int(buttonValue))
	var guessvalue = int(buttonValue)
	var secretvalue = gs._get_secret()
	for m in $Game/Grid.get_children():
		for n in m.get_children():
			var lookedvalue = int(n.name.split("_",true)[1])
			if((guessvalue>secretvalue && lookedvalue>=guessvalue) || (guessvalue<secretvalue && lookedvalue<=guessvalue)):
				n.set_button_icon(wrongButton)
				#n.add_color_override("font_color", Color(255,0,0,1))

func _on_Start_pressed():
	game_view("lore")
	$Lore/ChoContainer.visible = true	
	$Lore/LoreLabel.text = lore[loreStep]
	background.set_texture(bg2)	
	if (loreStep==lore.size()-1): 
		$Lore/Play.visible = false
		$Lore/ChoContainer.visible = false
		$Lore/Back.visible = true
	
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _on_Tutorial_pressed():
	game_view("tutorial")
	gs = GameState.new($Menu/Difficulty/HSlider.value,5)
	_create_grid($Tutorial/TutorialGrid,10)
	
func _on_Back_pressed():
	delete_children($Tutorial/TutorialGrid)
	loreStep = 0
	levelCorrection = levelCorrection + 1
	$Lore/Back.visible= false
	game_view("menu")

func _on_BlasterItem_button_down():
	blasterUsed = true
	var centerNumber = (loreStep*20+40)/2
	var secretvalue = gs._get_secret()
	for m in $Game/Grid.get_children():
		for n in m.get_children():
			var lookedvalue = int(n.name.split("_",true)[1])
			if((centerNumber>=secretvalue && lookedvalue>centerNumber) || (centerNumber<=secretvalue && lookedvalue<centerNumber)):
				n.set_button_icon(wrongButton)
				#n.add_color_override("font_color", Color(255,0,0,1))
	$Game/HBoxContainer/BlasterItem.visible = false

func _on_ChoA_button_down():
	$Lore/ChoContainer.visible = false
	$Lore/Play.visible = true
	#Set of correct Lore and Grid size (based on story)
	loreChoice = 1
	$Lore/LoreLabel.text = loreUnlucky[loreStep]

func _on_ChoB_button_down():
	$Lore/ChoContainer.visible = false
	$Lore/Play.visible = true
	#Set of correct Lore and Grid size (based on story)
	loreChoice = 6
	$Lore/LoreLabel.text = loreLucky[loreStep]


func _on_Restart_button_down():
	delete_children($Game/Grid)
	loreStep = 0
	levelCorrection = levelCorrection - 1
	print("Difficulty " + str(gs.difficulty) + "; Level COrrection: " + str(levelCorrection))
	if(gs.difficulty + levelCorrection > 1):
		$Menu/Difficulty/HSlider.value = gs.difficulty + levelCorrection 
	else:
		$Menu/Difficulty/HSlider.value = 1 
	game_view("menu")

func game_view(gv):
	if(gv=="menu"):
		$Menu.visible = true
		#$Lore/Back.visible = false
		$Game.visible = false
		$Lore.visible = false
		$Tutorial.visible = false
		return
	if(gv=="tutorial"):
		$Menu.visible = false
		$Game.visible = false
		$Lore.visible = false
		$Tutorial.visible = true
		return	
	if(gv=="lore"):
		$Menu.visible = false
		$Game.visible = false
		$Lore.visible = true
		$Tutorial.visible = false
		return
	if(gv=="game"):
		$Menu.visible = false
		$Game.visible = true
		$Lore.visible = false
		$Tutorial.visible = false
		return
	pass
