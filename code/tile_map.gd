extends TileMap

var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_90 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_180 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
var o := [o_0, o_90, o_180, o_270]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var shapes := [i, t, o, z, s, l, j]
var shapes_full:=shapes.duplicate()

const COLS : int=10
const ROWS : int=15

const directions:=[Vector2i.LEFT,Vector2i.RIGHT,Vector2i.DOWN]
var steps:Array
const steps_req:int=50
const startPos:=Vector2i(5,1)
var cur_pos:=Vector2i()
var speed:float
var accel:float=0.25

var piece_type
var next_piece_type
var rotationIndex:int=0
var activePiece:Array

var board_data:Array
var piece_id:int

var level:int=0
var game_running:bool
var threshold:int=24
var piece_number=0
var max_piece_num=14
var lives=3
var can_sound:bool
var can_shake:bool
var can_doof:bool
var paused=false
var can_move_piece:bool

var tile_id:int=0
var pieceAtlas:Vector2i
var next_piece_atlas:Vector2i

var background:int=0
var voidLayer:int=1
var boardLayer:int=2
var activeLayer:int=3

var highest_lvl=0
const SAVE_PATH="user://save.save"

@onready var explosion=$explosion
@onready var explosion_sound=$sound/Destruction
@onready var landing_sound=$sound/BlockClick
@onready var click_sound=$sound/Click
@onready var lvlUp_sound=$sound/LevelUp
@onready var gameover_sound=$sound/GameOver

@onready var meme_break=$meme_sound/meme_break
@onready var meme_click=$meme_sound/meme_click
@onready var meme_lvlUp=$meme_sound/meme_lvlUp
@onready var meme_place=$meme_sound/meme_place
@onready var meme_eugh=$meme_sound/eugh
@onready var meme_loser=$meme_sound/loser

func _ready() -> void:
	randomize()
	load_data()
	show_hearth()
	new_game()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$CanvasLayer/Start.show()
	$CanvasLayer/HUD.show()
	$CanvasLayer/htp.hide()
	$CanvasLayer/setting.hide()
	
	$CanvasLayer/Start.get_node("high_lvl").text="MAX LEVEL: "+str(highest_lvl)
	explosion.hide()
	game_running=false
	can_move_piece=true
	$CanvasLayer/Start/startGamebutton.pressed.connect(start_game_toplay)
	$CanvasLayer/Start/htp_button.pressed.connect(howtoplay_nd_credits)
	$CanvasLayer/Start/settingsButton.pressed.connect(setting)
	$CanvasLayer/htp/back_button.pressed.connect(start_menu)
	$CanvasLayer/setting/back_button.pressed.connect(start_menu)
	$CanvasLayer/setting/quit.pressed.connect(func():
		save_data()
		get_tree().quit()
	)
	$CanvasLayer/setting/back_to_menu.pressed.connect(func():
		paused=false
		game_running=false
		start_menu()
	)
	$CanvasLayer/Start/quit.pressed.connect(func():
		save_data()
		get_tree().quit()
	)
	
	$CanvasLayer/setting.drag_ended.connect(_drag_ended)
	$CanvasLayer/setting.ss_on.connect(is_on)
	$CanvasLayer/setting.doofus_mode_on.connect(doofus_on)
	
	$CanvasLayer/HUD.get_node("startButton").pressed.connect(func():
		play_sfx(click_sound)
		new_game()
	)
func start_game_toplay():
	play_sfx(click_sound)
	$CanvasLayer/Start.hide()
	$CanvasLayer/htp.hide()
	$CanvasLayer/setting.hide()
	new_game()
func start_menu():
	save_data()
	play_sfx(click_sound)
	$CanvasLayer/Start.show()
	$CanvasLayer/htp.hide()
	$CanvasLayer/setting.hide()
func howtoplay_nd_credits():
	play_sfx(click_sound)
	$CanvasLayer/htp.show()
	$CanvasLayer/Start.hide()
func setting():
	play_sfx(click_sound)
	$CanvasLayer/htp.hide()
	$CanvasLayer/Start.hide()
	$CanvasLayer/setting.show()
	$CanvasLayer/setting/main_scr.get_node("setting").text="Settings"
	$CanvasLayer/setting/quit.hide()
	$CanvasLayer/setting/back_to_menu.hide()
	$CanvasLayer/setting/back_button.show()
func new_game():
	speed=1.0
	level=0
	piece_id=0
	init_board()
	game_running=true
	steps=[0,0,0]
	$CanvasLayer/HUD.get_node("gameOver").hide()
	lives=3
	$CanvasLayer/HUD.get_node("hearth3").show()
	$CanvasLayer/HUD.get_node("hearth2").show()
	$CanvasLayer/HUD.get_node("hearth").show()
	clear_board(false)
	clear_panel()
	clear_piece()
	
	can_sound=true
	piece_type=pick_piece()
	pieceAtlas=pick_color()
	next_piece_type=pick_piece()
	next_piece_atlas=pick_color()
	create_piece()	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused_game()
	if game_running:
		if can_move_piece:
			if Input.is_action_pressed("ui_left"):
				steps[0]+=10
			elif Input.is_action_pressed("ui_right"):
				steps[1]+=10
			elif Input.is_action_pressed("ui_down"):
				steps[2]+=10
			elif Input.is_action_just_pressed("ui_up"):
				rotate_piece()
		
		steps[2]+=speed
		for i in range(steps.size()):
			if steps[i]>steps_req:
				move_piece(directions[i])
				steps[i]=0
func _drag_ended(boolean):
	if boolean:
		click_sound.play()
func is_on(boolean):
	click_sound.play()
	if not boolean:
		can_shake=false
	elif boolean:
		can_shake=true
func doofus_on(boolean):
	meme_eugh.play()
	if not boolean:
		can_doof=true
	elif boolean:
		can_doof=false
func pick_piece():
	return shapes_full[randi() % shapes_full.size()]
func create_piece():
	steps=[0,0,0]
	cur_pos=startPos
	activePiece=piece_type[rotationIndex]
	draw_piece(activePiece,cur_pos,pieceAtlas)
	draw_piece(next_piece_type[0],Vector2i(15,4),next_piece_atlas)
func init_board():
	piece_number=max_piece_num
	$CanvasLayer/HUD.get_node("score").text = "LEVEL: " + str(level+1)
	$CanvasLayer/HUD.get_node("piece_count").text = "Pieces left: "+str(piece_number)+"/"+str(max_piece_num)
	board_data.clear()
	for y in range(ROWS+2):
		var row=[]
		for x in range(COLS+2):
			row.append(null)
		board_data.append(row)
func play_explosion(pos: Vector2i):
	explosion.position=map_to_local(pos)
	explosion.show()
	explosion.play("explosion")
	await explosion.animation_finished
	explosion.hide()
func play_sfx(sound):
	if can_doof:
		sound.pitch_scale=randf_range(0.8, 1.2)
		sound.play()
	elif not can_doof:
		if sound==explosion_sound:
			sound=meme_break
		elif sound==landing_sound:
			sound=meme_place
		elif sound==lvlUp_sound:
			sound=meme_lvlUp
		elif sound==click_sound:
			sound=meme_click
		else:
			sound=meme_loser
		sound.pitch_scale=randf_range(0.8, 1.2)
		sound.play()			
func shake_scrn(value):
	if can_shake:
		$Camera2D.add_trauma(value)
func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		highest_lvl = file.get_var()
		var music_volume = file.get_var()
		var sfx_volume = file.get_var()
		
		var value=file.get_var()
		if value!=null:
			can_shake=value
		else:
			can_shake=true
			
		value=file.get_var()
		if value!=null:
			can_doof=value
		else:
			can_doof=false
		file.close()
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), music_volume)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), sfx_volume)
		
		$CanvasLayer/setting/music_bg/music_val.value = db_to_linear(music_volume)
		$CanvasLayer/setting/sfx_bg/sfx_val.value = db_to_linear(sfx_volume)
		$CanvasLayer/setting/screen_shake_bg/screen_shake.button_pressed=can_shake
		$CanvasLayer/setting/doofus_mode/doofus.button_pressed=can_doof
	else:
		highest_lvl = 0
		can_shake=true
		can_doof=false
func save_data():
	if level>highest_lvl:
		highest_lvl=level
	var file=FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(highest_lvl)
	file.store_var(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")))
	file.store_var(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	file.store_var(can_shake)
	file.store_var(can_doof)
	file.close()
func clear_piece():
	for i in activePiece:
		erase_cell(activeLayer,cur_pos+i)
func draw_piece(piece,pos,atlas):
	for i in piece:
		set_cell(activeLayer,pos+i,tile_id,atlas)
func pick_color():
	var random_number=(randi() % 100)
	if random_number>threshold:
		return Vector2i(0,0)
	else:
		return Vector2i(1,0)
func move_piece(dir):
	if can_move(dir):
		clear_piece()
		cur_pos+=dir
		draw_piece(activePiece, cur_pos, pieceAtlas)
		
		var deep=deepest_pos()
		for cell in deep:
			if cell.y+1>ROWS or board_data[cell.y+1][cell.x]!=null:
				if pieceAtlas == Vector2i(0,0):
					var greenID=green_scan(deep,1)
					var is_red=is_red(deep)
					if len(greenID)>0 and not is_red:
						play_sfx(explosion_sound)
						shake_scrn(0.5)
						all_green_explode_arbys_style(greenID)
						can_sound=false
						can_move_piece=false
						break
					elif can_sound:
						play_sfx(landing_sound)
						shake_scrn(0.2)
						can_sound=false
						can_move_piece=false
					break
				elif can_sound:
					play_sfx(landing_sound)
					shake_scrn(0.2)
					can_sound=false
					can_move_piece=false
					break
	else:
		if dir==Vector2i.DOWN:
			land_piece()
			piece_type=next_piece_type
			pieceAtlas=next_piece_atlas
			next_piece_type=pick_piece()
			next_piece_atlas=pick_color()
			clear_panel()
			can_sound=true
			can_move_piece=true
			create_piece()
			check_next_level()
func can_move(dir):
	var cm=true
	for i in activePiece:
		if not is_free(i+cur_pos+dir):
			cm=false
	return cm
func is_free(pos):
	"""
	This fucntion is to check whether it's possible to move the piece, it first checks the if statement to see based on the coordinates
	whether it is possible to move then it also checks if theres a piece that it may interfere with and return a boolean value
	"""
	if pos.x < 1 or pos.x > COLS-1 or pos.y < 1 or pos.y > ROWS:
		return false
	return board_data[pos.y][pos.x]==null
func rotate_piece():
	if can_rotate():
		clear_piece()
		rotationIndex=(rotationIndex+1)%4
		activePiece=piece_type[rotationIndex]
		draw_piece(activePiece,cur_pos,pieceAtlas)
func can_rotate():
	var cr=true
	var TempRotationIndex=(rotationIndex+1)%4
	for i in piece_type[TempRotationIndex]:
		if not is_free(i+cur_pos):
			cr=false
	return cr
func land_piece():
	var deepestCell=[]
	for i in activePiece:
		var pos = cur_pos + i
		var color=""
		erase_cell(activeLayer,pos)
		erase_cell(voidLayer,pos)
		set_cell(boardLayer,pos,tile_id,pieceAtlas)
		set_cell(voidLayer,pos,tile_id,pieceAtlas)
		if pieceAtlas==Vector2i(0,0):
			color="red"
		else:
			color="green"
		board_data[pos.y][pos.x]=[piece_id,color]
	piece_id+=1
	piece_number-=1
	$CanvasLayer/HUD.get_node("piece_count").text = "Pieces left: " + str(piece_number) +"/"+ str(max_piece_num)
	if pieceAtlas==Vector2i(0,0):
		green_dest()
func green_dest():
	var deepC=deepest_pos()
	var redID=piece_id-1

	var is_red=is_red(deepC)
	var greenID=green_scan(deepC,1)
	
	if not is_red and len(greenID)>0:
		if len(greenID)>1:
			for i in range(len(greenID)):
				if greenID[i]!=null:
					all_green_cordDel(greenID[i])
		else:
			all_green_cordDel(greenID[0])
		apply_gravity(deepC,redID)
func green_scan(deep, start):
	var id=[]
	for cell in deep:
			if cell.y+start>ROWS:
				continue
			var i=start
			while true:
				if cell.y+i<=ROWS:
					if board_data[cell.y+i][cell.x]==null:
						i+=1
					elif board_data[cell.y+i][cell.x][1]=="red":
						break
					elif board_data[cell.y+i][cell.x][1]=="green":
						if not id.has(board_data[cell.y+i][cell.x][0]):
							id.append(board_data[cell.y+i][cell.x][0])
						i+=1
				else:
					break
	return id
func is_red(deep):
	var isRed=false
	for cell in deep:
		if cell.y!=ROWS:
			if board_data[cell.y+1][cell.x]!=null:
				if board_data[cell.y+1][cell.x][1]=="red":
					isRed=true
					break
	return isRed
func clear_panel():
	for i in range(14,19):
		for j in range(4,8):
			erase_cell(activeLayer,Vector2i(i,j))
func clear_board(k):
	for i in range(ROWS+1):
		for j in range(COLS):
			erase_cell(boardLayer,Vector2i(j,i))
			if not k:
				erase_cell(voidLayer,Vector2i(j,i))
	if k:		
		for i in range(ROWS+1,0,-1):
			for j in range(COLS):
				erase_cell(voidLayer,Vector2i(j, i))
			await get_tree().create_timer(0.1).timeout
func check_next_level():
	hide_hearth()
	for i in activePiece:
		if piece_number==0:
			clear_board(true)
			init_board()
			$CanvasLayer/HUD.get_node("score").text = "LEVEL: " + str(level+1)
			level+=1
			lvlUp_sound.play()
			if lives!=3:
				lives+=1
				show_hearth()
			if level%5==0:
				threshold+=5
				if piece_number<=37:
					max_piece_num+=5
			return
		elif get_cell_source_id(boardLayer, i + cur_pos)!=-1 or lives<=0:
			land_piece()
			save_data()
			clear_board(true)
			gameover_sound.play()
			$CanvasLayer/HUD.get_node("gameOver").show()
			game_running=false
func paused_game():
	paused=not paused
	game_running=not paused
	get_tree().paused=paused
	$CanvasLayer/setting.visible = paused
	$CanvasLayer/setting/main_scr.get_node("setting").text="Paused"
	$CanvasLayer/setting/back_button.hide()
	$CanvasLayer/setting/quit.show()
	$CanvasLayer/setting/back_to_menu.show()
	if not paused:
		game_running = true
func deepest_pos():
	var deepest_cells:Array[Vector2i]=[]
	for i in activePiece:
		var pos=Vector2i(cur_pos+i)
		var column_found=false
		for j in range(deepest_cells.size()):
			if deepest_cells[j].x==pos.x:
				column_found=true
				if pos.y>deepest_cells[j].y:
					deepest_cells[j].y=pos.y
				break
		if not column_found:
			deepest_cells.append(pos)
	return deepest_cells
func all_green_cordDel(id):
	lives-=1
	hide_hearth()
	for y in range(1,ROWS+1):
		for x in range(1,COLS+1):
			if board_data[y][x]!=null and board_data[y][x][0]==id:
				erase_cell(boardLayer,Vector2i(x,y))
				erase_cell(voidLayer,Vector2i(x,y))
				board_data[y][x]=null
func all_green_explode_arbys_style(Gid):
	for i in range(len(Gid)):
		var id=Gid[i]
		for y in range(1,ROWS+1):
			for x in range(1,COLS+1):
				if board_data[y][x]!=null and board_data[y][x][0]==id:
					play_explosion(Vector2i(x,y))			
func apply_gravity(lowRow,id):
	var offset=[]
	var isGreen=false
	for cell in lowRow:
		var i=1
		while true:
			if cell.y + i > ROWS:
				offset.append(i - 1)
				break
			if board_data[cell.y + i][cell.x] == null:
				i += 1
			else:
				offset.append(i - 1)
				break
	offset.sort()
	var lowest_offset=offset[0]
	var pieceCells=[]
	for y in range(1,ROWS+1):
		for x in range(1,COLS+1):
			if board_data[y][x]!=null and board_data[y][x][0]==id:
				pieceCells.append(Vector2i(x,y))
	for pos in pieceCells:
		erase_cell(boardLayer, Vector2i(pos.x,pos.y))
		erase_cell(voidLayer, Vector2i(pos.x,pos.y))
		board_data[pos.y][pos.x]=null
	for pos in pieceCells:
		set_cell(boardLayer, Vector2i(pos.x,pos.y+lowest_offset),tile_id,Vector2i(0,0))
		set_cell(voidLayer, Vector2i(pos.x,pos.y+lowest_offset),tile_id,Vector2i(0,0))
		board_data[pos.y+lowest_offset][pos.x]=[id,"red"]
func hide_hearth():
	if lives==2:
		$CanvasLayer/HUD.get_node("hearth3").hide()
	elif lives==1:
		$CanvasLayer/HUD.get_node("hearth2").hide()
	elif lives==0:
		$CanvasLayer/HUD.get_node("hearth").hide()
func show_hearth():
	if lives==3:
		$CanvasLayer/HUD.get_node("hearth3").show()
	elif lives==2:
		$CanvasLayer/HUD.get_node("hearth2").show()
	elif lives==1:
		$CanvasLayer/HUD.get_node("hearth").show()
