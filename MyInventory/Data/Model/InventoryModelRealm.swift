import RealmSwift
import Foundation

//@objcMembers class InventoryModelRealm: Object {
//
//    dynamic var title: String = ""
//    var elements = List<ElementRealm>()
//    dynamic var isFavorite: Bool = false
//
//    override class func primaryKey() -> String? {
//        "title"
//    }
//
//    @objc(ElementRealm)
//    class ElementRealm: Object {
//        @objc dynamic var title: String = ""
//        @objc dynamic var creationDate: Date = Date()
//
//        override init() {
//            super.init()
//        }
//
//        convenience init(title: String) {
//            self.init()
//            self.title = title
//        }
//    }
//}

class InventoryModelRealm: Object {

    @Persisted(primaryKey: true) var title: String = ""
    @Persisted var elements: List<ElementRealm> = List()
    @Persisted var isFavorite: Bool = false

    convenience init(title: String, elements: List<ElementRealm>, isFavorite: Bool) {
        self.init()
        self.title = title
        self.elements = elements
        self.isFavorite = isFavorite
    }
}

class ElementRealm: Object {
    @Persisted var title: String = ""
    @Persisted var creationDate: Date = Date()

    convenience init(title: String, creationDate: Date) {
        self.init()
        self.title = title
        self.creationDate = creationDate
    }
}
