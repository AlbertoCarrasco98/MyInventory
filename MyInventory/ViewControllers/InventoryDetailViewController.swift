import UIKit
import Combine

class InventoryDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let tableview = UITableView()
    private let textField = UITextField()
    private let viewModel: InventoryViewModel

    var inventory: InventoryModel
    var cancellables: Set<AnyCancellable> = []

    init(inventory: InventoryModel, viewModel: InventoryViewModel) {
        self.inventory = inventory
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
    }

    func listenViewModel() {
        viewModel.newElementSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { [weak self] updatedInventory in
            self?.inventory = updatedInventory
            self?.tableview.reloadData()
            self?.textField.text = ""
        }.store(in: &cancellables)

        viewModel.elementDeletedSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { [weak self] updatedInventory in
            self?.inventory = updatedInventory
            self?.tableview.reloadData()
        }.store(in: &cancellables)
    }

    // MARK: - Setup UI

    func setupUI() {
        view.backgroundColor = .white
        configureMainStackView()
        configureTableView()
        configureTextField()
        listenViewModel()
        navigationController?.isNavigationBarHidden = false
        navigationItem.backButtonTitle = "Atrás"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                            target: self,
                                                            action: #selector(rightBarButtonItemTapped))
    }

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 40)
        ])
    }

    private func configureTableView() {
        mainStackView.addArrangedSubview(tableview)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableview.dataSource = self
        tableview.delegate = self
    }

    private func configureTextField() {
        mainStackView.addArrangedSubview(textField)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 35)
        ])
        textField.placeholder = "Agrega un nuevo elemento a tu inventario"
        textField.font = .italicSystemFont(ofSize: 15)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            viewModel.createNewElement(elementTitle: text, for: inventory)
            }
        textField.resignFirstResponder()
        return true
    }

    @objc func rightBarButtonItemTapped() {
        viewModel.removeInventory(inventory: self.inventory) // Que inventario quiero borrar??
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension InventoryDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory.elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellTest = UITableViewCell(style: .default, reuseIdentifier: "cellTest")
        let element = inventory.elements[indexPath.row]
        cellTest.textLabel?.text = element.title
        return cellTest
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (action, view, completionHandler) in
            let elementTitle = self?.inventory.elements[indexPath.row].title
            self?.viewModel.deleteElement(fromInventoryWithTitle: self?.inventory.title ?? "", elementTitle: elementTitle ?? "")
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - UITableViewDelegate

extension InventoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
