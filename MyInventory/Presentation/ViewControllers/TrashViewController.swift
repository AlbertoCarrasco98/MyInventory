import UIKit

class TrashViewController: UIViewController {

    private let mainStackView = UIStackView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1.0)
        self.title = "Papelera"
        view.addSubview(mainStackView)
        configureMainStackView()
    }

    private func configureMainStackView() {
        mainStackView.addArrangedSubview(tableView)
        configureTableView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.backgroundColor = .orange
    }
}
