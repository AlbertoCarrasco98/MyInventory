import Foundation

actor UserDefaultManager {

//    static func restoreAppearanceSettings(modelToSave: AppearanceModel) {
//        let backgroundColorToSave = ColorMapper.map(color: modelToSave.backgroundColor)
//
//
//
//        saveBoxCornerRadius(Int(modelToSave.boxCornerRadius))
//
//        UserDefaults.standard.setValue(modelToSave.isDarkModeEnabled, forKey: "restoreSavedIsDarkModeEnabled")
//    }

    static func saveBoxCornerRadius(_ radius: Float) {
        UserDefaults.standard.setValue(radius,
                                       forKey: Keys.boxCornerRadius)
    }

    static func loadBoxCornerRadius() -> Float {
        UserDefaults.standard.float(forKey: Keys.boxCornerRadius)
    }

    static func saveAppearanceModeState(_ appearanceModeState: AppearanceModel.AppearanceModeState) {
        UserDefaults.standard.setValue(appearanceModeState.rawValue, forKey: Keys.appearanceModeState)
    }

    static func loadAppearanceModeState() -> AppearanceModel.AppearanceModeState? {
        let appearanceModeState = UserDefaults.standard.integer(forKey: Keys.appearanceModeState)
        return AppearanceModel.AppearanceModeState(rawValue: appearanceModeState)
    }


//MARK: - Guardado de colores modo dia/noche

    static func saveLightModeBackgroundcolor(_ lightColor: ColorModel) {
        let enconder = JSONEncoder()
        do {
            let data = try enconder.encode(lightColor)
            UserDefaults.standard.setValue(data, forKey: Keys.saveDayModeBackgroundColor)
        } catch let error {
            print("UserDefaultManager.saveDayBackgroundColor ha fallado")
            print(error)
        }
    }

    static func saveDarkModeBackgroundcolor(_ darkColor: ColorModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(darkColor)
            UserDefaults.standard.setValue(data, forKey: Keys.saveNightModeBackgroundColor)
        } catch let error {
            print("UserDefaultManager.saveNightBackgroundColor ha fallado")
            print(error)
        }
    }

    //MARK: - Cargado de colores modo dia/noche

    static func loadLightBackgroundColor() -> ColorModel? {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: Keys.saveDayModeBackgroundColor) else {
                print("La funcion UserDefaultsManager.loadLightBackgroundColor ha fallado")
                return nil
            }
            let color = try decoder.decode(ColorModel.self,
                                           from: data)
            return color
        } catch {
            print("UserDefaultsManager.loadLightBackgroundColor ha fallado")
            print(error)
            return nil
        }
    }

    static func loadDarkBackgroundColor() -> ColorModel? {
        let decoder = JSONDecoder()

        do {
            guard let data = UserDefaults.standard.data(forKey: Keys.saveNightModeBackgroundColor) else {
                print("La funcion UserDefaultsManager.loadDarkBackgroundColor( ha fallado")
                return nil
            }
            let color = try decoder.decode(ColorModel.self,
                                           from: data)
            return color
        } catch {
            print("UserDefaultsManager.loadDarkBackgroundColor( ha fallado")
            print(error)
            return nil
        }
    }
}

private extension UserDefaultManager {

    enum Keys {
        static let appearanceModeState = "appearanceModeState"
        static let boxCornerRadius = "boxCornerRadius"
        static let saveNightModeBackgroundColor = "SaveNightBackgroundColor"
        static let saveDayModeBackgroundColor = "SaveDayBackgroundColor"
    }
}
