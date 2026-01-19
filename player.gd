extends CharacterBody2D

const TILE_SIZE := 16.0
var last_direction
var input_direction
var moving = false

@onready var animations: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_direction = Vector2(0,-1)
		last_direction = input_direction
		move() 
		animations.play("walk_up")
	elif Input.is_action_pressed("ui_down"):
		input_direction = Vector2(0,1)
		last_direction = input_direction
		move()
		animations.play("walk_down")
	elif Input.is_action_pressed("ui_left"):
		input_direction = Vector2(-1,0)
		last_direction = input_direction
		move()
		animations.play("walk_left")
	elif Input.is_action_pressed("ui_right"):
		input_direction = Vector2(1,0)
		last_direction = input_direction
		move()
		animations.play("walk_right")
	move_and_slide()

func move():
	if input_direction:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + input_direction*TILE_SIZE, 0.35)
			tween.tween_callback(move_false)
	
func move_false():
	moving = false
	play_idle()
	
func play_idle():
	if last_direction == Vector2.UP:
		animations.play("idle_up")
	elif last_direction == Vector2.DOWN:
		animations.play("idle_down")
	elif last_direction == Vector2.LEFT:
		animations.play("idle_left")
	elif last_direction == Vector2.RIGHT:
		animations.play("idle_right")
