import Foundation

protocol DatabaseManagerProtocol {
    func getInventoryList() -> [InventoryModel]
    func getInventoryByTitle(title: String) -> InventoryModel?
    func save(_ inventory: InventoryModel)
    func deleteInventory(withTitle title: String)
}
