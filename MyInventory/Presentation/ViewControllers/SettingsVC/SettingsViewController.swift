import UIKit
import Combine

class SettingsViewController: UIViewController {


    //MARK: - Properties

    let mainStackView = UIStackView()
    let tableView = UITableView()
    var cancellables: [AnyCancellable] = []


    //MARK: - Life Cycle

    override func viewDidLoad() {
        setupUI()
    }

    private func setupUI() {
        self.title = "Ajustes"
        configureMainStackView()
        listenAppearanceViewModel()
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
        configureTableView()
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
            self.tableView.backgroundColor = color
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }

    //MARK: - Configure Views

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }
}

//MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Options.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        let option = Options.allCases[indexPath.row]
        cell.textLabel?.text = option.title
        cell.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
                let appearanceVC = AppearanceViewController()
                appearanceVC.title = "Apariencia"
                navigationController?.pushViewController(appearanceVC, animated: true)

                // case 1:

            default:
                break
        }
    }
}

extension SettingsViewController {
    enum Options: CaseIterable {
        case appearanceSettings
        case lenguageSetting

        var title: String {
            switch self {
                case .appearanceSettings:
                    return "Ajustes de apariencia"
                case .lenguageSetting:
                    return "Ajustes de idioma"
            }
        }
    }
}
