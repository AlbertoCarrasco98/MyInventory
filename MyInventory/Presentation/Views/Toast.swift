import UIKit

class Toast {
    enum ToastColor {
        case success
        case failure
        case `default`

        var defaultColor: UIColor {
            switch self {
                case .success:
                    return UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
                case .failure:
                    return UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
                case .default:
                    return UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
            }
        }
    }

    enum ToastPosition {
        case top
        case center
        case bottom

        var defaultHeight: CGFloat {
            switch self {
                case .top:
                    return 100
                case .center:
                    return UIScreen.main.bounds.height / 2
                case .bottom:
                    return UIScreen.main.bounds.height - 110
            }
        }
    }
}

