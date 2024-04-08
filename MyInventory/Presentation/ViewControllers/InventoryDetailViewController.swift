import UIKit
import Combine

class InventoryDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let tableview = UITableView()
    private let textField = UITextField()
    private let hStack = UIStackView()
    private let removeInventoryButton = UIButton()
    private let recoverInventoryButton = UIButton()

    private let viewModel: InventoryViewModel

    var inventory: InventoryModel
    var cancellables: Set<AnyCancellable> = []

    init(inventory: InventoryModel, viewModel: InventoryViewModel) {
        self.inventory = inventory
        self.viewModel = viewModel
//        self.isFromTrash = isFromTrash
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
        viewModel.inventoryUpdatedSignal.sink { _ in
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
        if inventory.isDeleted == true {
            view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            configureFunctionsFromTrashVC()
        } else {
            view.backgroundColor = .white
            navigationController?.isNavigationBarHidden = false
            navigationItem.backButtonTitle = "Atrás"
            configureFunctionsFromInventoryListVC()
        }
    }

    func configureFunctionsFromInventoryListVC() {
        configureMainStackView()
        configureTableView()
        configureTextField()
        listenViewModel()
        configureNavigationBar()
    }

    func configureFunctionsFromTrashVC() {
        configureMainStackViewForTrash()
        configureTableViewForTrash()
        configureRemoveInventoryButton()
        configureRecoverInventoryButton()
    }

//    MARK: - ConfigureNavigationBar
    private func configureNavigationBar() {
        let imageName = inventory.isFavorite ? "star.fill" : "star"
        let favoriteImage = UIImage(systemName: imageName)
        let trashImage = UIImage(systemName: "trash")
        let favoriteButton = UIBarButtonItem(image: favoriteImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteAction))
        let moveInventoryToTrashButton = UIBarButtonItem(image: trashImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(moveInventoryToTrashButtonTapped))
        navigationItem.rightBarButtonItems = [favoriteButton ,moveInventoryToTrashButton]
    }

//    MARK: - ConfigureMainStackView
    private func configureMainStackView() {
        let spacer = UIView()
        let spacer2 = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        spacer2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(spacer)
        mainStackView.addArrangedSubview(tableview)
        mainStackView.addArrangedSubview(spacer2)
    }

//    MARK: - ConfigureMainStackViewForTrash
    private func configureMainStackViewForTrash() {
        let spacer = UIView()
        let spacer2 = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        spacer2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 100)
        ])
        mainStackView.addArrangedSubview(tableview)
        mainStackView.addArrangedSubview(spacer2)
        mainStackView.addArrangedSubview(recoverInventoryButton)
        mainStackView.addArrangedSubview(spacer)
        mainStackView.addArrangedSubview(removeInventoryButton)
    }

//    MARK: - ConfigureTableView
    private func configureTableView() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.layer.borderWidth = 1
        tableview.layer.borderColor = UIColor.gray.cgColor
        tableview.layer.cornerRadius = 10
        tableview.layer.masksToBounds = true
    }

//    MARK: - ConfigureTableViewForTrash
    private func configureTableViewForTrash() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.layer.borderWidth = 1
        tableview.layer.borderColor = UIColor.gray.cgColor
        tableview.layer.cornerRadius = 10
        tableview.layer.masksToBounds = true
    }

//    MARK: - ConfigureTextField
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
            viewModel.newElement(from: inventory, elementTitle: text)
            }
        textField.resignFirstResponder()
        return true
    }

//    MARK: -

    @objc func moveInventoryToTrashButtonTapped() {
        let alert = UIAlertController(title: "",
                                      message: "El inventario se moverá a la papelera",
                                      preferredStyle: .actionSheet)

        let cancelAlert = UIAlertAction(title: "Cancelar",
                                        style: .cancel,
                                        handler: nil)
        
        let alertAction = UIAlertAction(title: "Eliminar",
                                        style: .destructive) { [weak self] _ in
            self?.moveInventoryToTrash()
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        alert.addAction(cancelAlert)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    func moveInventoryToTrash() {
        viewModel.updateIsDeleted(in: inventory)
    }

    @objc func favoriteAction() {
        viewModel.updateIsFavorite(in: inventory)
    }

    private func configureRemoveInventoryButton() {
        removeInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        removeInventoryButton.addTarget(self, action: #selector(removeInventoryButtonTapped), for: .touchUpInside)
        removeInventoryButton.setTitle("Eliminar inventario", for: .normal)
        removeInventoryButton.titleLabel?.textAlignment = .center
        removeInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        removeInventoryButton.setTitleColor(.black, for: .normal)
        removeInventoryButton.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        removeInventoryButton.layer.borderWidth = 2
        removeInventoryButton.layer.cornerRadius = 10
    }

    @objc func removeInventoryButtonTapped() {
        let alert = UIAlertController(title: "",
                                      message: "El inventario se eliminará permanentemente",
                                      preferredStyle: .actionSheet)
        let cancelAlert = UIAlertAction(title: "Cancelar",
                                        style: .cancel,
                                        handler: nil)
        let alertAction = UIAlertAction(title: "Eliminar",
                                        style: .destructive) { [weak self] _ in
            self?.removeInventory()
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(cancelAlert)
        alert.addAction(alertAction)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    private func removeInventory() {
        viewModel.removeInventory(inventory)
    }

    private func configureRecoverInventoryButton() {
        recoverInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recoverInventoryButton.addTarget(self, action: #selector(recoverInventoryButtonTapped), for: .touchUpInside)
        recoverInventoryButton.setTitle("Recuperar inventario", for: .normal)
        recoverInventoryButton.titleLabel?.textAlignment = .center
        recoverInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        recoverInventoryButton.setTitleColor(.black, for: .normal)
        recoverInventoryButton.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        recoverInventoryButton.layer.borderWidth = 2
        recoverInventoryButton.layer.cornerRadius = 10
    }

    @objc func recoverInventoryButtonTapped() {
        let alert = UIAlertController(title: "",
                                      message: "El inventario se recuperará de la papelera",
                                      preferredStyle: .actionSheet)

        let cancelAlert = UIAlertAction(title: "Cancelar",
                                        style: .cancel,
                                        handler: nil)

        let alertAction = UIAlertAction(title: "Recuperar",
                                        style: .default) { [weak self] _ in
            self?.recoverInventory()
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(cancelAlert)
        alert.addAction(alertAction)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    private func recoverInventory() {
        viewModel.updateIsDeleted(in: inventory)
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
        if inventory.isDeleted == false {
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
                completionHandler(true)
            }
            deleteAction.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
        else {
            return nil
        }
    }
}

// MARK: - UITableViewDelegate

extension InventoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
