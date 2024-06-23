import UIKit
import Combine

@MainActor
class AppearanceViewModel: ObservableObject {

    //    MARK: - Properties

    static var shared = AppearanceViewModel()
    private(set) var appearanceModel: AppearanceModel

    // MARK: - Signals
    
    var backgroundStateSignal = PassthroughSubject<UIColor, Never>()
    var boxCornerRadiusChangedSignal = CurrentValueSubject<Float, Never>(0)

    // MARK: - Lifecycle

    private init() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeState")
        print(isDarkModeEnabled)
        self.appearanceModel = AppearanceModel(isDarkModeEnabled: isDarkModeEnabled,
                                               boxCornerRadius: Float(UserDefaults.standard.integer(forKey: "SaveBoxCornerRadius")),
                                               backgroundColor: UIColor(named: "backgroundPrimary") ?? .systemPink)
    }

    // MARK: - Methods

    func enableDarkMode() {
        appearanceModel.isDarkModeEnabled = true
//        UIScreen.main.traitCollection.userInterfaceStyle

        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        UserDefaultManager.saveStateDarkMode(isOn: true)
        //        print("El valor de isDarkModeEnabled en base de datos es: \(UserDefaults.standard.bool(forKey: "darkModeState"))")
    }

    func disableDarkMode() {
        appearanceModel.isDarkModeEnabled = false
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        UserDefaultManager.saveStateDarkMode(isOn: false)
        //        print("El valor de isDarkModeEnabled en base de datos es: \(UserDefaults.standard.bool(forKey: "darkModeState"))")
    }

    func restoreApparenceSettings () {
        let restoredModel = AppearanceModel.defaultValue
        UserDefaultManager.restoreAppearanceSettings(modelToSave: restoredModel)
        appearanceModel = restoredModel
        backgroundStateSignal.send(restoredModel.backgroundColor)
        boxCornerRadiusChangedSignal.send(restoredModel.boxCornerRadius)
    }

    static private func loadSavedColor() -> UIColor {
        guard let savedColor = UserDefaultManager.loadBackgroundColor() else {
            return .white
        }
        let color = ColorMapper.map(color: savedColor)
        return color
    }


    func setCornerRadius(_ radius: Int) {
        appearanceModel.boxCornerRadius = Float(radius)
        UserDefaultManager.saveBoxCornerRadius(radius)
        boxCornerRadiusChangedSignal.send(Float(radius))
    }

    func setBackgroundColor(color: UIColor) {
        appearanceModel.backgroundColor = color
        //        let colorModel = ColorMapper.map(color: color)
        UserDefaultManager.saveBackgroundColor(ColorMapper.map(color: color))
//        backgroundStateSignal.send(color)
    }
}

