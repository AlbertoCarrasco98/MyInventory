import UIKit
import Combine

class TrashViewController: UIViewController {

    private let viewModel: InventoryViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var deletedInventories: [InventoryModel] {
        viewModel.inventoryList.filter { $0.isDeleted }
    }

//    MARK: - Properties
    private let mainStackView = UIStackView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    init(viewModel: InventoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    MARK: - LifeCycle

    override func viewDidLoad() {
        setupUI()
    }

    private func listenViewModel() {
        viewModel.inventoryUpdatedSignal.sink { _ in
        } receiveValue: { updatedInventory in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryListUpdatedSignal.sink { _ in
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    //            .receive(on: DispatchQueue.main)  // Para que el bloque de receiveValue se hagan por el hilo principal TODAS LAS SEÑALES QUE EJECUTEN COSAS DE VISTA

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal
            .sink { _ in
            } receiveValue: { color in
                self.view.backgroundColor = color
            }.store(in: &cancellables)

        AppearanceViewModel.shared.boxCornerRadiusChangedSignal.sink { radius in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

    }

    private func setupUI() {
        self.title = "Papelera"
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
        listenViewModel()
        listenAppearanceViewModel()
        notifications()
        view.addSubview(mainStackView)
        configureMainStackView()
    }

    private func notifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(internalShowToast(notification:)),
                                               name: .removeInventoryNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(internalShowToast(notification:)),
                                               name: .recoverInventoryNotification,
                                               object: nil)
    }

    @objc private func internalShowToast(notification: Notification) {
        if let message = notification.userInfo?["message"] as? String {
            view.showToast(withMessage: message,
                           color: .success,
                           position: .bottom)
        }
    }
//    MARK: - ConfigureMainStackView

    private func configureMainStackView() {
        configureCollectionView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32)
        ])
    }

//    MARK: - ConfigureCollectionView

    private func configureCollectionView() {
        mainStackView.addArrangedSubview(collectionView)
        let layout = UICollectionViewFlowLayout()
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource

extension TrashViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        deletedInventories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell",
                                                            for: indexPath) as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let inventory = deletedInventories[indexPath.row]
        cell.label.text = inventory.title
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = CGFloat(AppearanceViewModel.shared.appearanceModel.boxCornerRadius)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInventory = deletedInventories[indexPath.row]
        let inventoryDetailVCFromTrash = InventoryDetailViewController(inventory: selectedInventory,
                                                                       viewModel: viewModel)
        inventoryDetailVCFromTrash.title = selectedInventory.title
        self.navigationController?.pushViewController(inventoryDetailVCFromTrash,
                                                      animated: true)
    }
}

//MARK: - UICollectionViewDelegate

extension TrashViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.width / 2 - 10
        let height: CGFloat = 60
        return CGSize(width: widht, height: height)
    }
}
