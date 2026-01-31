@abstract
class_name Menu extends Control


var menu_name: String = "menu"
var menu_open: bool = false
var menu_config: bool = false

var config_file_name: String:
	get:
		return "user://%s_config.json" % menu_name


func open_menu() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_open = true
	show()


func close_menu() -> void:
	hide()
	menu_open = false
	process_mode = Node.PROCESS_MODE_DISABLED
	save_config()


func toggle_menu() -> void:
	if menu_open:
		close_menu()
	else:
		open_menu()


func load_config() -> void:
	if !menu_config:
		return
	if !FileAccess.file_exists(config_file_name):
		return
	var config_file: FileAccess = FileAccess.open(config_file_name, FileAccess.READ)
	if config_file == null:
		printerr("IO error reading %s: %s" % [config_file_name, str(FileAccess.get_open_error())])
		OS.alert("IO error reading %s: %s" % [config_file_name, str(FileAccess.get_open_error())], "Error reading config data")
		return
	var json_string: String = config_file.get_as_text()
	config_file.close()
	@warning_ignore("untyped_declaration")
	var config_data = JSON.parse_string(json_string)
	if config_data == null:
		printerr("Malformed JSON file")
		#OS.alert("Malformed JSON file", "Error parsing config data")
		return
	@warning_ignore("unsafe_call_argument")
	upgrade_config(config_data)
	@warning_ignore("unsafe_call_argument")
	deserialize_config(config_data)


func save_config() -> void:
	if !menu_config:
		return
	var config_data: Dictionary = {
		"version": "1.0.0",
	}
	serialize_config(config_data)
	var json_string: String = JSON.stringify(config_data)
	var config_file: FileAccess = FileAccess.open(config_file_name, FileAccess.WRITE)
	if config_file == null:
		printerr("IO error writing %s: %s" % [config_file_name, str(FileAccess.get_open_error())])
		#OS.alert("IO error writing %s: %s" % [config_file_name, str(FileAccess.get_open_error())], "Error writing config data")
		return
	config_file.store_string(json_string)
	config_file.close()


@warning_ignore_start("unused_parameter")
func serialize_config(config_data: Dictionary) -> void:
	pass


func deserialize_config(config_data: Dictionary) -> void:
	pass


func upgrade_config(config_data: Dictionary) -> void:
	pass
@warning_ignore_restore("unused_parameter")
