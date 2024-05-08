import UIKit

enum Options: CaseIterable {
    case appearanceSettings
    case lenguageSetting
}

class SettingsViewController: UIViewController {


    //MARK: - Properties

    let mainStackView = UIStackView()
    let tableView = UITableView()


    //MARK: - Life Cycle

    override func viewDidLoad() {
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white
        configureMainStackView()
        configureTableView()
    }

    //MARK: - Configure Views

    func configureMainStackView() {
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

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
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

        cell.textLabel?.text = "\(option)"

        cell.backgroundColor = .yellow
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
