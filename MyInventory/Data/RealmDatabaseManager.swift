import RealmSwift

class RealmDatabaseManager {

    private var realm: Realm {
        return try! Realm()
    }

    func createInventory(_ inventory: Object) {
        try? realm.write({
            realm.add(inventory)
        })
    }

    func addElementToInventory(inventoryTitle: String, elementTitle: String) {
        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
            let newElement = InventoryModelRealm.ElementRealm()
            newElement.title = elementTitle
            try? realm.write({
                inventory.elements.append(newElement)
            })
        }
    }

        // Leer todos los inventarios
    func getInventoryList() -> Results<InventoryModelRealm> {
        return realm.objects(InventoryModelRealm.self)
    }

        // Leer un inventario por su titulo
    func getInventoryByTitle(title: String) -> InventoryModelRealm? {
        return realm.objects(InventoryModelRealm.self).filter("title == %@", title).first
    }

        // Actualizar el titulo de un inventario
    func updateInventoryTitle(inventory: InventoryModelRealm, newTitle: String) {
        try? realm.write({
            inventory.title = newTitle
        })
    }

    func deleteInventory(withTitle title: String) {
        let inventoriesToDelete = realm.objects(InventoryModelRealm.self).filter("title == %@", title) // Esta ultima parte sirve para comparar el titulo de los inventarios con el titulo del parametro

        if let inventoryToDelete = inventoriesToDelete.first {
            try? realm.write({
                realm.delete(inventoryToDelete.elements)
                realm.delete(inventoryToDelete)
            })
        }
    }

    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) {
        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
            for (index, element) in inventory.elements.enumerated() {
                if element.title == elementTitle {
                    try? realm.write({
                        inventory.elements.remove(at: index)
                        realm.delete(element)
                    })
                    break
                }
            }
        }
    }
}
