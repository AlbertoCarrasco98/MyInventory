import UIKit
import Combine

class AppearanceViewModel: ObservableObject {

    static let shared = AppearanceViewModel()

    private(set) var appearanceModel: AppearanceModel

//        let boxCornerRadiusKey = UserDefaults.standard.integer(forKey: "SaveBoxCornerRadius")






//        private(set) var appearanceModel = AppearanceModel(isDarkModeEnabled: false,
//                                                           boxCornerRadius: Float(UserDefaults
//                                                            .standard.integer(forKey: "SaveBoxCornerRadius")),
//                                                           backgroundColor: AppearanceViewModel.shared.backgroundColor)

//    lazy var backgroundColor: UIColor = {
//        loadBackgroundColor() ?? .white
//    }()

    // MARK: Signals

    var backgroundStateSignal = CurrentValueSubject<UIColor, Never>(.white)
    var boxCornerRadiusChangedSignal = CurrentValueSubject<Float, Never>(0)

    

    private init() {

        let savedBackgroundColor = AppearanceViewModel.loadBackgroundColor(forKey: "SaveBackgroundColor") ?? .white

        self.appearanceModel = AppearanceModel(isDarkModeEnabled: false,
                                               boxCornerRadius: Float(UserDefaults.standard.integer(forKey: "SaveBoxCornerRadius")), backgroundColor: savedBackgroundColor)
    }

//    func currentAppearance() -> AppearanceModel{
//        appearanceModel
//    }

    func enableDarkMode() {
        appearanceModel.isDarkModeEnabled = true
    }


    func disableDarkMode() {
        appearanceModel.isDarkModeEnabled = false
    }

    func setCornerRadius(_ radius: Int) {
        appearanceModel.boxCornerRadius = Float(radius)
        saveBoxCornerRadius(radius)
        boxCornerRadiusChangedSignal.send(Float(radius))
    }

    func setBackgroundColor(color: UIColor) {
        appearanceModel.backgroundColor = color
        saveBackgroundColor(color)
        backgroundStateSignal.send(color)
    }

    func saveBoxCornerRadius(_ radius: Int) {
        UserDefaults.standard.setValue(radius,
                                       forKey: "SaveBoxCornerRadius")
        UserDefaults.standard.synchronize()
    }

    func saveBackgroundColor(_ color: UIColor) {
        if let colorData = color.toData() {
            UserDefaults.standard.setValue(colorData,
                                           forKey: "SaveBackgroundColor")
        }
        UserDefaults.standard.synchronize()
    }

//    func loadBackgroundColor() -> UIColor? {
//        if let colorData = UserDefaults.standard.data(forKey: "SaveBackgroundColor") {
//            let color = UIColor.fromData(colorData)
//                appearanceModel.backgroundColor = color ?? .white
//        }
//        return nil
//    }

    static func loadBackgroundColor(forKey key: String) -> UIColor? {
        guard let colorData = UserDefaults.standard.data(forKey: key),
              let color = UIColor.fromData(colorData)
        else {
            return nil
        }
        return color
    }

}
