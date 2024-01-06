import Foundation

struct InventoryModel {
    let title: String
    let elements: [Element]

    struct Element {
        let title: String
        let creationDate: Date = Date()
    }
}
