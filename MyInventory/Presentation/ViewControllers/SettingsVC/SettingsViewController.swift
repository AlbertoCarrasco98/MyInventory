import UIKit
import Combine

class SettingsViewController: UIViewController {


    //MARK: - Properties

    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private var cancellables: [AnyCancellable] = []


    //MARK: - Life Cycle

    override func viewDidLoad() {
        setupUI()
    }

    private func setupUI() {
        self.title = "Ajustes"
        configureMainStackView()
        configureTableView()
        listenAppearanceViewModel()
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
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
        tableView.backgroundColor = .clear
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
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
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
            default:
                break
        }
    }
}

extension SettingsViewController {
    enum Options: CaseIterable {
        case appearanceSettings

        var title: String {
            switch self {
                case .appearanceSettings:
                    return "Ajustes de apariencia"
            }
        }
    }
}
