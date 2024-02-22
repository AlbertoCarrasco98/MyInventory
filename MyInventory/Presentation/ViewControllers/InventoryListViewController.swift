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

    private var filteredInventories: [InventoryModel] = []

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
        filteredInventories = viewModel.inventoryList
    }

    // BIND -> Crea una conexión entre el ViewController y el ViewModel
    func listenViewModel() {
        viewModel.newInventorySignal.sink { _ in

        } receiveValue: { _ in

            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryDeletedSignal.sink { _ in
            // No hacemos nada
        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.inventoryDidChangeSignal.sink { _ in

        } receiveValue: { _ in
            self.collectionView.reloadData()
        }.store(in: &cancellables)

    }

    // MARK: - SetupUI

    private func setupUI() {
        view.backgroundColor = .white
        self.title = "Inventarios"
        configureMainStackView()
        configureCollectionView()
        configureTextField()
        configureAddInventoryButton()
        listenViewModel()
        viewModel.loadData()
        navigationItem.backButtonTitle = "Atrás"
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
            view.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 24)
        ])
    }

    // MARK: - ConfigureCollectionView

    private func configureCollectionView() {
        //        mainStackView.addArrangedSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        let layout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        self.collectionView.register(SectionHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
    }

    // MARK: - ConfigureAddInventoryButton

    private func configureAddInventoryButton() {
        addInventoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        addInventoryButton.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -32).isActive = true
        addInventoryButton.addTarget(self, action: #selector(addInventoryButtonTapped), for: .touchUpInside)
        addInventoryButton.setTitle("Crea un nuevo inventario", for: .normal)
        addInventoryButton.titleLabel?.textAlignment = .center
        addInventoryButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addInventoryButton.setTitleColor(.black, for: .normal)
        addInventoryButton.layer.borderColor = UIColor.lightGray.cgColor
        addInventoryButton.layer.borderWidth = 2
        addInventoryButton.layer.cornerRadius = 10
    }

    @objc func addInventoryButtonTapped() {
        let createNewInventoryVC = CreateNewInventoryViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(createNewInventoryVC, animated: true)
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
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        filterInventories(text: searchText)
    }

    private func filterInventories(text: String) {
        if text.isEmpty {
            filteredInventories = viewModel.inventoryList
        } else {
            filteredInventories = viewModel.inventoryList.filter {
                $0.title.lowercased().hasPrefix(text.lowercased())
            }
        }
        reloadCollectionView()
    }

    private func reloadCollectionView() {
        DispatchQueue.main.async {
            [ weak self ] in self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension InventoryListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        InventoryListSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            let favoriteInventories = viewModel.inventoryList.filter { $0.isFavorite }
            return favoriteInventories.count
        } else if section == 1 {
            let nonFavoritesInventories = viewModel.inventoryList.filter { !$0.isFavorite }
            return nonFavoritesInventories.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell",
                                                        for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        let filteredInventory: [InventoryModel]

        switch indexPath.section {
            case 0:
               filteredInventory = viewModel.inventoryList.filter { $0.isFavorite }
            case 1:
               filteredInventory = viewModel.inventoryList.filter { !$0.isFavorite }
            default:
                filteredInventory = []
        }

        guard indexPath.row < filteredInventory.count else {
            return cell
        }

        let inventory = filteredInventory[indexPath.row]

        cell.backgroundColor = .systemGray3
//        let inventory = viewModel.inventoryList[indexPath.row]
        cell.label.text = inventory.title
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = InventoryListSection(rawValue: indexPath.section) else { return }
        var selectedInventory: InventoryModel

        switch section {
            case .favorites:
                selectedInventory = viewModel.inventoryList.filter { $0.isFavorite }[indexPath.row]
            case .nonFavorites:
                selectedInventory = viewModel.inventoryList.filter { !$0.isFavorite }[indexPath.row]
        }
        let inventoryDetailVC = InventoryDetailViewController(inventory: selectedInventory,
                                                              viewModel: viewModel)
        self.navigationController?.pushViewController(inventoryDetailVC, animated: true)
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
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.width / 3 - 7
        let height: CGFloat = 100
        return CGSize(width: widht, height: height)
    }
}

// MARK: - UICollectionViewCell

// Deberia tener la customCell en un archivo a parte??

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


class SectionHeader: UICollectionReusableView {
     var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .black
         label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.sizeToFit()
         return label
     }()

     override init(frame: CGRect) {
         super.init(frame: frame)

         addSubview(label)

         label.translatesAutoresizingMaskIntoConstraints = false
         label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
         label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
         label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
