import UIKit
import Combine

class InventoryViewModel: ObservableObject {

    var inventoryList: [InventoryModel] = []
    var filteredInventories: [InventoryModel] = []
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
        filteredInventories = inventoryList
    }

    func createNewInventory(title: String, elements: [String]) -> Result<Void, CustomError> {
        guard !inventoryList.contains(where: { $0.title == title }) else {
            return .failure(CustomError.failure("Ya existe un inventario con ese título"))
        }
        let newInventory = InventoryModel(title: title, elements: elements)
        databaseManager.createInventory(newInventory)
        loadData()
        newInventorySignal.send()
        return .success(())
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

