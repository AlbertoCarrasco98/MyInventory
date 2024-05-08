import Foundation
import UIKit

struct AppearanceModel {
    var isDarkModeEnabled: Bool
    var boxCornerRadius: Float
    var backgroundColor: UIColor

    struct ColorModel {
        let red: Int
        let green: Int
        let blue: Int

        static let gray: ColorModel = .init(red: 10, green: 10, blue: 10)
    }
}
