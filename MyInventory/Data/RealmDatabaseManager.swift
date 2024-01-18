import RealmSwift

class RealmDatabaseManager: DatabaseManagerProtocol {

    private var realm: Realm {
        return try! Realm()
    }

    func createInventory(_ inventory: InventoryModel) {
        let inventoryRealm = RealmMapper.map(inventory: inventory)
        try? realm.write({
            realm.add(inventoryRealm)
        })
    }

    func addElementToInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
            let newElement = InventoryModelRealm.ElementRealm()
            newElement.title = elementTitle
            try? realm.write({
                inventory.elements.append(newElement)
            })

            let updatedInventory = RealmMapper.map(inventory: inventory)
            return updatedInventory
        } else {
            return nil
        }
    }

        // Leer todos los inventarios
    func getInventoryList() -> [InventoryModel] {
        let realmInventoryList = realm.objects(InventoryModelRealm.self)
        return RealmMapper.map(realmInventoryList)
    }

        // Leer un inventario por su titulo
    func getInventoryByTitle(title: String) -> InventoryModel? {
        let inventoryRealm = realm.objects(InventoryModelRealm.self).where { $0.title == title }.first
        guard let inventoryRealm else {
            return nil
        }
        return RealmMapper.map(inventory: inventoryRealm)
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

    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
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
            let updatedInventory = RealmMapper.map(inventory: inventory)
            return updatedInventory
        } else {
            return nil
        }
    }
}
