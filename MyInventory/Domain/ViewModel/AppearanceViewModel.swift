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
        let appearanceModeState = UserDefaultManager.loadAppearanceModeState() ?? .automatic
        let boxCornerRadius = UserDefaultManager.loadBoxCornerRadius()

        self.appearanceModel = AppearanceModel(appearanceModeState: appearanceModeState,
                                               boxCornerRadius: boxCornerRadius,
                                               lightModeBackgroundColor: AppearanceViewModel.loadSavedLightColor(),
                                               darkModeBackgroundColor: AppearanceViewModel.loadSavedDarkColor())
    }

    // MARK: - Methods

    func enableAutomaticDarkMode() {
        appearanceModel.appearanceModeState = .automatic
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .unspecified
        }
    }

    func enableDarkMode() {
        appearanceModel.appearanceModeState = .dark
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }

    func enableLightMode() {
        appearanceModel.appearanceModeState = .light
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
    }

    func restoreApparenceSettings () {
//        let restoredModel = AppearanceModel.defaultValue
//        UserDefaultManager.restoreAppearanceSettings(modelToSave: restoredModel)
//        appearanceModel = restoredModel
//        backgroundStateSignal.send(restoredModel.backgroundColor)
//        boxCornerRadiusChangedSignal.send(restoredModel.boxCornerRadius)
    }

    static private func loadSavedLightColor() -> UIColor {
        guard let savedColor = UserDefaultManager.loadLightBackgroundColor() else {
            print("La funcion AppearanceViewModel.loadSavedLightColor ha fallado")
            return .systemBackground
        }
        let color = ColorMapper.map(color: savedColor)
        return color
    }

    static private func loadSavedDarkColor() -> UIColor {
        guard let savedColor = UserDefaultManager.loadDarkBackgroundColor() else {
            print("La funcion AppearanceViewModel.loadSavedDarkColor ha fallado")
            return .systemBackground
        }
        let color = ColorMapper.map(color: savedColor)
        return color
    }

    func setCornerRadius(_ radius: Float) {
        appearanceModel.boxCornerRadius = Float(radius)
        UserDefaultManager.saveBoxCornerRadius(radius)
        boxCornerRadiusChangedSignal.send(Float(radius))
    }

    func setBackgroundColor(color: UIColor) {
        let (lightColorModel, darkColorModel) = ColorMapper.map(color: color)

        print("/////// \(lightColorModel) ------- \(darkColorModel)")
        UserDefaultManager.saveLightModeBackgroundcolor(lightColorModel)
        UserDefaultManager.saveDarkModeBackgroundcolor(darkColorModel)

        backgroundStateSignal.send(color)
    }

    var backgroundColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return AppearanceViewModel.shared.appearanceModel.darkModeBackgroundColor
            } else {
                return AppearanceViewModel.shared.appearanceModel.lightModeBackgroundColor
            }
        }
    }
}

