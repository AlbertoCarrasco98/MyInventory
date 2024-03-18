import UIKit
import Combine

class TrashViewController: UIViewController {

    private let mainStackView = UIStackView()
    private let tableView = UITableView()

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
            self.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryListUpdatedSignal.sink { _ in
        } receiveValue: { _ in
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }

    private func setupUI() {
        listenViewModel()
        view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
        self.title = "Papelera"
        view.addSubview(mainStackView)
        configureMainStackView()
    }

    private func configureMainStackView() {
        mainStackView.addArrangedSubview(tableView)
        configureTableView()
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
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
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
    }
}



