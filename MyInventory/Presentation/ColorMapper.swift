import UIKit

class ColorMapper {

    static func map(color: UIColor) -> (light: ColorModel, dark: ColorModel) {
        let lightColor = color.resolvedColor(with: .init(userInterfaceStyle: .light))
        let darkColor = color.resolvedColor(with: .init(userInterfaceStyle: .dark))

        guard let lightColorComponents = lightColor.getRGBComponents(),
              let darkColorComponents = darkColor.getRGBComponents()
        else {
            print("La funcion de Mapeo UIColor -> ColorModel ha fallado")
            return (ColorModel(red: 0,
                              green: 0,
                               blue: 0,
                               alpha: 0),
                    ColorModel(red: 0,
                               green: 0,
                               blue: 0,
                               alpha: 0)
            )
        }

        let lightColorModel = ColorModel(red: lightColorComponents.red,
                                         green: lightColorComponents.green,
                                         blue: lightColorComponents.blue,
                                         alpha: lightColorComponents.alpha)

        let darkColorModel = ColorModel(red: darkColorComponents.red,
                                         green: darkColorComponents.green,
                                         blue: darkColorComponents.blue,
                                        alpha: lightColorComponents.alpha)

        print("Se estan Mapeando los colores de fondo correctamente")
        return (lightColorModel, darkColorModel)
    }

    static func map(color: ColorModel) -> UIColor {
        let UIColor = UIColor(red: CGFloat(color.red) / 255,
                              green: CGFloat(color.green) / 255,
                              blue: CGFloat(color.blue) / 255,
                              alpha: 1)
        return UIColor
    }
}
