// En esta clase tengo que crear funciones que "mapeen" el modelo de inventario de Domain con el modelo de inventario de SwiftData y viceversa

class Mapper {

    static func map(inventory: InventoryModel) -> InventoryModelSwiftData {
        return InventoryModelSwiftData(title: inventory.title,
                                       elements: map(elements: inventory.elements))
    }

    static func map(elements: [InventoryModel.Element]) -> [InventoryModelSwiftData.ElementSwiftData] {
        var elementsSwiftData: [InventoryModelSwiftData.ElementSwiftData] = []
        for element in elements {
            let elementSwiftData = InventoryModelSwiftData.ElementSwiftData(title: element.title,
                                                                            date: element.creationDate)
            elementsSwiftData.append(elementSwiftData)
        }
        return elementsSwiftData
    }

    static func map(element: InventoryModel.Element) -> InventoryModelSwiftData.ElementSwiftData {
        let elementSwiftData = InventoryModelSwiftData.ElementSwiftData(title: element.title,
                                                                        date: element.creationDate)
        return elementSwiftData
    }

    static func map(inventory: InventoryModelSwiftData) -> InventoryModel {
        fatalError("Deprecated")
        return InventoryModel(title: inventory.title,
                              elements: map(elements: inventory.elements),
                              isFavorite: true)
    }

    static func map(elements: [InventoryModelSwiftData.ElementSwiftData]) -> [InventoryModel.Element] {
        var mappedElements: [InventoryModel.Element] = []
        for element in elements {
            let elementInventoryModel = InventoryModel.Element(title: element.title)
            mappedElements.append(elementInventoryModel)
        }
        return mappedElements
    }
}
