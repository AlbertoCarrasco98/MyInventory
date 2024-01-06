// En esta clase tengo que crear funcions que "mapeen" el modelo de inventario de Domain con el modelo de inventario de SwiftData y viceversa

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

    static func map(inventory: InventoryModelSwiftData) -> InventoryModel {
        
        return InventoryModel(title: inventory.title,
                              elements: map(elements: inventory.elements))

    }

    static func map(elements: [InventoryModelSwiftData.ElementSwiftData]) -> [InventoryModel.Element] {
        var elements: [InventoryModel.Element] = []
        for element in elements {
            let elementInventoryModel = InventoryModel.Element(title: element.title)
            elements.append(elementInventoryModel)
        }
        return elements
    }

//    static func map(element: InventoryModel.Element) -> InventoryModelSwiftData.ElementSwiftData {
//        return InventoryModelSwiftData.ElementSwiftData(title: element.title,
//                                                        date: element.creationDate)
//    }
}
