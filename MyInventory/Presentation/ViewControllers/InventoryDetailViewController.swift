import UIKit
import Combine

class InventoryDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let tableview = UITableView()
    private let textField = UITextField()
    private let hStack = UIStackView()

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
        viewModel.inventoryDidChangeSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { [weak self] updatedInventory in
            self?.inventory = updatedInventory
            self?.configureNavigationBar()
            self?.tableview.reloadData()
            self?.textField.text = ""
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
        configureNavigationBar()
        configureTrashButton()
    }

    private func configureNavigationBar() {
        let imageName = inventory.isFavorite ? "star.fill" : "star"
        let favoriteImage = UIImage(systemName: imageName)
        let favoriteButton = UIBarButtonItem(image: favoriteImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteAction))
        navigationItem.rightBarButtonItems = [favoriteButton]
    }

    private func configureMainStackView() {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 40)
        ])
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(spacer)
        mainStackView.addArrangedSubview(tableview)
        mainStackView.addArrangedSubview(hStack)
    }

    private func configureTableView() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.layer.borderWidth = 1
        tableview.layer.borderColor = UIColor.gray.cgColor
        tableview.layer.cornerRadius = 10
        tableview.layer.masksToBounds = true
    }

    private func configureTextField() {
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
//            viewModel.createNewElement(elementTitle: text, for: inventory)
            viewModel.newElement(from: inventory, elementTitle: text)
            }
        textField.resignFirstResponder()
        return true
    }

    func configureTrashButton() {
        let trashButton = UIButton()
        trashButton.addTarget(self, action: #selector(actionRemoveInventory), for: .touchUpInside)
        trashButton.tintColor = .red
        let image = UIImage(systemName: "trash")
        trashButton.setImage(image, for: .normal)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trashButton.heightAnchor.constraint(equalToConstant: 30),
            trashButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(trashButton)
    }

    @objc func actionRemoveInventory() {
        let alert = UIAlertController(title: "",
                                      message: "El inventario se eliminará permanentemente y no podrás recuperarlo",
                                      preferredStyle: .actionSheet)

        let cancelAlert = UIAlertAction(title: "Cancelar",
                                        style: .cancel,
                                        handler: nil)
        
        let alertAction = UIAlertAction(title: "Eliminar",
                                        style: .destructive) { [weak self] _ in
            self?.removeInventory()
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        alert.addAction(cancelAlert)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    func removeInventory() {
        viewModel.removeInventory(inventory)
    }

    @objc func favoriteAction() {
//        let setFavoriteValue = !inventory.isFavorite
//        viewModel.setFavorite(setFavoriteValue, toInventory: inventory)
        viewModel.updateIsFavorite(in: inventory)
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
            guard let elementTitle = self?.inventory.elements[indexPath.row].title else {
                completionHandler(false)
                return
            }
            if let inventory = self?.inventory {
                self?.viewModel.borrarUnElementoDeUnInventario(title: elementTitle, inventory: inventory)
            } else {
                print("No se ha seleccionado ningun inventario")
            }
//            self?.viewModel.deleteElement(fromInventoryWithTitle: self?.inventory.title ?? "", elementTitle: elementTitle ?? "")
//            self?.viewModel.borrarUnElementoDeUnInventario(title: elementTitle, inventory: self?.inventory)
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
