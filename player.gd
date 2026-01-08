extends CharacterBody2D

const TILE_SIZE := 16.0
const MOVE_COOLDOWN := 0.2
const MOVE_SPEED := 20.0

@onready var animations: AnimationPlayer = $AnimationPlayer

var move_timer := 0.0
var last_dir := Vector2.DOWN

var moving := false
var move_dir := Vector2.ZERO
var distance_moved := 0.0


func _physics_process(delta: float) -> void:
	if moving:
		_continue_move(delta)
		return

	move_timer -= delta
	if move_timer > 0:
		return

	_handle_input()


func _handle_input() -> void:
	var dir := Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		dir = Vector2.UP
		animations.play("walk_up")
	elif Input.is_action_pressed("ui_down"):
		dir = Vector2.DOWN
		animations.play("walk_down")
	elif Input.is_action_pressed("ui_left"):
		dir = Vector2.LEFT
		animations.play("walk_left")
	elif Input.is_action_pressed("ui_right"):
		dir = Vector2.RIGHT
		animations.play("walk_right")

	if dir == Vector2.ZERO:
		_play_idle()
		return

	last_dir = dir
	move_dir = dir
	distance_moved = 0.0
	moving = true
	move_timer = MOVE_COOLDOWN


func _continue_move(delta: float) -> void:
	var step := MOVE_SPEED * delta
	var remaining := TILE_SIZE - distance_moved
	step = min(step, remaining)

	var collision := move_and_collide(move_dir * step)
	if collision:
		moving = false
		_snap_to_grid()
		_play_idle()
		return

	distance_moved += step

	if distance_moved >= TILE_SIZE:
		moving = false
		_snap_to_grid()
		_play_idle()


func _snap_to_grid() -> void:
	global_position = global_position.snapped(Vector2(TILE_SIZE, TILE_SIZE))


func _play_idle() -> void:
	match last_dir:
		Vector2.UP:
			animations.play("idle_up")
		Vector2.DOWN:
			animations.play("idle_down")
		Vector2.LEFT:
			animations.play("idle_left")
		Vector2.RIGHT:
			animations.play("idle_right")
