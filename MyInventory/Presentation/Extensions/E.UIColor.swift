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
    
    func getRGBComponents() -> (red: CGFloat,
                                green: CGFloat,
                                blue: CGFloat,
                                alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let success = self.getRed(&red,
                                  green: &green,
                                  blue: &blue,
                                  alpha: &alpha)
        
        if success {
            return (red,
                    green,
                    blue,
                    alpha)
        }
        return nil
    }
}
