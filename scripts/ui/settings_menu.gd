class_name SettingsMenu extends Menu


@onready
var tab_container: TabContainer = %TabContainer

@onready
var game_speed_slider: HSlider = %GameSpeedSlider

@onready
var display: HBoxContainer = %Display
@onready
var display_option_button: OptionButton = %DisplayOptionButton
@onready
var v_sync_check_box_button: CheckBoxButton = %VSyncCheckBoxButton

@onready
var master_volume_slider: HSlider = %MasterVolumeSlider
@onready
var sfx_volume_slider: HSlider = %SFXVolumeSlider
@onready
var music_volume_slider: HSlider = %MusicVolumeSlider

@export
var tab_rows: Array[VBoxContainer] = []

var master_bus_idx: int = 0
var sfx_bus_idx: int = 0
var music_bus_idx: int = 0


func _ready() -> void:
	menu_name = "settings"
	menu_config = true
	master_bus_idx = AudioServer.get_bus_index(&"Master")
	sfx_bus_idx = AudioServer.get_bus_index(&"SFX")
	music_bus_idx = AudioServer.get_bus_index(&"Music")
	load_config()
	for tab_idx: int in tab_container.get_child_count():
		var rows: VBoxContainer = tab_rows[tab_idx]
		var options: Array[HBoxContainer] = []
		for child2: Node in rows.get_children():
			var option: HBoxContainer = child2 as HBoxContainer
			if option != null:
				options.push_back(option)
		if options.is_empty():
			continue
		for i: int in options.size():
			for j: int in range(1, options[i].get_child_count()):
				var option_value: Control = options[i].get_child(j) as Control
				var option_up: HBoxContainer = options[wrapi(i - 1, 0, options.size())]
				var option_down: HBoxContainer = options[wrapi(i + 1, 0, options.size())]
				option_value.focus_neighbor_top = option_up.get_child(mini(j, option_up.get_child_count() - 1)).get_path()
				option_value.focus_neighbor_bottom = option_down.get_child(mini(j, option_down.get_child_count() - 1)).get_path()
	hide()
	InputManager.input_state_changed.connect(_on_input_state_changed)
	
	if OS.get_name() == "Web":
		display.hide()


func open_menu() -> void:
	super()
	auto_focus()


func _input(event: InputEvent) -> void:
	if menu_open && event.is_action(&"tab_left") && event.is_pressed():
		tab_container.current_tab = wrapi(tab_container.current_tab - 1, 0, tab_container.get_tab_count())
		auto_focus()
	elif menu_open && event.is_action(&"tab_right") && event.is_pressed():
		tab_container.current_tab = wrapi(tab_container.current_tab + 1, 0, tab_container.get_tab_count())
		auto_focus()
	elif menu_open && (event.is_action(&"pause") || event.is_action(&"ui_cancel")) && event.is_pressed():
		InputManager.soft_pop_input_state()


func auto_focus() -> void:
	var rows: VBoxContainer = tab_rows[tab_container.current_tab]
	if rows.get_child_count() <= 0:
		tab_container.grab_focus.call_deferred()
		return
	var option: HBoxContainer = rows.get_child(0) as HBoxContainer
	if option == null:
		return
	var option_value: Control = option.get_child(1) as Control
	if option_value != null:
		option_value.grab_focus.call_deferred()


func serialize_config(config_data: Dictionary) -> void:
	config_data["settings"] = {
		"general": {},
		"accessibility": {
			"game_speed": game_speed_slider.value
		},
		"video": {
			"display": display_option_button.selected,
			"vsync": v_sync_check_box_button.button_checked
		},
		"audio": {
			"master_volume": master_volume_slider.value,
			"sfx_volume": sfx_volume_slider.value,
			"music_volume": music_volume_slider.value
		}
	}


func deserialize_config(config_data: Dictionary) -> void:
	var my_data: Dictionary = config_data["settings"]
	
	@warning_ignore("unused_variable")
	var general_data: Dictionary = my_data["general"]
	
	var accessibility_data: Dictionary = my_data["accessibility"]
	
	game_speed_slider.value = accessibility_data["game_speed"]
	_on_game_speed_slider_value_changed(game_speed_slider.value)
	
	var video_data: Dictionary = my_data["video"]
	
	display_option_button.selected = video_data["display"]
	_on_display_option_button_item_selected(display_option_button.selected)
	v_sync_check_box_button.button_checked = video_data["vsync"]
	_on_v_sync_check_box_button_checked(v_sync_check_box_button.button_checked)
	
	var audio_data: Dictionary = my_data["audio"]
	
	master_volume_slider.value = audio_data["master_volume"]
	_on_master_volume_slider_value_changed(master_volume_slider.value)
	sfx_volume_slider.value = audio_data["sfx_volume"]
	_on_sfx_volume_slider_value_changed(sfx_volume_slider.value)
	music_volume_slider.value = audio_data["music_volume"]
	_on_music_volume_slider_value_changed(music_volume_slider.value)


func _on_game_speed_slider_value_changed(value: float) -> void:
	Engine.time_scale = maxf(0.01, value)


func _on_display_option_button_item_selected(index: int) -> void:
	match index:
		0:
			var old_mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
			var old_size: Vector2i = DisplayServer.window_get_size()
			if old_mode == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN || old_mode == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_size(old_size)
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_v_sync_check_box_button_checked(checked_on: bool) -> void:
	if checked_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus_idx, value * 2.0)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sfx_bus_idx, value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus_idx, value)


func _on_click_outside_pressed() -> void:
	InputManager.soft_pop_input_state()


func _on_input_state_changed(old_state: InputManager.InputState, new_state: InputManager.InputState) -> void:
	if old_state == InputManager.InputState.SETTINGS_MENU:
		close_menu()
	if new_state == InputManager.InputState.SETTINGS_MENU:
		open_menu()
