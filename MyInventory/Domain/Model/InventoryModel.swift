import Foundation

struct InventoryModel {
    let title: String
    var elements: [Element]

    struct Element {
        let title: String
        let creationDate: Date = Date()
    }
}
