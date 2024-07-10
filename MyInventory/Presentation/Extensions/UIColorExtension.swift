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
        print("La funcion getRGBComponents ha fallado")
        return nil
    }

        public static var allColors: [UIColor] = [
            whiteBlack,
            pink,
            yellow,
            green,
            blue,
            lavender,
            peach,
            beige,
            aquaGreen,
            lila,
            oliveGreen,
            cream,
            blue2,
            coral,
            lila2
        ]

    public static var whiteBlack: UIColor = {
        return UIColor { (trait: UITraitCollection) -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.blancoPuroOscuro.color
            } else {
                return Colors.LightBackgroundColor.blancoPuro.color
            }
        }
    }()

    public static var pink: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.rosaPastelOscuro.color
            } else {
                return Colors.LightBackgroundColor.rosaPastel.color
            }
        }
    }()

    public static var yellow: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.amarilloDorado.color
            } else {
                return Colors.LightBackgroundColor.amarilloPalido.color
            }
        }
    }()

    public static var green: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.verdeEsmeralda.color
            } else {
                return Colors.LightBackgroundColor.verdeMenta.color
            }
        }
    }()

    public static var blue: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.azulProfundo.color
            } else {
                return Colors.LightBackgroundColor.azulCielo.color
            }
        }
    }()

    public static var lavender: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.lavandaOscura.color
            } else {
                return Colors.LightBackgroundColor.lavanda.color
            }
        }
    }()

    public static var peach: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.melocotonOscuro.color
            } else {
                return Colors.LightBackgroundColor.melocotonSuave.color
            }
        }
    }()

    public static var beige: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.beigeOscuro.color
            } else {
                return Colors.LightBackgroundColor.beigeClaro.color
            }
        }
    }()

    public static var aquaGreen: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.verdeAguaOscuro.color
            } else {
                return Colors.LightBackgroundColor.verdeAgua.color
            }
        }
    }()

    public static var lila: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.lilaOscuro.color
            } else {
                return Colors.LightBackgroundColor.lilaSuave.color
            }
        }
    }()

    public static var oliveGreen: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.verdeOliva.color
            } else {
                return Colors.LightBackgroundColor.salvia.color
            }
        }
    }()

    public static var cream: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.cremaOscuro.color
            } else {
                return Colors.LightBackgroundColor.crema.color
            }
        }
    }()

    public static var blue2: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.azulOscuro.color
            } else {
                return Colors.LightBackgroundColor.azulCeleste.color
            }
        }
    }()

    public static var coral: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.coralOscuro.color
            } else {
                return Colors.LightBackgroundColor.coralClaro.color
            }
        }
    }()

    public static var lila2: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.DarkBackgroundColor.lilaOscuro2.color
            } else {
                return Colors.LightBackgroundColor.lilaClaro.color
            }
        }
    }()



//    public static var dayColors: [UIColor] = [
//        whiteBlack().dayColor,
//        pink().dayColor,
//        yellow().dayColor,
//        green().dayColor,
//        blue().dayColor,
//        lavender().dayColor,
//        peach().dayColor,
//        beige().dayColor,
//        aquaGreen().dayColor,
//        lila().dayColor,
//        oliveGreen().dayColor,
//        cream().dayColor,
//        blue2().dayColor,
//        coral().dayColor,
//        lila2().dayColor
//    ]
//
//    public static var nightColors: [UIColor] = [
//        whiteBlack().nightColor,
//        pink().nightColor,
//        yellow().nightColor,
//        green().nightColor,
//        blue().nightColor,
//        lavender().nightColor,
//        peach().nightColor,
//        beige().nightColor,
//        aquaGreen().nightColor,
//        lila().nightColor,
//        oliveGreen().nightColor,
//        cream().nightColor,
//        blue2().nightColor,
//        coral().nightColor,
//        lila2().nightColor
//    ]




//    public static func whiteBlack() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.blancoPuro.color
//        let nightColor = Colors.DarkBackgroundColor.blancoPuroOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func pink() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.rosaPastel.color
//        let nightColor = Colors.DarkBackgroundColor.rosaPastelOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func yellow() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.amarilloPalido.color
//        let nightColor = Colors.DarkBackgroundColor.amarilloDorado.color
//        return (dayColor, nightColor)
//    }
//
//    public static func green() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.verdeMenta.color
//        let nightColor = Colors.DarkBackgroundColor.verdeEsmeralda.color
//        return (dayColor, nightColor)
//    }
//
//    public static func blue() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.azulCielo.color
//        let nightColor = Colors.DarkBackgroundColor.azulProfundo.color
//        return (dayColor, nightColor)
//    }
//
//    public static func lavender() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.lavanda.color
//        let nightColor = Colors.DarkBackgroundColor.lavandaOscura.color
//        return (dayColor, nightColor)
//    }
//
//    public static func peach() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.melocotonSuave.color
//        let nightColor = Colors.DarkBackgroundColor.melocotonOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func beige() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.beigeClaro.color
//        let nightColor = Colors.DarkBackgroundColor.beigeOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func aquaGreen() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.verdeAgua.color
//        let nightColor = Colors.DarkBackgroundColor.verdeAguaOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func lila() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.lilaSuave.color
//        let nightColor = Colors.DarkBackgroundColor.lilaOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func oliveGreen() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.salvia.color
//        let nightColor = Colors.DarkBackgroundColor.verdeOliva.color
//        return (dayColor, nightColor)
//    }
//
//    public static func cream() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.crema.color
//        let nightColor = Colors.DarkBackgroundColor.cremaOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func blue2() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.azulCeleste.color
//        let nightColor = Colors.DarkBackgroundColor.azulOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func coral() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.coralClaro.color
//        let nightColor = Colors.DarkBackgroundColor.coralOscuro.color
//        return (dayColor, nightColor)
//    }
//
//    public static func lila2() -> (dayColor: UIColor, nightColor: UIColor) {
//        let dayColor = Colors.LightBackgroundColor.lilaClaro.color
//        let nightColor = Colors.DarkBackgroundColor.lilaOscuro2.color
//        return (dayColor, nightColor)
//    }
}
