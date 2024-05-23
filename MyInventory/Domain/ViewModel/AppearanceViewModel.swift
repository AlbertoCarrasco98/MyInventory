import UIKit
import Combine

class AppearanceViewModel: ObservableObject {

    static let shared = AppearanceViewModel()

    private(set) var appearanceModel = AppearanceModel(isDarkModeEnabled: false,
                                                       boxCornerRadius: 0,
                                                       backgroundColor: UIColor(red: 1,
                                                                                green: 1,
                                                                                blue: 1,
                                                                                alpha: 1))

    // MARK: Signals

    var backgroundStateSignal = CurrentValueSubject<UIColor, Never>(.white)
    var boxCornerRadiusChangedSignal = CurrentValueSubject<Float, Never>(0)

    static let colors: [UIColor] = [
        UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0), // Rosa pastel
            UIColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 1.0), // Amarillo pálido
            UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1.0), // Verde menta
            UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1.0), // Azul cielo
            UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0), // Lavanda
            UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0), // Melocotón suave
            UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0), // Beige claro
            UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0), // Gris perla
            UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1.0), // Aguamarina
            UIColor(red: 229/255, green: 204/255, blue: 255/255, alpha: 1.0), // Lila suave
            UIColor(red: 210/255, green: 255/255, blue: 210/255, alpha: 1.0), // Salvia
            UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1.0), // Naranja melocotón
            UIColor(red: 255/255, green: 253/255, blue: 208/255, alpha: 1.0), // Crema
            UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1.0), // Azul celeste
            UIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1.0)  // Verde agua
        ]

//    private(set) var wallpaperSignal = CurrentValueSubject<UIColor, Never>(.white)
//    private(set) var wallpaperSignalNew = PassthroughSubject<UIColor, Never>()

    private init() {}

    func currentAppearance() -> AppearanceModel{
        appearanceModel
    }

    func enableDarkMode() {
        appearanceModel.isDarkModeEnabled = true
    }


    func disableDarkMode() {
        appearanceModel.isDarkModeEnabled = false
    }

    func setCornerRadius(radius: Int) {
        appearanceModel.boxCornerRadius = Float(radius)
        boxCornerRadiusChangedSignal.send(Float(radius))
    }

    func setBackgroundColor(color: UIColor) {
        appearanceModel.backgroundColor = color
        backgroundStateSignal.send(color)
    }








    //    func updatedBackgroundColor(_ color: UIColor) {
    //        AppearanceViewModel.shared.setWallpaper(color: color)
    //        wallpaperSignal.send(color)
    //        wallpaperSignalNew.send(color)
    //    }
    //
    //    func toggleDarkMode() {
    //        let isDarkModeEnabled = AppearanceViewModel.shared.currentAppearance().isDarkModeEnabled
    //        if isDarkModeEnabled {
    //            AppearanceViewModel.shared.disableDarkMode()
    //        } else {
    //            AppearanceViewModel.shared.enabledDarkMode()
    //        }
    //    }
    //
    //    func updateCornerRadius(_ radius: Float) {
    //        AppearanceViewModel.shared.setCornerRadius(radius: radius)
    //    }
    //
    //        func enabledDarkMode() {
    //            appearance?.isDarkModeEnabled = true
    //        }
    //
    //        func disableDarkMode() {
    //            appearance?.isDarkModeEnabled = false
    //        }
    //
    //        func setWallpaper(color: UIColor) {
    //            appearance?.backgroundColor = color
    //        }
    //
    //        func setCornerRadius(radius: Float) {
    //            appearance?.boxCornerRadius = radius
    //        }
    //
    //        func currentAppearance() -> AppearanceModel? {
    //            return appearance
    //        }



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
