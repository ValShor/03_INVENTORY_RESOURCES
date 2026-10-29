

extends CharacterBody2D

var speed = 40
@export var anim: AnimatedSprite2D
@export var hand: Sprite2D
@export var item_resources: ItemData

# Флаг для сидения вынесен в начало (в вашем коде он был на 31 строке)
var is_sitting = false

func _ready() -> void:
	Global.add_item(item_resources)

func _physics_process(_delta):
	# Получаем ввод (исправлено обрезанное название 'ui_left')
	var input = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	)
	
	velocity = input.normalized() * speed

	# Отмена расчета движения и т.д.
	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	
	if input.x > 0:
		anim.flip_h = false
	elif input.x < 0:
		anim.flip_h = true
		

	elif input.y < 0:
		anim.flip_v = false 

	# Переключение состояний анимации
	if input != Vector2.ZERO:
		anim.play('walk')
	else:
		anim.play('idle')
		
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('use_tool'):
		if Global.inventory.size() > 0:
			var item = Global.inventory[0]
			
			if item.is_tool:
				
				if hand.texture == null:
					hand.texture = item.icon
				
				else:
					hand.texture = null
	
	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
		else:
			is_sitting = true
			anim.play('sit')
	if event.is_action_pressed('next_item'):
		change_selection(1)
	if event.is_action_pressed('prev_item'):
		change_selection(-1)
	if event.is_action_pressed('drop_item'):
		drop_item()
var equipped_tool: ItemData
func change_selection(direction: int):
	if Global.inventory.size() == 0: return
	
	# Алгоритм зацикливания индекса
	Global.active_slot_index = (Global.active_slot_index + direction) % Global.inventory.size()
	if Global.active_slot_index < 0: Global.active_slot_index = Global.inventory.size() - 1
	Global.update_selection_visual.emit()
	update_hand_visual()
	
func update_hand_visual():
	var item = Global.inventory[Global.active_slot_index]
	if item:
		hand.texture = item.icon
		equipped_tool = item if item.is_tool else null
	else:
		hand.texture = null
		equipped_tool = null
# Пишем, что при нажаии ЛКМ - присваиваем equipped_tool, текущий инструмент
@export var item_world_scene: PackedScene

func drop_item():
	if Global.inventory.size() > 0:
		var item_to_drop = Global.inventory[Global.active_slot_index]
		Global.inventory.remove_at(Global.active_slot_index)
		
		# Спавним предмет в мире
		spawn_dropped_item(item_to_drop)
		
		# Корректируем индекс и обновляем всё
		Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
		Global.inventory_updated.emit()
		update_hand_visual()

func spawn_dropped_item(item_to_drop: ItemData):
	var new_item = item_world_scene.instantiate()
	
	new_item.item_resources = item_to_drop
	
	var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	new_item.position = self.position + random_offset
	
	get_tree().current_scene.add_child(new_item)
