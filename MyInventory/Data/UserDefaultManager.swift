import Foundation

class UserDefaultManager {

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
