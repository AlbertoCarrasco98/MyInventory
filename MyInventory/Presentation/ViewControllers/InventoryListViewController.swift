import UIKit
import Combine

enum InventoryListSection: Int, CaseIterable {
    case favorites
    case nonFavorites
}

class InventoryListViewController: UIViewController, UITextFieldDelegate {

    private let viewModel: InventoryViewModel

    // MARK: - Properties
    private let mainStackView = UIStackView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let addInventoryButton = UIButton()
    private let textField = UITextField()
    private var searchText: String? {
        textField.text
    }
    private var filteredInventories: [InventoryModel] {
        if let text = searchText, !text.isEmpty {
            return viewModel.inventoryList.filter { $0.title.lowercased().contains(text.lowercased()) && !$0.isDeleted }
        } else {
            return viewModel.inventoryList.filter { !$0.isDeleted }
        }
        //            let filter = viewModel.inventoryList.filter { inventory in
        //                inventory.title.lowercased().contains(text.lowercased()) && !inventory.isDeleted }
        //
        //            return filter
        //        } else {
        //            return viewModel.inventoryList.filter { !$0.isFavorite }
        //        }
    }

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
    }

    // BIND -> Crea una conexión entre el ViewController y el ViewModel
    func listenViewModel() {
        viewModel.inventoryListUpdatedSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryUpdatedSignal.sink { _ in
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)
    }

    // MARK: - SetupUI

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
        self.title = "Inventarios"
        viewModel.loadData()
        listenViewModel()
        setupNavigationBar()
        configureMainStackView()
        configureCollectionView()
        configureTextField()
        configureAddInventoryButton()
        navigationItem.backButtonTitle = "Atrás"
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    // MARK: - ConfigureMainStackView

    private func configureMainStackView() {
        let spacer = UIView()
        let spacer1 = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 12).isActive = true
        spacer1.heightAnchor.constraint(equalToConstant: 12).isActive = true
        view.addSubview(mainStackView)
        // Meter en un array las vistas
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(spacer)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(addInventoryButton)
        mainStackView.addArrangedSubview(spacer1)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            //            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 24)
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    // MARK: - ConfigureCollectionView

    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
//        collectionView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: "CustomCollectionViewCell")
        self.collectionView.register(SectionHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
    }

    // MARK: - ConfigureAddInventoryButton

    private func configureAddInventoryButton() {
        addInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addInventoryButton.addTarget(self, action: #selector(addInventoryButtonTapped), for: .touchUpInside)
        addInventoryButton.setTitle("Crea un nuevo inventario", for: .normal)
        addInventoryButton.titleLabel?.textAlignment = .center
        addInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addInventoryButton.setTitleColor(.black, for: .normal)
        addInventoryButton.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        addInventoryButton.layer.borderWidth = 2
        addInventoryButton.layer.cornerRadius = 10
    }

    @objc func addInventoryButtonTapped() {
        let createNewInventoryVC = CreateNewInventoryViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(createNewInventoryVC, animated: true)
        UIView.animate(withDuration: 0, animations: {
            // Cambiar el tamaño del botón
            self.addInventoryButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            // Restaurar el tamaño original del botón después de la animación
            UIView.animate(withDuration: 0) {
                self.addInventoryButton.transform = CGAffineTransform.identity
            }
        }
    }

    // MARK: - ConfigureTextField

    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        textField.delegate = self
        textField.placeholder = "Busca un inventario"
        textField.font = .italicSystemFont(ofSize: 18)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 2.5
        textField.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        //        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension InventoryListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        InventoryListSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            let favoriteInventories = filteredInventories.filter { $0.isFavorite }
            return favoriteInventories.count
        } else if section == 1 {
            let nonFavoritesInventories = filteredInventories.filter { !$0.isFavorite }
            return nonFavoritesInventories.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell",
                                                            for: indexPath) as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let filteredInventory: [InventoryModel]
        switch indexPath.section {
            case 0:
                filteredInventory = filteredInventories.filter { $0.isFavorite }
            case 1:
                filteredInventory = filteredInventories.filter { !$0.isFavorite }
            default:
                filteredInventory = []
        }
        guard indexPath.row < filteredInventory.count else {
            return cell
        }

        let inventory = filteredInventory[indexPath.row]
        cell.label.text = inventory.title
        cell.layer.cornerRadius = 18
        cell.layer.masksToBounds = true // Esto asegura que cualquier subvista dentro del "layer" se vean afectadas por las esquinas redondeadas y se recortaran                                            segun la forma del layer
        cell.backgroundColor = UIColor(red: 255/255, green: 187/255, blue: 150/255, alpha: 0.8)
        cell.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        cell.layer.borderWidth = 2.5
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let section = InventoryListSection(rawValue: indexPath.section) else { return }
        var selectedInventory: InventoryModel

        switch section {
            case .favorites:
                selectedInventory = filteredInventories.filter { $0.isFavorite }[indexPath.row]
            case .nonFavorites:
                selectedInventory = filteredInventories.filter { !$0.isFavorite }[indexPath.row]
        }
        let inventoryDetailVC = InventoryDetailViewController(inventory: selectedInventory,
                                                              viewModel: viewModel)
        self.navigationController?.pushViewController(inventoryDetailVC,
                                                      animated: true)
        inventoryDetailVC.title = selectedInventory.title
    }
}

// MARK: - UICollectionViewDelegate
extension InventoryListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            if indexPath.section == 0 {
                sectionHeader.label.text = "Favoritos"

            } else if indexPath.section == 1 {
                sectionHeader.label.text = "No Favoritos"
            }
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    } // Tamaño de la label de cada seccion

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.width
        let height: CGFloat = 45
        return CGSize(width: widht, height: height)
    }
}
