import RealmSwift

class RealmDatabaseManager: DatabaseManagerProtocol {

    func createInventory(_ inventory: InventoryModel) {
        let realm = try! Realm()
        let inventoryRealm = RealmMapper.map(inventory: inventory)
        try? realm.write({
            realm.add(inventoryRealm)
        })
    }

    func addElementToInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
        let realm = try! Realm()
        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
            let newElement = ElementRealm()
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
        let realm = try! Realm()
        let realmInventoryList = realm.objects(InventoryModelRealm.self)
        let mappedInventoryList = RealmMapper.map(realmInventoryList)
        return mappedInventoryList
    }

    // Leer un inventario por su titulo
    func getInventoryByTitle(title: String) -> InventoryModel? {
        let realm = try! Realm()
        let inventoryRealm = realm.objects(InventoryModelRealm.self).where { $0.title == title }.first
        guard let inventoryRealm else {
            return nil
        }
        return RealmMapper.map(inventory: inventoryRealm)
    }

    func deleteInventory(withTitle title: String) {
        let realm = try! Realm()
        let inventoriesToDelete = realm.objects(InventoryModelRealm.self).filter("title == %@", title) // Esta ultima parte sirve para comparar el titulo de los inventarios con el titulo del parametro

        if let inventoryToDelete = inventoriesToDelete.first {
            try? realm.write({
                realm.delete(inventoryToDelete.elements)
                realm.delete(inventoryToDelete)
            })
        }
    }

    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
        let realm = try! Realm()
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

    func setFavorite(_ inventory: InventoryModel) {
        let realm = try! Realm()
        let elements = List<ElementRealm>()
        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
        let updatedInventory = InventoryModelRealm(title: inventory.title,
                                                   elements: elements,
                                                   isFavorite: inventory.isFavorite)
        do {
            try realm.write {
                realm.add(updatedInventory, update: .modified)
            }
        } catch {
            print("Error al cmabiar la propiedad favorito del inventario")
        }
    }
}

//    func updateInventory(_ inventory: InventoryModel) {
//        let realm = try! Realm()
//
//        let elements = List<ElementRealm>()
//        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
//        let updatedInventory = InventoryModelRealm(title: inventory.title,
//                                                   elements: elements,
//                                                   isFavorite: inventory.isFavorite)
//
//        do {
//            try realm.write {
//                realm.add(updatedInventory, update: .modified)
//            }
//        } catch {
//            print("Me cago en tu puta madre envuelta en papel glass")
//        }
//    }

