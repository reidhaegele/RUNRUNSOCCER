extends RigidBody2D

var screen_bounds: Rect2


func set_bounds(bounds: Rect2):
	screen_bounds = bounds


func _physics_process(_delta):
	check_screen_bounds()


func check_screen_bounds():
	if screen_bounds == Rect2():
		return

	var shape = $CollisionShape2D.shape

	if shape == null or not shape is CircleShape2D:
		return

	var radius = shape.radius

	var bounced = false
	var new_velocity = linear_velocity


	# Left/right walls
	if global_position.x <= screen_bounds.position.x + radius:
		global_position.x = screen_bounds.position.x + radius
		new_velocity.x = abs(new_velocity.x)
		bounced = true

	elif global_position.x >= screen_bounds.end.x - radius:
		global_position.x = screen_bounds.end.x - radius
		new_velocity.x = -abs(new_velocity.x)
		bounced = true


	# Top/bottom walls
	if global_position.y <= screen_bounds.position.y + radius:
		global_position.y = screen_bounds.position.y + radius
		new_velocity.y = abs(new_velocity.y)
		bounced = true

	elif global_position.y >= screen_bounds.end.y - radius:
		global_position.y = screen_bounds.end.y - radius
		new_velocity.y = -abs(new_velocity.y)
		bounced = true


	if bounced:
		linear_velocity = new_velocity
