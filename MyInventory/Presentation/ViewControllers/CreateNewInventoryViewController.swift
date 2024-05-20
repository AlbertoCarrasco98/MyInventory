import UIKit
import Combine

class CreateNewInventoryViewController: UIViewController, UITextFieldDelegate {

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

    private func listenViewModel() {
        viewModel.inventoryListUpdatedSignal.sink { _ in
        } receiveValue: { _ in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
            self.textField.layer.cornerRadius = CGFloat(AppearanceViewModel.shared.appearanceModel.boxCornerRadius)
        }.store(in: &cancellables)
    }

    // MARK: - Setup UI

    private func setupUI() {
        self.title = "Nuevo inventario"
        view.backgroundColor = .white
        configureNavigationBar()
        configureTextField()
        listenViewModel()
        listenAppearanceViewModel()
    }

    private func processInventoryCreation() {
        let inventoryTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if !inventoryTitle.isEmpty {
            let result = viewModel.createNewInventory(title: inventoryTitle, elements: [])
            switch result {
                case .success:
                    print("Inventario creado con exito")
                case .failure:
                    showAlert(messaje: "Ya existe un inventario con ese título")
            }
        }
    }

    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crear", style: .done, target: self, action: #selector(createInventoryAction))
    }

    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func createInventoryAction() {
        processInventoryCreation()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processInventoryCreation()
        textField.resignFirstResponder()
        return true
    }

    private func showAlert(messaje: String) {
        let alertController = UIAlertController(title: "No se pudo crear el inventario", message: messaje, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - TextField Configuration

    private func configureTextField() {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            view.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 24)
        ])
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.placeholder = "*Ponle un título a tu inventario"
        textField.font = .italicSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        textField.layer.borderWidth = 2.5
        textField.backgroundColor = .systemGray6
    }
}
