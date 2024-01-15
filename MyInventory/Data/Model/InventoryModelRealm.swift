import RealmSwift
import Foundation

class InventoryModelRealm: Object {
    @objc dynamic var title: String = ""
    var elements = List<ElementRealm>()

    class ElementRealm: Object {
        @objc dynamic var title: String = ""
        @objc dynamic var creationDate: Date = Date()
    }
}
