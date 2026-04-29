extends Node

var items: Dictionary = {}

func add_item(item: ItemData, amount: int = 1) -> void:
	if items.has(item):
		items[item] += amount
	else:
		items[item] = amount 
	
	print(item.name, " eklendi. Mevcut miktar: ", items[item])

func remove_item(item: ItemData, amount: int = 1) -> void:
	if items.has(item):
		items[item] -= amount
		if items[item] <= 0:
			items.erase(item)
			print(item.name, " envanterden bitti/silindi.")
