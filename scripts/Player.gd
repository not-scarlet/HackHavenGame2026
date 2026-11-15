extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var player_enabled = false
@export var sprite_cat = Texture2D

func _ready() -> void:
	swap_spritesheet_texture(sprite_cat)
	$AnimatedSprite2D.play()
	

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func swap_spritesheet_texture(new_sheet: Texture2D) -> void:
	# Duplicate the SpriteFrames resource so you don't overwrite other instances
	var new_frames: SpriteFrames = anim_sprite.sprite_frames.duplicate(true)
	
	for anim_name in new_frames.get_animation_names():
		var frame_count: int = new_frames.get_frame_count(anim_name)
		for i in range(frame_count):
			var frame_tex: Texture2D = new_frames.get_frame_texture(anim_name, i)
			# Replace the underlying image of the AtlasTexture
			if frame_tex is AtlasTexture:
				frame_tex.atlas = new_sheet
				
	anim_sprite.sprite_frames = new_frames


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("SwapPlayer"):
		player_enabled = not player_enabled
	if not player_enabled:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
