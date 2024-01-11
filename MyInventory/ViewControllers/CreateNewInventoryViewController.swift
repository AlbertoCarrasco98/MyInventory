import UIKit
import Combine

class CreateNewInventoryViewController: UIViewController {

    // MARK: - Properties

    private let mainStackView = UIStackView()
    private let textField = UITextField()
    private let viewModel: InventoryViewModel
    private var cancellables: Set<AnyCancellable> = []

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
    }

    func listenViewModel() {
        viewModel.newInventorySignal.sink { _ in
            // No hacemos nada
        } receiveValue: { _ in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }

    // MARK: - Setup UI

    func setupUI() {
        self.title = "Nuevo inventario"
        view.backgroundColor = .white
        configureNavigationBar()
        configureTextField()
        listenViewModel()
    }

    // MARK: - Navigation Bar Configuration

    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crear", style: .done, target: self, action: #selector(createInventoryAction))
    }

    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func createInventoryAction() {
        let inventoryTitle = textField.text ?? ""
        if !inventoryTitle.isEmpty {
            viewModel.createNewInventory(title: inventoryTitle, elements: [])
        } else {
            print("Error al crear el inventario")
        }
    }

    // MARK: - TextField Configuration

    func configureTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            view.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 24)
        ])
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.placeholder = "*Ponle un título a tu inventario"
        textField.font = .italicSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
    }
}
