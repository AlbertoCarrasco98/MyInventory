import Foundation
import Combine

class InventoryViewModel: ObservableObject {

    var inventoryList: [InventoryModel] = []
    var databaseManager = RealmDatabaseManager()

    init(databaseManager: RealmDatabaseManager) {
        self.databaseManager = databaseManager

    }

    // MARK: - Signals
    // Sirve para avisar que hay cambios en el inventario, por lo que la vista se actualiza
    //let inventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    // Sirve para avisar de que se ha creado un nuevo inventario
    let newInventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDetailSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDeletedSignal: PassthroughSubject<Void, Error> = PassthroughSubject() // Que hace esta señal?? (Renombrar)

    let newElementSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()
    let elementDeletedSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()

//    init(databaseManager: DatabaseManager) {
//        self.databaseManager = databaseManager
//    }

    // MARK: - Functions

    func loadData() {
        let realmInventoryList = databaseManager.getInventoryList()
        let inventoryModelList = RealmMapper.map(realmInventoryList)
        inventoryList = inventoryModelList
        }

    func createNewInventory(title: String, elements: [String]) {
        let mappedElements: [InventoryModel.Element] = elements.map { element in
            InventoryModel.Element(title: element)
        }
        let newInventory = InventoryModel(title: title, elements: mappedElements)
        databaseManager.createInventory(RealmMapper.map(inventory: newInventory))
        loadData()
        newInventorySignal.send()
    }

    func removeInventory(inventory: InventoryModel) {
        databaseManager.deleteInventory(withTitle: inventory.title)
        loadData()
        inventoryDeletedSignal.send()
    }

    func deleteElement(fromInventoryWithTitle inventoryTitle: String, elementTitle: String) {
        guard let updatedInventory = databaseManager.deleteElementFromInventory(inventoryTitle: inventoryTitle, elementTitle: elementTitle) else { return }
        loadData()
        elementDeletedSignal.send(updatedInventory)

//        inventoryList = databaseManager.getInventoryList()
//        if let updatedInventory = inventoryList.first(where: { $0.title == inventoryTitle }) {
//            elementDeletedSignal.send(updatedInventory)
//        }
    }

    func createNewElement(elementTitle: String, for inventory: InventoryModel) {

        guard let updatedInventory = databaseManager.addElementToInventory(inventoryTitle: inventory.title,
                                                                           elementTitle: elementTitle) else { return }

//        guard let updatedInventory = databaseManager.addElementToInventory(inventoryTitle: inventory.title,
//                                                                           elementTitle: elementTitle) else { return }
        loadData()
        newElementSignal.send(updatedInventory)
    }
}

