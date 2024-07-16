import UIKit

class Colors {

    enum LightBackgroundColor: Int, CaseIterable {
        case blancoPuro
        case rosaPastel
        case amarilloPalido
        case verdeMenta
        case azulCielo
        case lavanda
        case melocotonSuave
        case beigeClaro
        case verdeAgua
        case lilaSuave
        case salvia
        case crema
        case azulCeleste
        case coralClaro
        case lilaClaro

        var color: UIColor {
            switch self {
            case .blancoPuro:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            case .rosaPastel:
                return UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0)
            case .amarilloPalido:
                return UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0)
            case .verdeMenta:
                return UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1.0)
            case .azulCielo:
                return UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0)
            case .lavanda:
                return UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0)
            case .melocotonSuave:
                return UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0)
            case .beigeClaro:
                return UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
            case .verdeAgua:
                return UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1.0)
            case .lilaSuave:
                return UIColor(red: 229/255, green: 204/255, blue: 255/255, alpha: 1.0)
            case .salvia:
                return UIColor(red: 210/255, green: 255/255, blue: 210/255, alpha: 1.0)
            case .crema:
                return UIColor(red: 255/255, green: 253/255, blue: 208/255, alpha: 1.0)
            case .azulCeleste:
                return UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0)
            case .coralClaro:
                return UIColor(red: 255/255, green: 160/255, blue: 122/255, alpha: 1.0)
            case .lilaClaro:
                return UIColor(red: 204/255, green: 204/255, blue: 255/255, alpha: 1.0)
            }
        }
    }

    enum DarkBackgroundColor: Int, CaseIterable {
        case blancoPuroOscuro
        case rosaPastelOscuro
        case amarilloDorado
        case verdeEsmeralda
        case azulProfundo
        case lavandaOscura
        case melocotonOscuro
        case beigeOscuro
        case verdeAguaOscuro
        case lilaOscuro
        case verdeOliva
        case cremaOscuro
        case azulOscuro
        case coralOscuro
        case lilaOscuro2

        var color: UIColor {
            switch self {
            case .blancoPuroOscuro:
                return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
            case .rosaPastelOscuro:
                return UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1.0)
            case .amarilloDorado:
                return UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)
            case .verdeEsmeralda:
                return UIColor(red: 0/255, green: 201/255, blue: 87/255, alpha: 1.0)
            case .azulProfundo:
                return UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0)
            case .lavandaOscura:
                return UIColor(red: 148/255, green: 0/255, blue: 211/255, alpha: 1.0)
            case .melocotonOscuro:
                return UIColor(red: 255/255, green: 140/255, blue: 105/255, alpha: 1.0)
            case .beigeOscuro:
                return UIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1.0)
            case .verdeAguaOscuro:
                return UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1.0)
            case .lilaOscuro:
                return UIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 1.0)
            case .verdeOliva:
                return UIColor(red: 85/255, green: 107/255, blue: 47/255, alpha: 1.0)
            case .cremaOscuro:
                return UIColor(red: 210/255, green: 180/255, blue: 140/255, alpha: 1.0)
            case .azulOscuro:
                return UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1.0)
            case .coralOscuro:
                return UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1.0)
            case .lilaOscuro2:
                return UIColor(red: 153/255, green: 50/255, blue: 204/255, alpha: 1.0)
            }
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
}
