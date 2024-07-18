import UIKit

extension UIColor {

    var lightModeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var darkModeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }

    static func make(fromLightColorModel lightColor: ColorModel, darkColorModel darkColor: ColorModel) -> UIColor {
        UIColor {
            $0.userInterfaceStyle == .dark
            ? UIColor(red: darkColor.red,
                      green: darkColor.green,
                      blue: darkColor.blue,
                      alpha: 1)
            : UIColor(red: lightColor.red,
                      green: lightColor.green,
                      blue: lightColor.blue,
                      alpha: 1)
        }
    }

    func mapToColorModel() -> (lightColor: ColorModel, darkColor: ColorModel) {
        let lightColorModel: ColorModel = {
            guard let components = lightModeColor.getRGBComponents() else {
                return ColorModel(red: 0, green: 0, blue: 0)
            }
            return ColorModel(red: components.red,
                              green: components.green,
                              blue: components.blue)
        }()

        let darkColorModel: ColorModel = {
            guard let components = darkModeColor.getRGBComponents() else {
                return ColorModel(red: 0, green: 0, blue: 0)
            }
            return ColorModel(red: components.red,
                              green: components.green,
                              blue: components.blue)
        }()
        return (lightColorModel, darkColorModel)
    }

    static let backgroundColors: [UIColor] = [
        .systemBackground,
        .neonGreen,
        .electricBlue,
        .hotPink,
        .lemonYellow,
        .acidOrange
    ]

    static var neonGreen: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.08, green: 0.80, blue: 0.00, alpha: 1.00)
            : UIColor(red: 0.33, green: 1.00, blue: 0.12, alpha: 1.00)
        }
    }

    static var electricBlue: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.55, blue: 1.00, alpha: 1.00)
            : UIColor(red: 0.40, green: 0.75, blue: 1.00, alpha: 1.00)
        }
    }

    static var hotPink: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.00, green: 0.00, blue: 0.50, alpha: 1.00)
            : UIColor(red: 1.00, green: 0.33, blue: 0.64, alpha: 1.00)
        }
    }

    static var lemonYellow: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.00)
            : UIColor(red: 1.00, green: 1.00, blue: 0.50, alpha: 1.00)
        }
    }

    static var acidOrange: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.00, green: 0.40, blue: 0.00, alpha: 1.00)
            : UIColor(red: 1.00, green: 0.60, blue: 0.20, alpha: 1.00)
        }
    }

    enum ToastColor {
        case success
        case failure
        case `default`

        var defaultColor: UIColor {
            switch self {
                case .success:
                    return UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
                case .failure:
                    return UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
                case .default:
                    return UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
            }
        }
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
        print("La funcion getRGBComponents ha fallado")
        return nil
    }

    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self,
                                                 requiringSecureCoding: false)
    }

    static func fromData(_ data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: self,
                                                       from: data)
    }
}
