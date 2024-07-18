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
    var interfaceStyleSignal = CurrentValueSubject<InterfaceStyle, Never>(.automatic)

    // MARK: - Lifecycle

    private init() {

        let interfaceStyle = UserDefaultManager.interfaceStyle()
        let boxCornerRadius = UserDefaultManager.boxCornerRadius()
        let backgroundColor: UIColor = {
            guard let backgroundColorModel = UserDefaultManager.loadBackgroundColor() else {
                return .systemBackground
            }
            return UIColor.make(fromLightColorModel: backgroundColorModel.lightColor,
                                darkColorModel: backgroundColorModel.darkColor)
        }()
        self.appearanceModel = AppearanceModel(interfaceStyle: interfaceStyle,
                                               boxCornerRadius: boxCornerRadius,
                                               backgroundColor: backgroundColor)
    }

    // MARK: - Methods

    func enableDarkMode() {
        appearanceModel.interfaceStyle = .dark
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        UserDefaultManager.saveInterfaceStyle(.dark)
        interfaceStyleSignal.send(appearanceModel.interfaceStyle)
    }

    func disableDarkMode() {
        appearanceModel.interfaceStyle = .light
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        UserDefaultManager.saveInterfaceStyle(.light)
        interfaceStyleSignal.send(appearanceModel.interfaceStyle)
    }

    func restoreAppearanceStyle () {
        appearanceModel.interfaceStyle = .automatic
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .unspecified
        }
        UserDefaultManager.saveInterfaceStyle(.automatic)
        interfaceStyleSignal.send(appearanceModel.interfaceStyle)
    }

    func restoreAppearanceSettings() {
        appearanceModel = .defaultValue
        UserDefaultManager.restoreAppearanceSettings()
        backgroundStateSignal.send(appearanceModel.backgroundColor)
        boxCornerRadiusChangedSignal.send(appearanceModel.boxCornerRadius)
        interfaceStyleSignal.send(appearanceModel.interfaceStyle)
    }

    static func loadSavedColor() -> UIColor {
        guard let backgroundColor = UserDefaultManager.loadBackgroundColor() else {
            return .systemMint
        }
        return UIColor.make(fromLightColorModel: backgroundColor.lightColor,
                            darkColorModel: backgroundColor.darkColor)
    }

    func setCornerRadius(_ radius: Float) {
        appearanceModel.boxCornerRadius = radius
        UserDefaultManager.saveBoxCornerRadius(radius)
        boxCornerRadiusChangedSignal.send(radius)
    }

    func setBackgroundColor(color: UIColor) {
        appearanceModel.backgroundColor = color
        let (lightColor, darkColor) = color.mapToColorModel()
        UserDefaultManager.saveBackgroundColor(lightColor: lightColor, darkColor: darkColor)
        backgroundStateSignal.send(color)
    }
}
