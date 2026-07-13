extends CharacterBody2D

@onready var speed = 100
@export var selected: bool = false
signal selection(node_reference: Node)
var input_direction: Vector2 = Vector2.RIGHT
var screen_bounds: Rect2
@onready var name_label: Label = $name_label
@onready var highlight: Sprite2D = $highlight
@onready var slowdown: Timer = $slowdown
@onready var body_shape: CollisionShape2D = $body_shape
@onready var scan_area: Area2D = $scan_area


func _ready():
	name_label.text = name
	#velocity = input_direction * speed
	#highlight.modulate = Color(231, 234, 0, selected)


func set_bounds(bounds: Rect2):
	screen_bounds = bounds


func check_screen_bounds():
	if screen_bounds == Rect2():
		return

	var shape = body_shape.shape
	
	if shape == null:
		return

	var half_size: Vector2

	#if shape is RectangleShape2D:
		#half_size = shape.size / 2
	#elif shape is CircleShape2D:
	half_size = Vector2(shape.radius, shape.radius)
	#else:
		#half_size = Vector2.ZERO


	if global_position.x <= screen_bounds.position.x + half_size.x:
		global_position.x = screen_bounds.position.x + half_size.x
		input_direction.x *= -1

	elif global_position.x >= screen_bounds.end.x - half_size.x:
		global_position.x = screen_bounds.end.x - half_size.x
		input_direction.x *= -1


	if global_position.y <= screen_bounds.position.y + half_size.y:
		global_position.y = screen_bounds.position.y + half_size.y
		input_direction.y *= -1

	elif global_position.y >= screen_bounds.end.y - half_size.y:
		global_position.y = screen_bounds.end.y - half_size.y
		input_direction.y *= -1


func get_input():
	var new_direction = Input.get_vector("left", "right", "up", "down")
	if new_direction != Vector2.ZERO:
		input_direction = new_direction.normalized()


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Player clicked: ", name)
			selected = true
			selection.emit(self)
			get_viewport().set_input_as_handled()


func set_selected(value: bool):
	selected = value
	highlight.modulate = Color(231, 234, 0, selected)


func _unhandled_input(event):
	if event.is_action_pressed("kick") and selected:
		var overlapping_bodies = scan_area.get_overlapping_bodies()
	
		if overlapping_bodies.is_empty():
			print("Nothing found on Layer 2.")
			return
			
		for body in overlapping_bodies:
			print("Found object: ", body.name)
			# Optional: If it is a RigidBody2D, apply a force to it
			if body is RigidBody2D:
				#var push_direction = (body.global_position - global_position).normalized()
				body.apply_central_impulse(input_direction * 1000)
		


func set_direction(direction: Vector2):
	if direction != Vector2.ZERO:
		input_direction = direction.normalized()


func _physics_process(_delta):
	if selected:
		get_input()
	velocity = input_direction * speed
	move_and_slide()
	check_screen_bounds()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body is RigidBody2D:
			speed = 75
			slowdown.start()
			body.apply_central_impulse(input_direction * 100.0)


func _on_slowdown_timeout():
	speed = 100
