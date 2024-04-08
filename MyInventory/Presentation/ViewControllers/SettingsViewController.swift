import UIKit

class SettingsViewController: UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .white
        configureLabel()
    }

    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Pantalla de ajustes"
    }
}
