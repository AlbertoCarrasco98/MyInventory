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
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
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
        collectionView.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }
}

//    MARK: - CollectionViewDataSource

extension WallpaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Colors.backgroundColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollecionViewCell", for: indexPath)
                as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.backgroundColor = Colors.backgroundColors[indexPath.item]

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
        let selectedColor = Colors.backgroundColors[indexPath.row]
        AppearanceViewModel.shared.setBackgroundColor(color: selectedColor)
        
    }
}
