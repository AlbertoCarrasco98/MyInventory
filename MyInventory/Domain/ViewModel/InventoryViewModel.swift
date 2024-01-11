import Foundation
import Combine

class InventoryViewModel: ObservableObject {

    var inventoryList: [InventoryModel] = []
    let databaseManager: DatabaseManager

    // MARK: - Signals
    // Sirve para avisar que hay cambios en el inventario, por lo que la vista se actualiza
    //let inventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    // Sirve para avisar de que se ha creado un nuevo inventario
    let newInventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDetailSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDeletedSignal: PassthroughSubject<Void, Error> = PassthroughSubject() // Que hace esta señal?? (Renombrar)

    let newElementSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()
    let elementDeletedSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()

    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }

    // MARK: - Functions

    func loadData() {
        inventoryList = databaseManager.getInventoryList()
    }

    func createNewInventory(title: String, elements: [String]) {

        let mappedElements: [InventoryModel.Element] = elements.map { element in
            InventoryModel.Element(title: element)
        }

        let newInventory = InventoryModel(title: title, elements: mappedElements)
        databaseManager.saveInventory(inventory: newInventory)
        loadData()
        newInventorySignal.send()
    }

    func removeInventory(inventory: InventoryModel) {
        databaseManager.removeInventory(inventory: inventory)
        loadData()
        inventoryDeletedSignal.send()
    }

    func deleteElement(fromInventoryWithTitle inventoryTitle: String, elementTitle: String) {
        databaseManager.deleteElement(fromInventoryWithTitle: inventoryTitle, elementTitle: elementTitle)
        inventoryList = databaseManager.getInventoryList()
        if let updatedInventory = inventoryList.first(where: { $0.title == inventoryTitle }) {
            elementDeletedSignal.send(updatedInventory)
        }
    }

    func createNewElement(elementTitle: String, for inventory: InventoryModel) {
        guard let updatedInventory = databaseManager.createNewElement(elementTitle: elementTitle, for: inventory) else { return }
        loadData()
        newElementSignal.send(updatedInventory)
    }
}

