import UIKit
import Combine

class AppearanceViewModel: ObservableObject {

    //    MARK: - Properties

    static var shared = AppearanceViewModel()
    private(set) var appearanceModel: AppearanceModel

    // MARK: - Signals

    var backgroundStateSignal = PassthroughSubject<UIColor, Never>()
    var boxCornerRadiusChangedSignal = CurrentValueSubject<Float, Never>(0)

    // MARK: - Lifecycle

    private init() {
        self.appearanceModel = AppearanceModel(isDarkModeEnabled: false,
                                               boxCornerRadius: Float(UserDefaults.standard.integer(forKey: "SaveBoxCornerRadius")),
                                               backgroundColor: AppearanceViewModel.loadSavedColor())
    }

    // MARK: - Methods

    func restoreApparenceSettings () {
        let modelToSave = AppearanceModel(isDarkModeEnabled: false,
                                          boxCornerRadius: 0,
                                          backgroundColor: .white)
        UserDefaultManager.restoreAppearanceSettings(modelToSave: modelToSave)
        appearanceModel = modelToSave
        backgroundStateSignal.send(modelToSave.backgroundColor)
        boxCornerRadiusChangedSignal.send(modelToSave.boxCornerRadius)
    }

    static private func loadSavedColor() -> UIColor {
        guard let savedColor = UserDefaultManager.loadBackgroundColor() else {
            return .white
        }
        let color = ColorMapper.map(color: savedColor)
        return color
    }

    func enableDarkMode() {
        appearanceModel.isDarkModeEnabled = true
    }

    func disableDarkMode() {
        appearanceModel.isDarkModeEnabled = false
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
        backgroundStateSignal.send(color)
    }
}

