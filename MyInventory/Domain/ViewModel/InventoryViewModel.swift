import Foundation
import Combine

class InventoryViewModel: ObservableObject {

    var inventoryList: [InventoryModel] = []
    var databaseManager: DatabaseManagerProtocol

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }

    // MARK: - Signals
    // Sirve para avisar que hay cambios en el inventario, por lo que la vista se actualiza
    // Sirve para avisar de que se ha creado un nuevo inventario
    let newInventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDetailSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDeletedSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDidChangeSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()

    // MARK: - Functions

    func loadData() {
        inventoryList = databaseManager.getInventoryList()
    }

    func createNewInventory(title: String, elements: [String]) {
        let newInventory = InventoryModel(title: title, elements: elements)
        databaseManager.createInventory(newInventory)
        loadData()
        newInventorySignal.send()
    }

    func removeInventory(_ inventory: InventoryModel) {
        databaseManager.deleteInventory(withTitle: inventory.title)
        loadData()
        inventoryDeletedSignal.send()
    }

    func deleteElement(fromInventoryWithTitle inventoryTitle: String, elementTitle: String) {
        guard let updatedInventory = databaseManager.deleteElementFromInventory(inventoryTitle: inventoryTitle,
                                                                                elementTitle: elementTitle)
        else { return }
        loadData()
        inventoryDidChangeSignal.send(updatedInventory)
    }

    func createNewElement(elementTitle: String, for inventory: InventoryModel) {
        guard let updatedInventory = databaseManager.addElementToInventory(inventoryTitle: inventory.title,
                                                                           elementTitle: elementTitle)
        else { return }
        loadData()
        inventoryDidChangeSignal.send(updatedInventory)
    }
}

