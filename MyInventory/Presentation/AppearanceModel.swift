import UIKit

struct AppearanceModel: Equatable {
    var isDarkModeEnabled: Bool
    var boxCornerRadius: Float
    var backgroundColor: UIColor

    static let defaultValue = AppearanceModel(isDarkModeEnabled: false,
                                              boxCornerRadius: 0,
                                              backgroundColor: UIColor(red: 1,
                                                                       green: 1,
                                                                       blue: 1,
                                                                       alpha: 1))

    var thisAppearanceModelHasDefaultValues: Bool {

        return self.isDarkModeEnabled == AppearanceModel.defaultValue.isDarkModeEnabled &&
        self.boxCornerRadius == AppearanceModel.defaultValue.boxCornerRadius &&
        self.backgroundColor == AppearanceModel.defaultValue.backgroundColor
    }
}
//        let darkModeEnabledDefaultValue = self.isDarkModeEnabled == AppearanceModel.defaultValue.isDarkModeEnabled
//        let boxCornerRadiusDefaultValue = self.boxCornerRadius == AppearanceModel.defaultValue.boxCornerRadius
//        let backgroundColorDefaultValue = self.backgroundColor == AppearanceModel.defaultValue.backgroundColor
//
//        return darkModeEnabledDefaultValue &&
//        boxCornerRadiusDefaultValue &&
//        backgroundColorDefaultValue
