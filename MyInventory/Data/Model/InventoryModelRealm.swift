import RealmSwift
import Foundation

class InventoryModelRealm: Object {

    @Persisted(primaryKey: true) var title: String = ""
    @Persisted var elements: List<ElementRealm> = List()
    @Persisted var isFavorite: Bool = false
    @Persisted var isDeleted: Bool = false

    convenience init(title: String, elements: List<ElementRealm>, isFavorite: Bool, isDeleted: Bool) {
        self.init()
        self.title = title
        self.elements = elements
        self.isFavorite = isFavorite
        self.isDeleted = isDeleted
    }
}

class ElementRealm: EmbeddedObject {
    @Persisted var title: String = ""
    @Persisted var creationDate: Date = Date()

    convenience init(title: String, creationDate: Date) {
        self.init()
        self.title = title
        self.creationDate = creationDate
    }
}
