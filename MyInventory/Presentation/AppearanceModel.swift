import UIKit

struct AppearanceModel: Equatable {

    var interfaceStyle: InterfaceStyle
    var boxCornerRadius: Float
    var backgroundColor: UIColor

    static let defaultValue = AppearanceModel(interfaceStyle: .automatic,
                                              boxCornerRadius: 0,
                                              backgroundColor: UIColor(red: 1,
                                                                       green: 1,
                                                                       blue: 1,
                                                                       alpha: 1))

    var thisAppearanceModelHasDefaultValues: Bool {
        return interfaceStyle == AppearanceModel.defaultValue.interfaceStyle &&
        boxCornerRadius == AppearanceModel.defaultValue.boxCornerRadius &&
        backgroundColor == AppearanceModel.defaultValue.backgroundColor
    }
}
