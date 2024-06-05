import UIKit

extension UIColor {
    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self,
                                                 requiringSecureCoding: false)
    }

    static func fromData(_ data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: self,
                                                       from: data)
    }





    

//    static func fromData2(_ data: Data) throws -> UIColor? {
//        do {
//            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: self,
//                                                               from: data)
//            return color
//        } catch {
//            throw error
//        }
//    }
//
//    static func a() {
//        let color1 = fromData(Data())
//        do {
//            let color2 = try fromData2(Data())
//        } catch {
//            return nil
//        }
//
//    }
}

