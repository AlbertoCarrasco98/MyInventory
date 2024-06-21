import Foundation

actor UserDefaultManager {

    static func restoreAppearanceSettings(modelToSave: AppearanceModel) {
        let backgroundColorToSave = ColorMapper.map(color: modelToSave.backgroundColor)
        saveBackgroundColor(backgroundColorToSave)

        saveBoxCornerRadius(Int(modelToSave.boxCornerRadius))

        UserDefaults.standard.setValue(modelToSave.isDarkModeEnabled, forKey: "restoreSavedIsDarkModeEnabled")
    }

    static func saveStateDarkMode(isOn: Bool) {
        UserDefaults.standard.setValue(isOn,
                                       forKey: "darkModeState")
    }

    static func saveBoxCornerRadius(_ radius: Int) {
        UserDefaults.standard.setValue(radius,
                                       forKey: "SaveBoxCornerRadius")
    }

    static func saveBackgroundColor(_ color: ColorModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(color)
            UserDefaults.standard.setValue(data, forKey: "SaveBackgroundColor")
        } catch let error {
            print("UserDefaultManager.saveBackgroundColor ha fallado")
            print(error)
        }
    }

    static func loadBackgroundColor() -> ColorModel? {
        let decoder = JSONDecoder()
        do {
            guard let data = UserDefaults.standard.data(forKey: "SaveBackgroundColor") else {
                return nil
            }
            let color = try decoder.decode(ColorModel.self, from: data)
            return color
        } catch {
            print("UserDefaults.loadBackgroundColor ha fallado")
            print(error)
            return nil
        }
    }
}
