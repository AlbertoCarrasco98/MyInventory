import RealmSwift
import Foundation

@objcMembers class InventoryModelRealm: Object {
    dynamic var title: String = ""
    let elements = List<ElementRealm>()

    override init() {
        super.init()
    }

    convenience init(title: String, elements: List<ElementRealm>) {
        self.init()
        self.title = title
        self.elements.append(objectsIn: elements)
    }

    @objc(ElementRealm)
    class ElementRealm: Object {
        @objc dynamic var title: String = ""
        @objc dynamic var creationDate: Date = Date()

        override init() {
            super.init()
        }

        convenience init(title: String) {
            self.init()
            self.title = title
        }
    }
}
