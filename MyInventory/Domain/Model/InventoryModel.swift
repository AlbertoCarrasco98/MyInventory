import Foundation

struct InventoryModel {
    let title: String
    var elements: [Element]

    init(title: String, elements: [Element]) {
        self.title = title
        self.elements = elements
    }

    init(title: String, elements: [String]) {
        let mappedElements: [InventoryModel.Element] = elements.map { element in
            InventoryModel.Element(title: element)
        }
        self.title = title
        self.elements = mappedElements
    }

    struct Element {
        let title: String
        let creationDate: Date = Date()
    }
}
