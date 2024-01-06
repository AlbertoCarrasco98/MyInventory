import Foundation
import SwiftData

// Como sera el modelo que va a manejar SwiftData

// Sirve para poder trabajar con el mismo modelo de datos que tengo en dominio, el dataBaseManager se encargara de guardar los datos segun este modelo y de mapear los datos para que dominio pueda trabajar con ellos

@Model
class InventoryModelSwiftData {
    @Attribute(.unique)  // Hace que no pueda haber mas de un inventario con el mismo title
    let title: String
    @Relationship(deleteRule: .cascade)  // Cuando elimine un inventario tambien se eliminaran todos sus elementos de la bsase de datos
    let elements: [ElementSwiftData]

    init(title: String, elements: [ElementSwiftData]) {
        self.title = title
        self.elements = elements
    }

    @Model
    class ElementSwiftData {
        let title: String
        let date: Date

        init(title: String, date: Date) {
            self.title = title
            self.date = date
        }
    }
}

extension InventoryModelSwiftData: Equatable {

}
