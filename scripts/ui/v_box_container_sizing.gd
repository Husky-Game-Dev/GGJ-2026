extends ScrollContainer


func _ready() -> void:
	for child: Control in %LeftContainer.get_children():
		child.custom_minimum_size.x = self.size.x * 0.5
	print("x")
	for child: Control in get_children():
		print(child.custom_minimum_size.x)
