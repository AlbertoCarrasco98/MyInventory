import UIKit
import Combine

class WallpaperViewController: UIViewController {

    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private var cancellables: [AnyCancellable] = []

    //    MARK: - LifeCycle

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listenAppearanceViewModel()
    }

    private func setupUI() {
        view.backgroundColor = AppearanceViewModel.shared.backgroundColor
        configureCollectionView()
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
        }.store(in: &cancellables)
    }

    //    MARK: - ConfigureCollectionView

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CustomCollecionViewCell")
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 12),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        collectionView.backgroundColor = .clear
    }
}

//    MARK: - CollectionViewDataSource

extension WallpaperViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        CollectionViewSections.allCases.count
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UIColor.allColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        guard let section = CollectionViewSections(rawValue: indexPath.section) else { return UICollectionViewCell() }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollecionViewCell",
                                                            for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

//        switch section {
//            case .lightColors:
//                let lightColor = Colors.LightBackgroundColor.allCases[indexPath.item]
//                cell.backgroundColor = lightColor.color
//                let lightColors = UIColor.allColors[indexPath.item]
//                cell.backgroundColor = lightColors
//
//            case .darkColors:
//                let darkColor = Colors.DarkBackgroundColor.allCases[indexPath.item]
//                cell.backgroundColor = darkColor.color
//        }


            let color = UIColor.allColors[indexPath.item]
            cell.backgroundColor = color


        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2.5
        return cell
    }
}

extension WallpaperViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//
//            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                                withReuseIdentifier: "header",
//                                                                                for: indexPath) as! SectionHeader
//
//            if indexPath.section == 0 {
//                sectionHeader.label.text = "Colores para modo día"
//
//            } else if indexPath.section == 1 {
//                sectionHeader.label.text = "Colores para modo noche"
//            }
//            return sectionHeader
//        } else {
//            return UICollectionReusableView()
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        return CGSize(width: collectionView.frame.width,
//                      height: 80)
//    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widht = collectionView.bounds.width / 3 - 16
        let height: CGFloat = 120
        return CGSize(width: widht, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = CollectionViewSections(rawValue: indexPath.section) else { return }
//        var selectedColor: UIColor

        switch section {
            case .lightColors:
//                let lightColor = Colors.LightBackgroundColor.allCases[indexPath.item]
//                selectedColor = lightColor.color
                let color = UIColor.allColors[indexPath.item]
                AppearanceViewModel.shared.setBackgroundColor(color: color)
            case .darkColors:
//                let darkColor = Colors.DarkBackgroundColor.allCases[indexPath.item]
//                selectedColor = darkColor.color
                let color = UIColor.allColors[indexPath.item]
                AppearanceViewModel.shared.setBackgroundColor(color: color)

        }

    }
}

extension WallpaperViewController {

    enum CollectionViewSections: Int, CaseIterable {
        case lightColors
        case darkColors

        var colorCell: Int {
            switch self {
                case .lightColors:
                    return Colors.LightBackgroundColor.allCases.count
                case .darkColors:
                    return Colors.DarkBackgroundColor.allCases.count
            }
        }

        var title: String {
            switch self {
                case .lightColors:
                    return "Colores claros"
                case .darkColors:
                    return "Colores oscuros"
            }
        }
    }

    enum CellLightColors: Int {
        case color
    }

    enum CellDarkColors: Int {
        case color
    }

}
