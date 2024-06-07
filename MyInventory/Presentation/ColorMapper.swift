import UIKit

class ColorMapper {

    static func map(color: UIColor) -> ColorModel {
        guard let components = color.getRGBComponents() else {
            return ColorModel(red: 0,
                              green: 0,
                              blue: 0)
        }
        return ColorModel(red: components.red * 255,
                          green: components.green * 255,
                          blue: components.blue * 255)
    }

    static func map(color: ColorModel) -> UIColor {
        let UIColor = UIColor(red: CGFloat(color.red) / 255,
                              green: CGFloat(color.green) / 255,
                              blue: CGFloat(color.blue) / 255,
                              alpha: 1)
        return UIColor
    }
}
