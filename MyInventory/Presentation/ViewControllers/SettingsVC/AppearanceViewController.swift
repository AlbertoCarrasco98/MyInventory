import UIKit
import Combine

class AppearanceViewController: UIViewController {

    //   MARK: - Properties

    var cancellables: Set<AnyCancellable> = []
    let mainStackView = UIStackView()
    let tableView = UITableView()
    let exampleLabel = UILabel()

//     MARK: - LifeCycle

    override func loadView() {
        super.loadView()
        setupUI()
    }

    private func setupUI() {
        listenAppearanceViewModel()
        configureMainStackView()
        configureTableView()
        view.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }

    private func listenAppearanceViewModel() {
        AppearanceViewModel.shared.backgroundStateSignal.sink { color in
            self.view.backgroundColor = color
            self.tableView.backgroundColor = color
            self.tableView.reloadData()
        }.store(in: &cancellables)

        AppearanceViewModel.shared.boxCornerRadiusChangedSignal.sink { radius in
            self.exampleLabel.layer.cornerRadius = CGFloat(AppearanceViewModel.shared.appearanceModel.boxCornerRadius)
        }.store(in: &cancellables)
    }

    // MARK: - Configure Views

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 24),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
        mainStackView.backgroundColor = .blue
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
    }

    private func presentModal() {
        let modalViewController = UIViewController()
        modalViewController.modalPresentationStyle = .pageSheet
        modalViewController.view.backgroundColor = UIColor(white: 1, alpha: 0.88)

        if let sheet = modalViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cerrar", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        modalViewController.view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: modalViewController.view.topAnchor, constant: 12),
            modalViewController.view.trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 16)
        ])

        exampleLabel.layer.borderWidth = 2.5
        exampleLabel.layer.borderColor = UIColor(red: 0.549, green: 0.729, blue: 0.831, alpha: 1.0).cgColor
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false


        let slider = UISlider()
        slider.maximumValue = 0
        slider.maximumValue = 10
        slider.value = AppearanceViewModel.shared.appearanceModel.boxCornerRadius
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false

        let sliderValueLabel =  UILabel()
        sliderValueLabel.text = String(format: "%.f", slider.value)
        sliderValueLabel.translatesAutoresizingMaskIntoConstraints = false

        modalViewController.view.addSubview(slider)
        modalViewController.view.addSubview(sliderValueLabel)
        modalViewController.view.addSubview(exampleLabel)

        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: modalViewController.view.centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: modalViewController.view.centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: modalViewController.view.leadingAnchor, constant: 20),
            modalViewController.view.trailingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 20),

            sliderValueLabel.centerXAnchor.constraint(equalTo: modalViewController.view.centerXAnchor),
            sliderValueLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),

            exampleLabel.centerXAnchor.constraint(equalTo: modalViewController.view.centerXAnchor),
            exampleLabel.topAnchor.constraint(equalTo: modalViewController.view.topAnchor, constant: 150),
            exampleLabel.widthAnchor.constraint(equalToConstant: 300),
            exampleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        present(modalViewController, animated: true)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {

        let newValue = Int(sender.value)

        AppearanceViewModel.shared.setCornerRadius(newValue)

        if let modalView = presentedViewController?.view,
           let sliderValueLabel = modalView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            sliderValueLabel.text = String(format: "%.f", sender.value)
        }
    }
}

// MARK: - UITableViewDataSource

extension AppearanceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentOption = Section(rawValue: section) else { return 0 }
        switch currentOption {
            case .dayNightMode:
                return 3
            case .cornerRadius:
                return 1
            case .background:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        switch section {
            case .dayNightMode:
                guard let dayNightModeCell = CellDayNightMode(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = dayNightModeCell.title

            case .cornerRadius:
                guard let boxCornerRadiusCell = CellCornerRadius(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = boxCornerRadiusCell.title
                cell.accessoryType = .disclosureIndicator

            case .background:
                guard let backgroundModeCell = CellBackground(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = backgroundModeCell.title
                cell.accessoryType = .disclosureIndicator
        }
        cell.backgroundColor = AppearanceViewModel.shared.appearanceModel.backgroundColor
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
}

// MARK: - UITableViewDelegate

extension AppearanceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {

            case .dayNightMode:
                break
            case .cornerRadius:
                presentModal()
            case .background:
                let wallpaperVC = WallpaperViewController()
                self.navigationController?.pushViewController(wallpaperVC, animated: true)
        }
    }
}

//MARK: - TableViewSection

extension AppearanceViewController {

    enum Section: Int, CaseIterable {
        case dayNightMode
        case cornerRadius
        case background

        var title: String {
            switch self {
                case .dayNightMode: return "Aspecto"
                case .cornerRadius: return "Estilo de borde"
                case .background: return "Fondo de pantalla"
            }
        }
    }

    enum CellDayNightMode: Int {
        case day
        case night
        case automatic

        var title: String {
            switch self {
                case .day:
                    return "Día"
                case .night:
                    return "Noche"
                case .automatic:
                    return "Automático"
            }
        }
    }

    enum CellCornerRadius: Int {
        case boxCornerRadius

        var title: String {
            switch self {
                case .boxCornerRadius:
                    return "Cambiar el estilo de borde"
            }
        }
    }

    enum CellBackground: Int {
        case background

        var title: String {
            switch self {

                case .background:
                    return "Cambiar el color de fondo"
            }
        }
    }
}
