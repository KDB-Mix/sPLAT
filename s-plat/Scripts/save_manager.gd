extends Node

var filePath = "user://save.dat"
var saveData: Dictionary = {}

const LEVELS_DONE_KEY = "SKIN"
const volume_key = "VOLUME"
const key_base64 = "V2h5IGRpZCB5b3UgbG9vayBhdCB0aGF0Pw=="


func _ready() -> void:
	load_data()

func load_data():
	#var file = FileAccess.open_encrypted_with_pass(filePath, FileAccess.READ, Marshalls.base64_to_utf8(key_base64))
	var file = FileAccess.open_encrypted_with_pass(filePath, FileAccess.READ, Marshalls.base64_to_utf8(key_base64))
	if file:
		var file_data = JSON.parse_string(file.get_as_text())
		file.close()
		if file_data:
			saveData = file_data
			initialize_defaults()
		else:
			initialize_defaults()
	else:
		initialize_defaults()
func initialize_defaults():
	saveData.get_or_add(LEVELS_DONE_KEY, [])
	saveData.get_or_add(volume_key, 100)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), saveData[volume_key]/100)
	save_file()

func save_file():
	#var file = FileAccess.open_encrypted_with_pass(filePath, FileAccess.WRITE, Marshalls.base64_to_utf8(key_base64))
	var file = FileAccess.open_encrypted_with_pass(filePath, FileAccess.WRITE, Marshalls.base64_to_utf8(key_base64))
	if file:
		var saveDataString = JSON.stringify(saveData, "\t")
		file.store_string(saveDataString)
		file.close()
	else:
		initialize_defaults()
		
func level_done(level: int):
	if !level in saveData.get(LEVELS_DONE_KEY, []):
		saveData[LEVELS_DONE_KEY].append(level)
		save_file()
