import Foundation

struct InventoryModel {
    let title: String
    var elements: [Element]
    var isFavorite: Bool
    var isDeleted: Bool

    init(title: String, elements: [Element], isFavorite: Bool, isDeleted: Bool) {
        self.title = title
        self.elements = elements
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
    }

    init(title: String, elements: [String], isFavorite: Bool = false, isDeleted: Bool = false) {
        let mappedElements: [InventoryModel.Element] = elements.map { element in
            InventoryModel.Element(title: element)
        }
        self.title = title
        self.elements = mappedElements
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
    }

    struct Element {
        let title: String
        let creationDate: Date = Date()
    }
}
