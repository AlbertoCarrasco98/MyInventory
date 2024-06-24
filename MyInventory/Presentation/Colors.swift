import UIKit

class Colors {

    static let lightBackgroundColors: [UIColor] = [
        UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), // Blanco puro
        UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0), // Rosa pastel
        UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0), // Amarillo pálido
        UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1.0), // Verde menta
        UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0), // Azul cielo
        UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0), // Lavanda
        UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0), // Melocotón suave
        UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0), // Beige claro
        UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1.0), // Verde agua
        UIColor(red: 229/255, green: 204/255, blue: 255/255, alpha: 1.0), // Lila suave
        UIColor(red: 210/255, green: 255/255, blue: 210/255, alpha: 1.0), // Salvia
        UIColor(red: 255/255, green: 253/255, blue: 208/255, alpha: 1.0), // Crema
        UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0), // Azul celeste
        UIColor(red: 255/255, green: 160/255, blue: 122/255, alpha: 1.0), // Coral claro
        UIColor(red: 204/255, green: 204/255, blue: 255/255, alpha: 1.0)  // Lila claro
    ]

    static let darkBackgroundColors: [UIColor] = [
        UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0), // Blanco puro oscuro
        UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1.0), // Rosa pastel oscuro
        UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0), // Amarillo dorado
        UIColor(red: 0/255, green: 201/255, blue: 87/255, alpha: 1.0), // Verde esmeralda
        UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0), // Azul profundo
        UIColor(red: 148/255, green: 0/255, blue: 211/255, alpha: 1.0), // Lavanda oscura
        UIColor(red: 255/255, green: 140/255, blue: 105/255, alpha: 1.0), // Melocotón oscuro
        UIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1.0), // Beige oscuro
        UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1.0), // Verde agua oscuro
        UIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 1.0), // Lila oscuro
        UIColor(red: 85/255, green: 107/255, blue: 47/255, alpha: 1.0), // Verde oliva
        UIColor(red: 210/255, green: 180/255, blue: 140/255, alpha: 1.0), // Crema oscuro
        UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1.0), // Azul oscuro
        UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1.0), // Coral oscuro
        UIColor(red: 153/255, green: 50/255, blue: 204/255, alpha: 1.0)  // Lila oscuro
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

}
