extends Control

signal drag_ended(boolean)
signal ss_on(isOn)
signal doofus_mode_on(isOn)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music_bg/music_val.value_changed.connect(_on_music_volume_changed)
	$music_bg/music_val.drag_ended.connect(_drag_ended)
	$sfx_bg/sfx_val.value_changed.connect(_on_volume_changed)
	$sfx_bg/sfx_val.drag_ended.connect(_drag_ended)
	$screen_shake_bg/screen_shake.toggled.connect(_pressed)
	$doofus_mode/doofus.toggled.connect(_pressed_doofus)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"),linear_to_db(value))
func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"),linear_to_db(value))
func _drag_ended(boolean):
	drag_ended.emit(boolean)
func _pressed(isOn):
	ss_on.emit(isOn)
func _pressed_doofus(isOn):
	doofus_mode_on.emit(not isOn)
