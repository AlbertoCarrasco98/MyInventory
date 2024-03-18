import Foundation

protocol DatabaseManagerProtocol {
//    func createInventory(_ inventory: InventoryModel)
//    func addElementToInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel?
//    func getInventoryList() -> [InventoryModel]
//    func getInventoryByTitle(title: String) -> InventoryModel?
//    func deleteInventory(withTitle title: String)
//    func deleteElementFromInventory(inventoryTitle: String, elementTitle: String) -> InventoryModel?
//    func setFavorite(_ inventory: InventoryModel)
//    func setDeleted(_ inventory: InventoryModel)
//    func setUndeleted(_ inventory: InventoryModel)

    func getInventoryList() -> [InventoryModel]
    func getInventoryByTitle(title: String) -> InventoryModel?
    func save(_ inventory: InventoryModel)
    func deleteInventory(withTitle title: String)
}
