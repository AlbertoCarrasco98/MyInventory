import Foundation

protocol DatabaseManagerProtocol {
    func createInventory(_ inventory: InventoryModel)
    func addElementToInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel?
    func getInventoryList() -> [InventoryModel]
    func getInventoryByTitle(title: String) -> InventoryModel?
    func deleteInventory(withTitle title: String)
    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel?
}
