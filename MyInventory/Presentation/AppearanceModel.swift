import UIKit

struct AppearanceModel: Equatable {
    var appearanceModeState: AppearanceModeState
    var boxCornerRadius: Float
    var lightModeBackgroundColor: UIColor
    var darkModeBackgroundColor: UIColor

    static let defaultValue = AppearanceModel(appearanceModeState: .automatic,
                                              boxCornerRadius: 0,
                                              lightModeBackgroundColor: .white,
                                              darkModeBackgroundColor: .systemPink)

    var thisAppearanceModelHasDefaultValues: Bool {
        return self.appearanceModeState == AppearanceModel.defaultValue.appearanceModeState &&
        self.boxCornerRadius == AppearanceModel.defaultValue.boxCornerRadius &&
        self.lightModeBackgroundColor == AppearanceModel.defaultValue.lightModeBackgroundColor &&
        self.darkModeBackgroundColor == AppearanceModel.defaultValue.darkModeBackgroundColor
    }
}

extension AppearanceModel {

    enum AppearanceModeState: Int {
        case automatic
        case light
        case dark
    }
}
