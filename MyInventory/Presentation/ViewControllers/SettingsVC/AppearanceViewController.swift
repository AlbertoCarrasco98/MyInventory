import UIKit
import Combine

class AppearanceViewController: UIViewController {

    //   MARK: Properties

//    let appearanceViewModel: AppearanceViewModel
    var cancellables: Set<AnyCancellable> = []
    let mainStackView = UIStackView()
    let tableView = UITableView()

//    init(appearanceViewModel: AppearanceViewModel) {
//        self.appearanceViewModel = appearanceViewModel
//        super.init(nibName: nil, bundle: nil)
//    }

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func loadView() {
        super.loadView()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .orange
        configureMainStackView()
        configureTableView()
    }

//    private func listenAppearanceViewModel() {
//        appearanceViewModel.isDarkModeEnabledState
//            .sink { isEnabled in
//                
//            }
//            .store(in: &cancellables)
//
//        appearanceViewModel.boxCornerRadiusState
//            .sink { value in
//
//            }
//            .store(in: &cancellables)
//
//        appearanceViewModel.backgroundColorState
//            .sink { color in
//
//            }
//            .store(in: &cancellables)
//    }

    // MARK: Configure Views

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
        tableView.backgroundColor = .yellow
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
            case .fontType:
                return 4
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

            case .fontType:
                guard let fontTypeModeCell = CellFontType(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = fontTypeModeCell.title

            case .background:
                guard let backgroundModeCell = CellBackground(rawValue: indexPath.row) else { return .init() }
                cell.textLabel?.text = backgroundModeCell.title

        }
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
            case .fontType:
                break
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
        case fontType
        case background

        var title: String {
            switch self {
                case .dayNightMode: return "Aspecto"
                case .fontType: return "Tipo de texto"
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

    enum CellFontType: Int {
        case tipo1
        case tipo2
        case tipo3
        case tipo4

        var title: String {
            switch self {

                case .tipo1:
                    return "Tipo 1"
                case .tipo2:
                    return "Tipo 2"
                case .tipo3:
                    return "Tipo 3"
                case .tipo4:
                    return "Tipo 4"
            }
        }
    }

    enum CellBackground: Int {
        case background

        var title: String {
            switch self {

                case .background:
                    return "Elige un fondo de pantalla"
            }
        }
    }
}
