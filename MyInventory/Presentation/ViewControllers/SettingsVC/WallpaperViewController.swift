import UIKit
import Combine

class WallpaperViewController: UIViewController {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var cancellables: [AnyCancellable] = []

//    MARK: - LifeCycle

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listenAppearanceViewModel()
    }

    private func setupUI() {
        configureCollectionView()
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
            self.collectionView.backgroundColor = color
        }.store(in: &cancellables)
    }

//    MARK: - ConfigureCollectionView

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollecionViewCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
//        collectionView.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }
}

//    MARK: - CollectionViewDataSource

extension WallpaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        AppearanceViewModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollecionViewCell", for: indexPath)
                as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.backgroundColor = AppearanceViewModel.colors[indexPath.item]

        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2.5
        return cell
    }
}

extension WallpaperViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.width / 3 - 10
        let height: CGFloat = 120
        return CGSize(width: widht, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = AppearanceViewModel.colors[indexPath.row]
        AppearanceViewModel.shared.setBackgroundColor(color: selectedColor)

        }

}

extension WallpaperViewController {
    enum Colors: Int, CaseIterable {
        case red
        case blue
        case yellow
        case green
        case pink
        case gray
        case white
        case brown
        case orange

        var color: UIColor {
            switch self {
                case .red:
                    return .red
                case .blue:
                    return .blue
                case .yellow:
                    return .yellow
                case .green:
                    return .green
                case .pink:
                    return .systemPink
                case .gray:
                    return .gray
                case .white:
                    return .white
                case .brown:
                    return .brown
                case .orange:
                    return .orange
            }
        }
    }
}
