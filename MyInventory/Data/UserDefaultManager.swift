import Foundation

actor UserDefaultManager {

    // BackgroundColor

    static func saveBackgroundColor(lightColor: ColorModel, darkColor: ColorModel) {
        let enconder = JSONEncoder()
        do {
            let lightColorData = try enconder.encode(lightColor)
            UserDefaults.standard.setValue(lightColorData, forKey: Key.lightBackgroundColor)

            let darkColorData = try enconder.encode(darkColor)
            UserDefaults.standard.setValue(darkColorData, forKey: Key.darkBackgroundColor)
        } catch let error {
            print("UserDefaultManager.saveBackgroundColor ha fallado.\n\(error)")
        }
    }

    static func loadBackgroundColor() -> (lightColor: ColorModel, darkColor: ColorModel)? {
        let decoder = JSONDecoder()
        do {
            guard let lightBackgroundColorData = UserDefaults.standard.data(forKey: Key.lightBackgroundColor),
                  let darkBackgroundColorData = UserDefaults.standard.data(forKey: Key.darkBackgroundColor)
            else {
                return nil
            }
            let lightColor = try decoder.decode(ColorModel.self, from: lightBackgroundColorData)
            let darkColor = try decoder.decode(ColorModel.self, from: darkBackgroundColorData)
            return (lightColor, darkColor)
        } catch let error {
            print("UserDefaultManager.loadBackgroundColor ha fallado")
            print(error)
            return nil
        }
    }

    // BoxCornerRadius

    static func saveBoxCornerRadius(_ radius: Float) {
        UserDefaults.standard.float(forKey: Key.boxCornerRadius)
    }

    static func boxCornerRadius() -> Float {
        UserDefaults.standard.float(forKey: Key.boxCornerRadius)
    }

    //    InterfaceStyle

    static func saveInterfaceStyle(_ interfaceStyle: InterfaceStyle) {
        UserDefaults.standard.setValue(interfaceStyle.rawValue,
                                       forKey: Key.interfaceStyle)
    }

    static func interfaceStyle() -> InterfaceStyle {
        let interfaceStyleInt = UserDefaults.standard.integer(forKey: Key.interfaceStyle)
        guard let interfaceStyle = InterfaceStyle(rawValue: interfaceStyleInt) else {
            return .automatic
        }
        return interfaceStyle
    }

    //    Restore Appearance

    static func restoreAppearanceSettings() {
        saveBackgroundColor(lightColor: ColorModel(red: 1, green: 1, blue: 1),
                            darkColor: ColorModel(red: 0, green: 0, blue: 0))
        saveInterfaceStyle(.automatic)
        saveBoxCornerRadius(0)
    }
}

private extension UserDefaultManager {
    enum Key {
        static let lightBackgroundColor = "SaveDayBackgroundColor"
        static let darkBackgroundColor = "SaveNightBackgroundColor"
        static let boxCornerRadius = "boxCornerRadius"
        static let interfaceStyle = "interfaceStyle"
    }
}
