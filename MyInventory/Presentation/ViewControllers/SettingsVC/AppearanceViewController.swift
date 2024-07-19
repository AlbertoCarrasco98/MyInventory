import UIKit
import Combine

class AppearanceViewController: UIViewController {

    //   MARK: - Properties

    var cancellables: Set<AnyCancellable> = []
    let mainStackView = UIStackView()
    let tableView = UITableView()
    let exampleLabel = UILabel()
    let restoreAppearanceButton = UIButton()

    var userInterfaceStyle: UIUserInterfaceStyle {
        traitCollection.userInterfaceStyle
    }

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

        AppearanceViewModel.shared.backgroundStateSignal
            .sink { [weak self] color in
                guard let self else { return }
                self.view.backgroundColor = color
            }
            .store(in: &cancellables)

        AppearanceViewModel.shared.boxCornerRadiusChangedSignal
            .sink { [weak self] radius in
                guard let self else { return }
                self.exampleLabel.layer.cornerRadius = CGFloat(AppearanceViewModel.shared.appearanceModel.boxCornerRadius)
                self.restoreAppearanceButton.layer.cornerRadius = CGFloat(radius)
            }
            .store(in: &cancellables)

        AppearanceViewModel.shared.interfaceStyleSignal
            .sink { [weak self] appearanceStyle in
                guard let self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Configure Views

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(restoreAppearanceButton)
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 8),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ListTableCell.reuseIdentifier)
        tableView.backgroundColor = .clear
    }

    private func configureRestoreAppearanceButton() {
        restoreAppearanceButton.addTarget(self,
                                          action: #selector(restoreAppearanceButtonTapped),
                                          for: .touchUpInside)
        restoreAppearanceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restoreAppearanceButton.backgroundColor = .white
        restoreAppearanceButton.setTitle("Restablecer ajustes de apariencia",
                                         for: .normal)
        restoreAppearanceButton.titleLabel?.textAlignment = .center
        restoreAppearanceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        restoreAppearanceButton.setTitleColor(.black,
                                              for: .normal)
        restoreAppearanceButton.layer.borderColor = UIColor(red: 0.549,
                                                            green: 0.729,
                                                            blue: 0.831,
                                                            alpha: 1.0).cgColor
        restoreAppearanceButton.layer.borderWidth = 2
        restoreAppearanceButton.layer.cornerRadius = CGFloat(AppearanceViewModel.shared.appearanceModel.boxCornerRadius)
        restoreAppearanceButton.layer.masksToBounds = true
    }

    private func setupNavigationBar() {
        let restoreAppearanceSettingButton = UIBarButtonItem(title: "Restablecer",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(restoreAppearanceButtonTapped))
        navigationItem.rightBarButtonItem = restoreAppearanceSettingButton
    }

    private func showAlertToRestoreAppearanceSettings() {
        let alert = UIAlertController(title: "",
                                      message: "¿Estás seguro de que deseas restablecer los ajustes de apariencia?",
                                      preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Cancelar",
                                        style: .cancel,
                                        handler: nil)
        let alertAction = UIAlertAction(title: "Restablecer",
                                        style: .destructive) { [self] _ in
            AppearanceViewModel.shared.restoreAppearanceSettings()
            self.view.showToast(withMessage: "Ajustes de apariencia restablecidos",
                                color: .success,
                                position: .bottom)
            tableView.reloadData()
        }

        alert.addAction(cancelAlert)
        alert.addAction(alertAction)

        self.present(alert,
                     animated: true)
    }

    @objc func restoreAppearanceButtonTapped() {
        showAlertToRestoreAppearanceSettings()
    }

    private func presentModal() {
        let modalViewController = UIViewController()
        modalViewController.modalPresentationStyle = .pageSheet
        modalViewController.view.backgroundColor = UIColor(white: 1, alpha: 1)

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
        AppearanceViewModel.shared.setCornerRadius(sender.value)
        tableView.reloadData()

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
            case .restoreAppearance:
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

                let appearanceModeState = AppearanceViewModel.shared.appearanceModel.interfaceStyle

                cell.isUserInteractionEnabled = true
                cell.contentView.alpha = 1

                switch appearanceModeState {
                    case .automatic:
                        if dayNightModeCell == .automatic {
                            cell.isUserInteractionEnabled = false
                            cell.accessoryType = .checkmark
                            cell.contentView.alpha = 0.4
                        }
                    case .light:
                        if dayNightModeCell == .day {
                            cell.isUserInteractionEnabled = false
                            cell.accessoryType = .checkmark
                            cell.contentView.alpha = 0.4
                        }
                    case .dark:
                        if dayNightModeCell == .night {
                            cell.isUserInteractionEnabled = false
                            cell.accessoryType = .checkmark
                            cell.contentView.alpha = 0.4
                        }
                }

            case .cornerRadius:
                guard let boxCornerRadiusCell = CellCornerRadius(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = boxCornerRadiusCell.title
                cell.accessoryType = .disclosureIndicator

            case .background:
                guard let backgroundModeCell = CellBackground(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = backgroundModeCell.title
                cell.accessoryType = .disclosureIndicator

            case .restoreAppearance:
                guard let restoreAppearanceCell = CellRestoreAppearance(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = restoreAppearanceCell.title
                cell.textLabel?.textColor = .red
                if AppearanceViewModel.shared.appearanceModel.thisAppearanceModelHasDefaultValues {
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.textColor = .systemGray
                }
        }
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
}

// MARK: - UITableViewDelegate

enum DayNightOption: Int {
    case day
    case night
    case automatic
}

extension AppearanceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {

            case .dayNightMode:
                let dayNightOption = DayNightOption(rawValue: indexPath.row)

                switch dayNightOption {
                    case .day:
                        if CellDayNightMode(rawValue: indexPath.row) != nil {
                            AppearanceViewModel.shared.disableDarkMode()
                        }
                    case .night:
                        if CellDayNightMode(rawValue: indexPath.row) != nil {
                            AppearanceViewModel.shared.enableDarkMode()
                        }
                    case .automatic:
                        AppearanceViewModel.shared.restoreAppearanceStyle()

                    case nil:
                        break
                }

            case .cornerRadius:
                presentModal()

            case .background:
                let wallpaperVC = WallpaperViewController()
                wallpaperVC.title = "Fondo de pantalla"
                self.navigationController?.pushViewController(wallpaperVC, animated: true)

            case .restoreAppearance:
                restoreAppearanceButtonTapped()
        }
        tableView.reloadData()
    }
}

//MARK: - TableViewSection

extension AppearanceViewController {

    enum Section: Int, CaseIterable {
        case dayNightMode
        case cornerRadius
        case background
        case restoreAppearance

        var title: String {
            switch self {
                case .dayNightMode: return "Aspecto"
                case .cornerRadius: return "Estilo de borde"
                case .background: return "Fondo de pantalla"
                case .restoreAppearance: return " "
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

    enum CellRestoreAppearance: Int {
        case restoreAppearance

        var title: String {
            switch self {
                case .restoreAppearance:
                    return "Restablecer ajustes de apariencia"
            }
        }
    }
}
