import UIKit
import Combine

class InventoryListViewController: UIViewController {

    // MARK: - Properties
    private let mainStackView = UIStackView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let addInventoryButton = UIButton()

    let viewModel: InventoryViewModel

    var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    init(viewModel: InventoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listenViewModel()
        viewModel.loadData()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.loadData()
//        collectionView.reloadData()
//    }

    // BIND -> Crea una conexión entre el ViewController y el ViewModel
    func listenViewModel() {
        viewModel.newInventorySignal.sink { _ in
//            print("patata")
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryDeletedSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

    }

    func setupUI() {
        view.backgroundColor = .white
        self.title = "Inventarios"
        configureMainStackView()
        configureCollectionView()
        configureAddInventoryButton()
        navigationItem.backButtonTitle = "Atrás"
    }


    func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 24)
        ])
    }

    func configureCollectionView() {
        mainStackView.addArrangedSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }

    func configureAddInventoryButton() {
        mainStackView.addArrangedSubview(addInventoryButton)
        addInventoryButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        addInventoryButton.addTarget(self, action: #selector(addInventoryButtonTapped), for: .touchUpInside)
        addInventoryButton.setTitle("Crea un nuevo inventario", for: .normal)
        addInventoryButton.titleLabel?.textAlignment = .center
        addInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addInventoryButton.setTitleColor(.black, for: .normal)
    }

    @objc func addInventoryButtonTapped() {
        let createNewInventoryVC = CreateNewInventoryViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(createNewInventoryVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension InventoryListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.inventoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell",
                                                                for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemGray3
        let inventory = viewModel.inventoryList[indexPath.row]
        cell.label.text = inventory.title
//        print(cell.label.text)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInventory = viewModel.inventoryList[indexPath.row]
        let inventoryDetailVC = InventoryDetailViewController(inventory: selectedInventory, viewModel: viewModel)
        self.navigationController?.pushViewController(inventoryDetailVC, animated: true)
        inventoryDetailVC.title = selectedInventory.title
    }
}

// MARK: - UICollectionViewDelegate
extension InventoryListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.width / 3 - 7
        let height: CGFloat = 100
        return CGSize(width: widht, height: height)
    }

}

// MARK: - UICollectionViewCell
class CustomCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }

    func setupViews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalTo: label.trailingAnchor),
            bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
}
