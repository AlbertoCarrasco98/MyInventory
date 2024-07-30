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
        .whiteBlack,
        .pastelPeach,
        .pastelCantaloupe,
        .pastelBlush,
        .pastelRose,
        .pastelBeige,
        .pastelYellow,
        .pastelMint,
        .pastelTurquoise,
        .pastelAqua,
        .pastelCyan,
        .pastelPeriwinkle,
        .pastelLavender,
        .pastelCharcoal,
        .pastelBerry
    ]

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

extension UIColor {

    static var whiteBlack: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00) // Black
            : UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00) // White
        }
    }

    static var pastelPeach: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.8, green: 0.5, blue: 0.4, alpha: 1.0) // Dark Peach
            : UIColor(red: 1.0, green: 0.8, blue: 0.7, alpha: 1.0) // Light Peach
        }
    }

    static var pastelCantaloupe: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.9, green: 0.6, blue: 0.3, alpha: 1.0) // Dark Cantaloupe
            : UIColor(red: 1.0, green: 0.8, blue: 0.5, alpha: 1.0) // Light Cantaloupe
        }
    }

    static var pastelBlush: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.7, green: 0.5, blue: 0.7, alpha: 1.0) // Dark Blush
            : UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0) // Light Blush
        }
    }

    static var pastelRose: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.9, green: 0.6, blue: 0.7, alpha: 1.0) // Dark Rose
            : UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0) // Light Rose
        }
    }

    static var pastelBeige: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.8, green: 0.7, blue: 0.6, alpha: 1.0) // Dark Beige
            : UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0) // Light Beige
        }
    }

    static var pastelYellow: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.8, green: 0.8, blue: 0.4, alpha: 1.0) // Dark Yellow
            : UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0) // Light Yellow
        }
    }

    static var pastelMint: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.4, green: 0.8, blue: 0.7, alpha: 1.0) // Dark Mint
            : UIColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1.0) // Light Mint
        }
    }

    static var pastelTurquoise: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.3, green: 0.7, blue: 0.7, alpha: 1.0) // Dark Turquoise
            : UIColor(red: 0.7, green: 1.0, blue: 1.0, alpha: 1.0) // Light Turquoise
        }
    }

    static var pastelAqua: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.4, green: 0.7, blue: 0.8, alpha: 1.0)
            : UIColor(red: 0.7, green: 0.9, blue: 0.9, alpha: 1.0)
        }
    }

    static var pastelCyan: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.3, green: 0.6, blue: 0.6, alpha: 1.0)
            : UIColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }


    static var pastelPeriwinkle: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.6, green: 0.5, blue: 0.9, alpha: 1.0) // Dark Periwinkle
            : UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0) // Light Periwinkle
        }
    }

    static var pastelLavender: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0) // Dark Lavender
            : UIColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1.0) // Light Lavender
        }
    }

    static var pastelCharcoal: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Dark Charcoal
            : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // Light Charcoal
        }
    }

    static var pastelBerry: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.6, green: 0.4, blue: 0.6, alpha: 1.0) // Dark Berry
            : UIColor(red: 0.9, green: 0.7, blue: 0.9, alpha: 1.0) // Light Berry
        }
    }

    static var sectionHeaderTitleColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? .white
            : .black
        }
    }
}
