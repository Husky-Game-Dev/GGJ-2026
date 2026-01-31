class_name Main extends Node


@onready
var settings_menu: SettingsMenu = %SettingsMenu


func _unhandled_input(event: InputEvent) -> void:
	if InputManager.get_input_state() == InputManager.InputState.GAMEPLAY:
		if event.is_action(&"pause") && event.is_pressed():
			InputManager.soft_push_input_state(InputManager.InputState.PAUSE_MENU)
