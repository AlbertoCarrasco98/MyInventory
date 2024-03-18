import RealmSwift

class RealmDatabaseManager: DatabaseManagerProtocol {

    // Esta funcion se encarga de darme todos los inventarios guardados
    func getInventoryList() -> [InventoryModel] {
        let realm = try! Realm()
        let realmInventoryList = realm.objects(InventoryModelRealm.self)
        let mappedInventoryList = RealmMapper.map(realmInventoryList)
        return mappedInventoryList
    }

    // Esta funcion se encarga de darme un inventario en concreto a traves de su titulo
    func getInventoryByTitle(title: String) -> InventoryModel? {
        let realm = try! Realm()
        guard let inventoryRealm = realm.objects(InventoryModelRealm.self).where({ $0.title == title }).first
        else {
            return nil
        }
        return RealmMapper.map(inventory: inventoryRealm)
    }

    // Esta funcion se encarga de guardar un inventario. Si uso el .modified solo guarda la propiedad que haya cambiado en vez de todo el inventairo
    func save(_ inventory: InventoryModel) {
        let realm = try! Realm()
        let elements = List<ElementRealm>()
        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
        let updatedInventory = InventoryModelRealm(title: inventory.title,
                                                   elements: elements,
                                                   isFavorite: inventory.isFavorite,
                                                   isDeleted: inventory.isDeleted)
        do {
            try realm.write {
                realm.add(updatedInventory, update: .modified)
            }
        } catch {
            print("Error al guardar el inventario")
        }
    }

    // Esta funcion se encarga de borrar un inventario
    func deleteInventory(withTitle title: String) {
        let realm = try! Realm()
        let inventoriesToDelete = realm.objects(InventoryModelRealm.self).filter("title == %@", title) //Esta ultima parte sirve para comparar el titulo de los inventarios                                                                                                con el titulo del parametro
        if let inventoryToDelete = inventoriesToDelete.first {
            try? realm.write({
                realm.delete(inventoryToDelete)
            })
        }
    }
}














//    func createInventory(_ inventory: InventoryModel) {
//        let realm = try! Realm()
//        let inventoryRealm = RealmMapper.map(inventory: inventory)
//        try? realm.write({
//            realm.add(inventoryRealm)
//        })
//    }
//
//    func addElementToInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
//        let realm = try! Realm()
//        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
//            let newElement = ElementRealm()
//            newElement.title = elementTitle
//            try? realm.write({
//                inventory.elements.append(newElement)
//            })
//
//            let updatedInventory = RealmMapper.map(inventory: inventory)
//            return updatedInventory
//        } else {
//            return nil
//        }
//    }
//
//    // Leer todos los inventarios
//    func getInventoryList() -> [InventoryModel] {
//        let realm = try! Realm()
//        let realmInventoryList = realm.objects(InventoryModelRealm.self)
//        let mappedInventoryList = RealmMapper.map(realmInventoryList)
//        return mappedInventoryList
//    }
//
//    // Leer un inventario por su titulo
//    func getInventoryByTitle(title: String) -> InventoryModel? {
//        let realm = try! Realm()
//        let inventoryRealm = realm.objects(InventoryModelRealm.self).where { $0.title == title }.first
//        guard let inventoryRealm else {
//            return nil
//        }
//        return RealmMapper.map(inventory: inventoryRealm)
//    }
//
//    func deleteInventory(withTitle title: String) {
//        let realm = try! Realm()
//        let inventoriesToDelete = realm.objects(InventoryModelRealm.self).filter("title == %@", title) // Esta ultima parte sirve para comparar el titulo de los                                                                                                              inventarios con el titulo del parametro
//
//        if let inventoryToDelete = inventoriesToDelete.first {
//            try? realm.write({
//                realm.delete(inventoryToDelete.elements) // no haria falta porque es un objeto embebido
//                realm.delete(inventoryToDelete)
//            })
//        }
//    }
//
//    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel? {
//        let realm = try! Realm()
//        if let inventory = realm.objects(InventoryModelRealm.self).filter("title == %@", inventoryTitle).first {
//            for (index, element) in inventory.elements.enumerated() {
//                if element.title == elementTitle {
//                    try? realm.write({
//                        inventory.elements.remove(at: index)
//                        realm.delete(element)
//                    })
//                    break
//                }
//            }
//            let updatedInventory = RealmMapper.map(inventory: inventory)
//            return updatedInventory
//        } else {
//            return nil
//        }
//    }
//
//    func setFavorite(_ inventory: InventoryModel) {
//        let realm = try! Realm()
//        let elements = List<ElementRealm>()
//        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
//        let updatedInventory = InventoryModelRealm(title: inventory.title,
//                                                   elements: elements,
//                                                   isFavorite: inventory.isFavorite,
//                                                   isDeleted: inventory.isDeleted)
//        do {
//            try realm.write {
//                realm.add(updatedInventory, update: .modified)
//            }
//        } catch {
//            print("Error al cambiar la propiedad favorito del inventario")
//        }
//    }
//
//    func setDeleted(_ inventory: InventoryModel) {
//        let realm = try! Realm()
//        let elements = List<ElementRealm>()
//        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
//        let updatedInventory = InventoryModelRealm(title: inventory.title,
//                                                   elements: elements,
//                                                   isFavorite: inventory.isFavorite,
//                                                   isDeleted: inventory.isDeleted)
//        do {
//            try realm.write {
//                realm.add(updatedInventory, update: .modified)
//            }
//        } catch {
//            print("Error al cambiar la propiedad -isDeleted a true- del inventario")
//        }
//    }
//
//    func setUndeleted(_ inventory: InventoryModel) {
//        let realm = try! Realm()
//        let elements = List<ElementRealm>()
//        elements.append(objectsIn: RealmMapper.map(elements: inventory.elements))
//        let updatedInventory = InventoryModelRealm(title: inventory.title,
//                                                   elements: elements,
//                                                   isFavorite: inventory.isFavorite,
//                                                   isDeleted: inventory.isDeleted)
//        do {
//            try realm.write {
//                realm.add(updatedInventory, update: .modified)
//            }
//        } catch {
//            print("Error al cambiar la propiedad -isDeleted a false- del inventario")
//        }
//    }
//}
