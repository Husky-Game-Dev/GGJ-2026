@tool
class_name CheckBoxButton extends Button


signal checked(checked_on: bool)


@export
var default_checked: bool = false


var button_checked: bool:
	get:
		return _button_checked
	set(value):
		if _button_checked != value:
			_button_checked = value
			checked.emit(_button_checked)
var _button_checked: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	pressed.connect(_on_pressed)
	button_checked = default_checked
	checked.connect(_on_checked)
	checked.emit(button_checked)


func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		return
	_on_checked(default_checked)


func _on_pressed() -> void:
	button_checked = !button_checked
	checked.emit(button_checked)


func _on_checked(checked_on: bool) -> void:
	if checked_on:
		theme_type_variation = "CheckBoxButtonChecked"
	else:
		theme_type_variation = "CheckBoxButton"
