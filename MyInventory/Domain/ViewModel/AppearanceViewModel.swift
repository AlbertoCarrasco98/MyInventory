import UIKit
import Combine

class AppearanceViewModel: ObservableObject {

    private(set) var appearanceModel: AppearanceModel

    private(set) var wallpaperSignal = CurrentValueSubject<UIColor, Never>(.white)
    private(set) var wallpaperSignalNew = PassthroughSubject<UIColor, Never>()

    init(appearanceModel: AppearanceModel) {
        self.appearanceModel = appearanceModel
    }

    func updatedBackgroundColor(_ color: UIColor) {
        AppearanceManager.shared.setWallpaper(color: color)
        wallpaperSignal.send(color)
        wallpaperSignalNew.send(color)
    }

    func toggleDarkMode() {
        let isDarkModeEnabled = AppearanceManager.shared.currentAppearance().isDarkModeEnabled
        if isDarkModeEnabled {
            AppearanceManager.shared.disableDarkMode()
        } else {
            AppearanceManager.shared.enabledDarkMode()
        }
    }

    func updateCornerRadius(_ radius: Float) {
        AppearanceManager.shared.setCornerRadius(radius: radius)

    }
























//
//    // MARK: Properties
//
//    var appearance: AppearanceModel
//
//    // MARK: Signals
//
//    let isDarkModeEnabledState: CurrentValueSubject<Bool, Never>
//    let boxCornerRadiusState: CurrentValueSubject<Float, Never>
//    let backgroundColorState: CurrentValueSubject<AppearanceModel.ColorModel, Never>
//
//    init(appearance: AppearanceModel) {
//        self.appearance = appearance
//        self.isDarkModeEnabledState = CurrentValueSubject(appearance.isDarkModeEnabled)
//        self.boxCornerRadiusState = CurrentValueSubject(appearance.boxCornerRadius)
//        self.backgroundColorState = CurrentValueSubject(appearance.backgroundColor)
//    }
//
//    func setDarkMode(isEnabled: Bool) {
//        let newAppearance = AppearanceModel(isDarkModeEnabled: isEnabled,
//                                            boxCornerRadius: appearance.boxCornerRadius,
//                                            backgroundColor: appearance.backgroundColor)
//        appearance = newAppearance
//        isDarkModeEnabledState.send(appearance.isDarkModeEnabled)
//    }
//
//    func setBoxCornerRadius(value: Float) {
//        let newApperance = AppearanceModel(isDarkModeEnabled: appearance.isDarkModeEnabled,
//                                           boxCornerRadius: value,
//                                           backgroundColor: appearance.backgroundColor)
//        appearance = newApperance
//        boxCornerRadiusState.send(appearance.boxCornerRadius)
//    }
//
//    func setBackgroundColor(color: AppearanceModel.ColorModel) {
//        let newAppearance = AppearanceModel(isDarkModeEnabled: appearance.isDarkModeEnabled,
//                                            boxCornerRadius: appearance.boxCornerRadius,
//                                            backgroundColor: color)
//        appearance = newAppearance
//        backgroundColorState.send(appearance.backgroundColor)
//    }
}
