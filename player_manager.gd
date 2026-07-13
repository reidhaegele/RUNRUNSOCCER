extends Node2D

var screen_bounds: Rect2
var selected_player: CharacterBody2D
var swipe_start: Vector2 = Vector2.ZERO
const MIN_SWIPE_DISTANCE: float = 30.0
@onready var children = [$Reid, $Sandra, $Gabe]
@onready var selected_label: Label = $Label

func _ready():
	screen_bounds = get_viewport_rect()

	for child in get_children():
		if child.has_signal("selection"):
			child.selection.connect(_on_child_selected)

		if child.has_method("set_bounds"):
			child.set_bounds(screen_bounds)

func _on_child_selected(selected_child: Node):
	if not selected_child:
		for i in range(len(children)):
			if selected_player == children[i]:
				selected_child = children[(i+1) % len(children)]
				break
	if not selected_child:
		selected_child = children[0]
	selected_player = selected_child

	selected_label.text = "Selected Player: " + selected_child.name

	for child in get_children():
		if child.has_method("set_selected"):
			child.set_selected(child == selected_child)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
			_on_child_selected(null)


func _unhandled_input(event):
	if selected_player == null:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				swipe_start = event.position
			else:
				var swipe = event.position - swipe_start

				if swipe.length() >= MIN_SWIPE_DISTANCE:
					selected_player.set_direction(
						swipe.normalized()
					)


#func _process(_delta):
	#pass
