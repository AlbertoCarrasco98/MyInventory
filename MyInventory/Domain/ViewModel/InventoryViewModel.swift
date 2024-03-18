import UIKit
import Combine

class InventoryViewModel: ObservableObject {

    var inventoryList: [InventoryModel] = []
    var databaseManager: DatabaseManagerProtocol

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }

    // MARK: - Signals
    // Sirven para avisar que hay cambios en el inventario, por lo que la vista se actualiza

    let newInventorySignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDetailSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDeletedSignal: PassthroughSubject<Void, Error> = PassthroughSubject()
    let inventoryDidChangeSignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()

    let updatedInventorySignal: PassthroughSubject<InventoryModel, Error> = PassthroughSubject()

    // MARK: - Functions

    func loadData() {
        inventoryList = databaseManager.getInventoryList()
    }

    func createNewInventory(title: String, elements: [String]) -> Result<Void, CustomError> {
        guard !inventoryList.contains(where: { $0.title == title }) else {
            return .failure(CustomError.failure("Ya existe un inventario con ese título"))
        }
        let newInventory = InventoryModel(title: title, elements: elements)
        databaseManager.save(newInventory)
        loadData()
        newInventorySignal.send()
        return .success(())
    }

    func removeInventory(_ inventory: InventoryModel) {
        databaseManager.deleteInventory(withTitle: inventory.title)
        loadData()
        inventoryDeletedSignal.send()
    }

    func borrarUnElementoDeUnInventario(title: String, inventory: InventoryModel) {
        var mutableInventory = inventory

        for (index, element) in mutableInventory.elements.enumerated() {
            if element.title == title {
                mutableInventory.elements.remove(at: index)
                databaseManager.save(mutableInventory)
            }
        }
        inventoryDidChangeSignal.send(mutableInventory)
    }

    func newElement(from inventory: InventoryModel, elementTitle: String) {
        let element = InventoryModel.Element(title: elementTitle)
        var updatedInventory = InventoryModel(title: inventory.title,
                                              elements: inventory.elements,
                                              isFavorite: inventory.isFavorite,
                                              isDeleted: inventory.isDeleted)
        updatedInventory.elements.append(element)
        databaseManager.save(updatedInventory)
        inventoryDidChangeSignal.send(updatedInventory)
    }

    func updateIsFavorite(in inventory: InventoryModel) {
        var mutableInventory = inventory
        mutableInventory.isFavorite.toggle()
        let updatedInventory = InventoryModel(title: mutableInventory.title,
                                              elements: mutableInventory.elements,
                                              isFavorite: mutableInventory.isFavorite,
                                              isDeleted: mutableInventory.isDeleted)
        databaseManager.save(updatedInventory)
        loadData()
        inventoryDidChangeSignal.send(updatedInventory)
    }

    func updateIsDeleted(in inventory: InventoryModel) {
        let updatedInventory = InventoryModel(title: inventory.title,
                                              elements: inventory.elements,
                                              isFavorite: inventory.isFavorite,
                                              isDeleted: !inventory.isDeleted)
        databaseManager.save(updatedInventory)
        inventoryDidChangeSignal.send(updatedInventory)
    }
}
