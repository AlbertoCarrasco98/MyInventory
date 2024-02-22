import Foundation

struct InventoryModel {
    let title: String
    var elements: [Element]
    var isFavorite: Bool

    init(title: String, elements: [Element], isFavorite: Bool) {
        self.title = title
        self.elements = elements
        self.isFavorite = isFavorite
    }

    init(title: String, elements: [String], isFavorite: Bool = false) {
        let mappedElements: [InventoryModel.Element] = elements.map { element in
            InventoryModel.Element(title: element)
        }
        self.title = title
        self.elements = mappedElements
        self.isFavorite = isFavorite
    }

    struct Element {
        let title: String
        let creationDate: Date = Date()
    }
}
