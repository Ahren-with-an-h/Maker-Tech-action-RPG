extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]
@export var max_amount: int = 10


func insert(item: InventoryItem):
	for slot in slots: 
		if slot.item == item and slot.amount < max_amount:
			slot.amount += 1
			updated.emit()
			return
	
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			return
			
	
