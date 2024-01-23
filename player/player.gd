extends CharacterBody2D

class_name Player

signal health_changed

@export var speed: int = 50
@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurt_box = $HurtBox
@onready var hurt_timer = $HurtTimer

@export var max_health = 3
var health: int = max_health

@export var knockback_power: int = 5000

var is_hurt: bool = false


func _ready():
	effects.play("RESET")


func handle_input():
	#var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var left = Input.get_action_strength("ui_left")
	var right = Input.get_action_strength("ui_right")
	var up = Input.get_action_strength("ui_up")
	var down = Input.get_action_strength("ui_down")
	# print("left: ", left, ", right: ", right, ", up: ", up, ", down: ", down)
	var horizontal = right - left
	var vertical = down - up
	
	var moveDirection = Vector2(horizontal, vertical).normalized()
	
	velocity = moveDirection * speed
	#print(moveDirection)
	

func update_animation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "down"
		
		if   velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animations.play("walk_" + direction)
	

func handle_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)


func _physics_process(delta):
	handle_input()
	move_and_slide()
	handle_collision()
	update_animation()
	if !is_hurt:
		for area in hurt_box.get_overlapping_areas():
			if area.name == "HitBox":
				hurt_by_enemy(area)


func hurt_by_enemy(area):
	health -= 1
	if health < 0:
		health = max_health
	
	health_changed.emit(health)
	is_hurt = true
	
	knockback(area.get_parent().velocity)
	effects.play("hurt_blink")
	hurt_timer.start()
	await hurt_timer.timeout
	effects.play("RESET")
	is_hurt = false
	

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect()


func _on_hurt_box_area_exited(area):
	pass
	
	
func knockback(enemy_velocity):
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	print_debug(velocity)
	print_debug(position)
	move_and_slide()
	print_debug(position)
	print_debug(" ")



