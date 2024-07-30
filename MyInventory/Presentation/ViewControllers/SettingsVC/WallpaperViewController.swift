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
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
        configureCollectionView()
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal
            .sink { [weak self] color in
                guard let self else { return }
                view.backgroundColor = color
                collectionView.reloadData()
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
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UIColor.backgroundColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollecionViewCell",
                                                            for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        let color = UIColor.backgroundColors[indexPath.item]
        cell.backgroundColor = color
        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.8
        return cell
    }
}

extension WallpaperViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widht = collectionView.bounds.width / 3 - 16
        let height: CGFloat = 120
        return CGSize(width: widht, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedColor = UIColor.backgroundColors[indexPath.row]
        AppearanceViewModel.shared.setBackgroundColor(color: selectedColor)
    }
}

