import UIKit

extension String {
    func highlighted(with searchText: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: searchText,
                                             options: .caseInsensitive)
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16,
                                                                 weight: .bold),
                                        .foregroundColor: UIColor.black],
                                       range: range)
        return attributedString
    }
}
