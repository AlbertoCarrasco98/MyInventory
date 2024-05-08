import UIKit

class WallpaperViewController: UIViewController {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let appearanceViewModel = AppearanceViewModel()

//    MARK: - LifeCycle

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        configureCollectionView()
        view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
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
        collectionView.backgroundColor = UIColor(red: 0.338, green: 0.378, blue: 0.878, alpha: 0.4)
    }
}

//    MARK: - CollectionViewDataSource

extension WallpaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Colors.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollecionViewCell", for: indexPath)
                as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        guard let colors = Colors(rawValue: indexPath.item) else { return UICollectionViewCell() }
        switch colors {

            case .red:
                cell.backgroundColor = .red
            case .blue:
                cell.backgroundColor = .blue
            case .yellow:
                cell.backgroundColor = .yellow
            case .green:
                cell.backgroundColor = .green
            case .pink:
                cell.backgroundColor = .systemPink
            case .gray:
                cell.backgroundColor = .gray
            case .white:
                cell.backgroundColor = .white
            case .brown:
                cell.backgroundColor = .brown
            case .orange:
                cell.backgroundColor = .orange
        }
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
        guard let selectedColor = Colors(rawValue: indexPath.row) else { return }
        switch selectedColor {
            case .red:
                appearanceViewModel.updatedBackgroundColor(.red)
            case .blue:
                appearanceViewModel.updatedBackgroundColor(.blue)
            case .yellow:
                appearanceViewModel.updatedBackgroundColor(.yellow)
            case .green:
                appearanceViewModel.updatedBackgroundColor(.green)
            case .pink:
                appearanceViewModel.updatedBackgroundColor(.systemPink)
            case .gray:
                appearanceViewModel.updatedBackgroundColor(.gray)
            case .white:
                appearanceViewModel.updatedBackgroundColor(.white)
            case .brown:
                appearanceViewModel.updatedBackgroundColor(.brown)
            case .orange:
                appearanceViewModel.updatedBackgroundColor(.orange)
        }
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
