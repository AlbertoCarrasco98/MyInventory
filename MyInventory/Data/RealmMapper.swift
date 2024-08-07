import RealmSwift

class RealmMapper {

    //    Mapear un array de [InventoryModelRealm] a un array de [InventoryModel]

    static func map(_ realmInventoryList: Results<InventoryModelRealm>) -> [InventoryModel] {
        var inventoryList: [InventoryModel] = []

        for realmInventory in realmInventoryList {
            var elementList: [InventoryModel.Element] = []

            for realmElement in realmInventory.elements {
                let elementModel = InventoryModel.Element(title: realmElement.title)
                elementList.append(elementModel)
            }
            let inventoryModel = InventoryModel(title: realmInventory.title,
                                                elements: elementList,
                                                isFavorite: realmInventory.isFavorite,
                                                isDeleted: realmInventory.isDeleted)
            inventoryList.append(inventoryModel)
        }
        return inventoryList
    }

    //    Mapear un InventoryModel a un InventoryModelRealm

    static func map(inventory: InventoryModel) -> InventoryModelRealm {
        let elementsRealm = List<ElementRealm>()
        elementsRealm.append(objectsIn: map(elements: inventory.elements))
        let inventoryRealm = InventoryModelRealm()
        inventoryRealm.title = inventory.title
        inventoryRealm.elements = elementsRealm
        inventoryRealm.isDeleted = inventory.isDeleted
        return inventoryRealm
    }

    //    Mapear un InventoryModel.Element (element individual) a un InventoryModelRealm.ElementRealm

    static func map(element: InventoryModel.Element) -> ElementRealm {
        let elementRealm = ElementRealm()
        elementRealm.title = element.title
        return elementRealm
    }

    //    Mapear un [InventoryModel.Element] (un array de muchos Element individuales) a un [InventoryModelRealm.ElementRealm]

    static func map(elements: [InventoryModel.Element]) -> [ElementRealm] {
        elements.map { element in
            let elementRealm = ElementRealm()
            elementRealm.title = element.title
            return elementRealm
        }
    }

    //    Mapear un InventoryModelRealm a un InventoryModel

    static func map(inventory: InventoryModelRealm) -> InventoryModel {
        let elementsModel = map(elements: inventory.elements)

        let inventoryModel = InventoryModel(title: inventory.title,
                                            elements: elementsModel,
                                            isFavorite: inventory.isFavorite,
                                            isDeleted: inventory.isDeleted)
        return inventoryModel
    }

    //    Mapear un InventoryModelRealm.ElementRealm (elementRealm individual) a un InventoryModel.Element

    static func map(element: ElementRealm) -> InventoryModel.Element {
        let elementModel = InventoryModel.Element(title: element.title)
        return elementModel
    }

    //    Mapear un [InventoryModelRealm.ElementRealm] (un array de muchos ElementRealm individuales) a un [InventoryModel.Element]

    static func map(elements: List<ElementRealm>) -> [InventoryModel.Element] {
        var mappedElements: [InventoryModel.Element] = []
        for element in elements {
            let elementInventoryModel = InventoryModel.Element(title: element.title)
            mappedElements.append(elementInventoryModel)
        }
        return mappedElements
    }
}
