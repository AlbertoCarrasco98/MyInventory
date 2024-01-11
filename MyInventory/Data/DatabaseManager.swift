import SwiftData
import Foundation

class RealmDatabaseManager {

}
class DatabaseManager {

    private let container: ModelContainer
    private let context: ModelContext

    init() {
        self.container = try! ModelContainer(for: InventoryModelSwiftData.self,
                                             InventoryModelSwiftData.ElementSwiftData.self)
        self.context = ModelContext(container)
    }

    // MARK: - Functions

    func getInventoryList() -> [InventoryModel] {   // Dame los inventarios de base de datos
        let fetchDescriptor = FetchDescriptor<InventoryModelSwiftData>()
        do {
            let result = try context.fetch(fetchDescriptor)
            let mappedInventoryModel = result.map { (inventory: InventoryModelSwiftData) in
                let mappedElements = inventory.elements.map { (element: InventoryModelSwiftData.ElementSwiftData) in
                    InventoryModel.Element(title: element.title)
                }
                return InventoryModel(title: inventory.title, elements: mappedElements)
            }
            return mappedInventoryModel
        } catch {
            return []
        }
    }

    private func getInventory(withTitle title: String) throws -> InventoryModelSwiftData? {     // Busca y devuelve un solo inventario basado en un titulo especifico
        do {
            let predicate = #Predicate<InventoryModelSwiftData> { model in
                model.title == title
            }

            let descriptor = FetchDescriptor(predicate: predicate)
            let object = try context.fetch(descriptor)
            return object.first
        } catch {
            print("No existe inventario con ese titulo")
        }
        return nil
    }

    func createNewElement(elementTitle: String, for inventory: InventoryModel) -> InventoryModel? {
        guard let inventory = try? getInventory(withTitle: inventory.title) else { return nil }
        let element = InventoryModelSwiftData.ElementSwiftData(title: elementTitle)
        inventory.elements.append(element)
        let updatedInventory = inventory
        context.insert(updatedInventory)
        try? context.save()
        return Mapper.map(inventory: updatedInventory)
    }

    func saveInventory(inventory: InventoryModel) {   // Guarda los inventaios en base de datos
        let inventoryModelSwiftData = Mapper.map(inventory: inventory)
        context.insert(inventoryModelSwiftData)
        try? context.save()
    }

    func removeInventory(inventory: InventoryModel) {
        let previousInventoryList = getInventoryList()
//        print(previousInventoryList)
        do {
            guard let inventoryToDelete = try getInventory(withTitle: inventory.title) else { return }
            context.delete(inventoryToDelete)
            try context.save()
            let currentInventoryList = getInventoryList()
//            print("----")
//            print(currentInventoryList)
        } catch {
            print("No se ha podido borrar el inventario")
        }
    }

    func deleteElement(fromInventoryWithTitle inventoryTitle: String, elementTitle: String) {
        do {
            // 1. Encontrar el inventario especifico por su titulo
            guard let inventory = try? getInventory(withTitle: inventoryTitle) else {
                print("Inventario no encontrado")
                return
            }
            // 2. Encuentra el elemento especifico por su titulo y eliminalo
            if let elementIndex = inventory.elements.firstIndex(where: { $0.title == elementTitle }) {
                inventory.elements.remove(at: elementIndex)

                // 3. Guardar cambios en base de datos
                try? context.save()
            } else {
                print("Elemento no encontrado en el inventario")
            }
        } catch {
            print("Error al eliminar el elemento: \(CustomError.databaseError)")
        }
    }

//    func removeElementFromInventory(element: InventoryModel.Element) {
//        do {
//            guard let elementToDelete = try getElementsFromInventory(elementTitle: element.title) else { return }
//            context.delete(elementToDelete)
//            try context.save()
//        } catch {
//            print("No se ha podido borrar el elemento del inventario")
//        }
//    }



    func getElementsFromInventory(elementTitle: String) throws -> InventoryModelSwiftData.ElementSwiftData? {
        do {
            let predicate = #Predicate<InventoryModelSwiftData.ElementSwiftData> { model in
                model.title == elementTitle
            }

            let descriptor = FetchDescriptor(predicate: predicate)
            let object = try context.fetch(descriptor)
            return object.first

        } catch {
            print("No existe un elemento con ese titulo")
        }
        return nil
    }
}

// MARK: - Coche
//
// Domain
//struct Coche {
//    let color: String
//    let combustible: String
//    let matricula: Int
//    let ruedas: [Rueda]
//}
//
//struct Rueda {
//    let isAleation: Bool
//}
//
// Data
//import SwiftData
//@Model
//struct CocheData {
//    let color: String
//    let combustible: String
//    @Attribute(.unique)
//    let matricula: Int
//    let ruedas: [RuedaData]
//
//    init(color: String, combustible: String, matricula: Int, ruedas: [RuedaData]) {
//        self.color = color
//        self.combustible = combustible
//        self.matricula = matricula
//        self.ruedas = ruedas
//    }
//}
//
//@Model
//struct RuedaData {
//    let isAleation: Bool
//
//    init(isAleation: Bool) {
//        self.isAleation = isAleation
//    }
//}
//
// Mapper
//struct CocheMapper {
//
//    static func map(cocheData: CocheData) -> Coche {
//        return Coche(color: cocheData.color,
//                     combustible: cocheData.combustible,
//                     matricula: cocheData.matricula,
//                     ruedas: map(ruedasData: cocheData.ruedas))
//    }
//
//    static func map(coche: Coche) -> CocheData {
//        return CocheData(color: coche.color,
//                         combustible: coche.combustible,
//                         matricula: coche.matricula,
//                         ruedas: map(ruedas: coche.ruedas))
//    }
//
//    static func map(ruedas: [Rueda]) -> [RuedaData] {
//        //        var ruedasData: [RuedaData] = []
//        //        for rueda in ruedas {
//        //            let ruedaData = RuedaData(isAleation: rueda.isAleation)
//        //            ruedasData.append(ruedaData)
//        //        }
//        //        return ruedasData
//
//        //        var ruedasData: [RuedaData] = []
//        //        ruedas.forEach { rueda in
//        //            let ruedaData = RuedaData(isAleation: rueda.isAleation)
//        //            ruedasData.append(ruedaData)
//        //        }
//
//        ruedas.map { RuedaData(isAleation: $0.isAleation) }
//
//    }
//
//    static func map(ruedasData: [RuedaData]) -> [Rueda] {
//        var ruedas: [Rueda] = []
//        for ruedaData in ruedasData {
//            let rueda = Rueda(isAleation: ruedaData.isAleation)
//            ruedas.append(rueda)
//        }
//        return ruedas
//    }
//}
//
//class CocheDatabaseManager {
//
//    let container: ModelContainer
//    let context: ModelContext
//
//    init() {
//        self.container = try! ModelContainer(for: CocheData.self, RuedaData.self)
//        self.context = ModelContext(container)
//    }
//
//    func getCocheList() -> [Coche] {
//        let fetchDescriptor = FetchDescriptor<CocheData>()
//        do {
//            let result = try context.fetch(fetchDescriptor)
//            var cocheList: [Coche] = []
//            for cocheData in result {
//                let coche = CocheMapper.map(cocheData: cocheData)
//                cocheList.append(coche)
//            }
//            return cocheList
//
//        } catch {
//            return []
//        }
//    }
//
//    func saveCoche(coche: Coche) {
//        //        1. Convertir "Coche" al tipo de la base de datos "CocheData"
//        let cocheData = CocheMapper.map(coche: coche)
//
//        //        2. Insertar el objeto en el ModelContext
//        context.insert(cocheData)
//
//        //        3. Guardar el ModelContext
//        try? context.save()
//    }
//}
