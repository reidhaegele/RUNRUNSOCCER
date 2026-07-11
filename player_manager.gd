extends Node2D

var screen_bounds: Rect2

func _ready():
	screen_bounds = get_viewport_rect()

	for child in get_children():
		if child.has_signal("selection"):
			child.selection.connect(_on_child_selected)

		if child.has_method("set_bounds"):
			child.set_bounds(screen_bounds)

func _on_child_selected(selected_child: Node):
	#print("Signal received from: ", selected_child.name)
	$Label.text = "Selected Player: " + selected_child.name
	for child in get_children():
		if child.has_method("set_selected"):
			child.set_selected(child == selected_child)
	

func _process(_delta):
	pass
