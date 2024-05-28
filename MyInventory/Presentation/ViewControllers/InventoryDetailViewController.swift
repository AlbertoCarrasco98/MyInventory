import UIKit
import Combine

class InventoryDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let textField = UITextField()
    private let hStack = UIStackView()
    private let removeInventoryButton = UIButton()
    private let recoverInventoryButton = UIButton()

    // Esto es una propiedad computada, por lo que cogera el valor, en este caso, que reciba de la propiedad isEditing de la tabla. Las propiedades computadas toman el valor de lo que devuelva el bloque de codigo que se ejecuta dentro de ella
    private var isEditingMode: Bool {
        return tableView.isEditing
    }

    private let viewModel: InventoryViewModel

    var inventory: InventoryModel
    var cancellables: Set<AnyCancellable> = []


    // MARK: - Lifecycle

    init(inventory: InventoryModel, viewModel: InventoryViewModel) {
        self.inventory = inventory
        self.viewModel = viewModel
        //        self.isFromTrash = isFromTrash
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func listenViewModel() {
        viewModel.inventoryUpdatedSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { [weak self] updatedInventory in
            self?.inventory = updatedInventory
            self?.tableView.reloadData()
            self?.textField.text = ""
        }.store(in: &cancellables)
    }

    func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
            self.tableView.backgroundColor = color
        }.store(in: &cancellables)

        AppearanceViewModel.shared.boxCornerRadiusChangedSignal.sink { radius in
            self.textField.layer.cornerRadius = CGFloat(radius)
            self.recoverInventoryButton.layer.cornerRadius = CGFloat(radius)
            self.removeInventoryButton.layer.cornerRadius = CGFloat(radius)
            self.tableView.layer.cornerRadius = CGFloat(radius)
        }.store(in: &cancellables)
    }

    // MARK: - Setup UI

    func setupUI() {
        if inventory.isDeleted == true {
            view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            configureFunctionsFromTrashVC()
        } else {
            view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
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
        listenAppearanceViewModel()
        configureNavigationBar()
        updateFavoriteButton()
        hideKeyboard()
    }

    func configureFunctionsFromTrashVC() {
        configureMainStackViewForTrash()
        configureTableViewForTrash()
        configureRemoveInventoryButton()
        configureRecoverInventoryButton()
        listenAppearanceViewModel()
    }

    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboardAction))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboardAction() {
        view.endEditing(true)
    }

//    MARK: - ConfigureNavigationBar

    // Esta funcion sirve para configurar la NavigationBar con el menu de opciones y el boton de favorito
    private func configureNavigationBar() {
        let optionsMenu = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                          style: .plain,
                                          target: self,
                                          action:  nil)
        optionsMenu.menu = createOptionsMenu()

//        let favoriteImage = inventory.isFavorite ? "star.fill" : "star"
//        let favoriteImage = UIImage(systemName: imageName)
        let favoriteButton = UIBarButtonItem(image: nil,
                                             style: .plain,
                                             target: self,
                                             action: #selector(favoriteAction))
        navigationItem.rightBarButtonItems = [optionsMenu, favoriteButton]
    }

    //Esta funcion se encarga de configurar el menu que se abre al pulsar el boton de opciones en la NavigationBar
    private func createOptionsMenu() -> UIMenu {
        let deleteAction = UIAction(title: "Eliminar inventario",
                                    image: UIImage(systemName: "trash")) { action in
            self.moveInventoryToTrashButtonTapped()
        }

        let editButton = UIAction(title: "Editar", image: UIImage(systemName: "pencil")) { action in
            self.editButtonTapped()
        }

        let menu = UIMenu(children: [deleteAction, editButton])
        return menu
    }

    // Esta funcion es para que la NavigationBar se configure unicamente con el boton OK
    private func configureNavigationBarFromEditing() {
        let okButton = UIBarButtonItem(title: "OK",
                                       style: .plain,
                                       target: self,
                                       action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItems = [okButton]
    }

    // Esta funcion es para que al pulsar el boton Editar en la NavigationBar se configure segun la funcion configureNavigationBarFromEditing()
    private func editButtonTapped() {
        tableView.isEditing = true
        if isEditingMode == true {
            configureNavigationBarFromEditing()
            self.textField.isUserInteractionEnabled = false
        }
    }

    // Esta funcion se encarga de lo que ocurre al pulsar el boton OK cuando el modo Editar esta activo. Se vuelve a configurar la NavigationBar con el estilo predeterminado (configureNavigationBar()) y se vuelve a añadir el boton de favorito (updateFavoriteButton())
    @objc private func okButtonTapped() {
        tableView.isEditing = false
        if isEditingMode == false {
            configureNavigationBar()
            updateFavoriteButton()
            self.textField.isUserInteractionEnabled = true
        }
    }

    // Esta funcion se encarga de lo que ocurre al pulsar el boton de favorito, cambia el estado de la propiedad en el inventario y se actualiza la imagen del boton de favorito
    @objc private func favoriteAction() {
        viewModel.updateIsFavorite(in: inventory)
        updateFavoriteButton()
    }

    // Esta funcion se encarga de que la imagen del boton de favorito siempre refleje el estado de la propiedad isFavorite del inventario
    private func updateFavoriteButton() {
            if let favoriteButton = navigationItem.rightBarButtonItems?.first(where: { $0.action == #selector(favoriteAction) }) {
                favoriteButton.image = favoriteImage()
            }
        }

    // Esta funcion se encarga de asignar la imagen del boton de favorito de la NavigationBar
    private func favoriteImage() -> UIImage? {
        let imageName = inventory.isFavorite ? "star.fill" : "star"
            return UIImage(systemName: imageName)
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
        mainStackView.addArrangedSubview(tableView)
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
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(spacer2)
        mainStackView.addArrangedSubview(recoverInventoryButton)
        mainStackView.addArrangedSubview(spacer)
        mainStackView.addArrangedSubview(removeInventoryButton)
    }

//    MARK: - ConfigureTableView
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.masksToBounds = true
        tableView.isEditing = false
    }

//    MARK: - ConfigureTableViewForTrash
    private func configureTableViewForTrash() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellTest")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true

    }

//    MARK: - ConfigureTextField
    private func configureTextField() {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 35)
        ])
        textField.placeholder = "Agrega un nuevo elemento a tu inventario"
        textField.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        textField.layer.borderWidth = 2.5
        textField.font = .italicSystemFont(ofSize: 15)
        textField.textAlignment = .center
//        textField.borderStyle = .roundedRect
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            viewModel.newElement(from: inventory, elementTitle: text)
            }
//        textField.resignFirstResponder()
        return true
    }

//    MARK: - ConfigurationMoveInventoryToTrash

    func moveInventoryToTrash() {
        viewModel.updateIsDeleted(in: inventory)
    }

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

//    MARK: - ConfigurationRemoveInventory

    private func removeInventory() {
        viewModel.removeInventory(inventory)
    }

    private func configureRemoveInventoryButton() {
        removeInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        removeInventoryButton.addTarget(self, action: #selector(removeInventoryButtonTapped), for: .touchUpInside)
        removeInventoryButton.setTitle("Eliminar inventario", for: .normal)
        removeInventoryButton.titleLabel?.textAlignment = .center
        removeInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        removeInventoryButton.setTitleColor(.black, for: .normal)
        removeInventoryButton.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        removeInventoryButton.layer.borderWidth = 2.5
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

//MARK: - ConfigurationRecoverInventory

    private func recoverInventory() {
        viewModel.updateIsDeleted(in: inventory)
    }

    private func configureRecoverInventoryButton() {
        recoverInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recoverInventoryButton.addTarget(self, action: #selector(recoverInventoryButtonTapped), for: .touchUpInside)
        recoverInventoryButton.setTitle("Recuperar inventario", for: .normal)
        recoverInventoryButton.titleLabel?.textAlignment = .center
        recoverInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        recoverInventoryButton.setTitleColor(.black, for: .normal)
        recoverInventoryButton.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        recoverInventoryButton.layer.borderWidth = 2.5
    }

    @objc func recoverInventoryButtonTapped() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
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
        cellTest.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
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

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedElement = inventory.elements.remove(at: sourceIndexPath.row)
        inventory.elements.insert(movedElement, at: destinationIndexPath.row)
        viewModel.updateOrder(in: inventory)
    }
}

// MARK: - UITableViewDelegate

extension InventoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        proposedDestinationIndexPath
    }
}
