class_name MainMenu extends Menu


@onready
var play_button: Button = %PlayButton
@onready
var quit_button: Button = %QuitButton


func _ready() -> void:
	menu_name = "pause"
	menu_config = false
	hide()
	InputManager.input_state_changed.connect(_on_input_state_changed)
	
	if OS.get_name() == "Web":
		quit_button.hide()


func open_menu() -> void:
	super()
	play_button.grab_focus()


func _input(event: InputEvent) -> void:
	if menu_open && event.is_action(&"pause") && event.is_pressed():
		InputManager.soft_pop_input_state()


func _on_click_outside_pressed() -> void:
	InputManager.soft_pop_input_state()


func _on_input_state_changed(old_state: InputManager.InputState, new_state: InputManager.InputState) -> void:
	if old_state == InputManager.InputState.MAIN_MENU:
		close_menu()
	if new_state == InputManager.InputState.MAIN_MENU:
		open_menu()


func _on_play_button_pressed() -> void:
	InputManager.switch_input_state(InputManager.InputState.GAMEPLAY)


func _on_settings_button_pressed() -> void:
	InputManager.soft_push_input_state(InputManager.InputState.SETTINGS_MENU)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
