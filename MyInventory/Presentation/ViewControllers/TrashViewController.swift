import UIKit
import Combine

class TrashViewController: UIViewController {

    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    

    private let viewModel: InventoryViewModel

    var cancellables: Set<AnyCancellable> = []
    private var deletedInventories: [InventoryModel] {
        viewModel.inventoryList.filter { $0.isDeleted }
    }

    init(viewModel: InventoryViewModel) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
    }

    func listenViewModel() {
        viewModel.inventoryUpdatedSignal.sink { _ in
        } receiveValue: { updatedInventory in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryListUpdatedSignal.sink { _ in
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)
    }

    private func setupUI() {
        listenViewModel()
//        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
        self.title = "Papelera"
        view.addSubview(mainStackView)
        configureMainStackView()
    }

    private func configureMainStackView() {
//        mainStackView.addArrangedSubview(tableView)
//        configureTableView()
        configureCollectionView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32)
        ])
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1
        tableView.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
    }

    private func configureCollectionView() {
        mainStackView.addArrangedSubview(collectionView)
        collectionView.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
        let layout = UICollectionViewFlowLayout()
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.setCollectionViewLayout(layout, animated: false)
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
        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        cell.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2.5
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












// MARK: - UITableViewDataSource

extension TrashViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Numero de filas en la seccion: Habra tantas filas como inventarios tengan la propiedad isDeleted = TRUE
        // Tengo que coger la lista de inventarios y mostrar solo los que tengan isDeleted = true
        deletedInventories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Habra un elemento por fila
        // Tengo que mostrar el titulo del elemento que toque en cada fila
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        let inventory = deletedInventories[indexPath.row]
        cell.textLabel?.text = inventory.title
        cell.backgroundColor = UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recoverAction = UIContextualAction(style: .normal, title: "Recuperar") { [weak self] (action, view, completionHandler) in
            guard let inventory = self?.deletedInventories[indexPath.row] else {
                completionHandler(false)
                return
            }
            self?.viewModel.updateIsDeleted(in: inventory)
            completionHandler(true)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (action, view, completionHandler) in
            if indexPath.row < self?.deletedInventories.count ?? 0 {
                guard let inventory = self?.deletedInventories[indexPath.row] else {
                    completionHandler(false)
                    return
                }
                self?.viewModel.removeInventory(inventory)
            } else {
                print("No se ha podido eliminar el inventario")
            }
            completionHandler(true)
        }
        recoverAction.backgroundColor = .systemBlue
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, recoverAction])
        return configuration
    }
}

extension TrashViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedInventory = deletedInventories[indexPath.row]
        let inventoryDetailVC = InventoryDetailViewController(inventory: selectedInventory,
                                                              viewModel: viewModel)
        navigationController?.pushViewController(inventoryDetailVC,
                                                 animated: true)
        inventoryDetailVC.title = selectedInventory.title
    }
}



