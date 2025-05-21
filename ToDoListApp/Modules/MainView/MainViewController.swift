import UIKit

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    private var isSearching: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    private(set) var searchController = UISearchController(searchResultsController: nil)
    private let footerView = UIView()
    private let titleLabel = UILabel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startLoading()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    private func setupView() {
        title = "Задачи"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .black
        setupNavigationBar()
        setupFooterView()
        setupUI()
        setupSearchBar()
    }
    
    func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        backButton.tintColor = UIColor(hex: "#FED702")
        navigationItem.backBarButtonItem = backButton
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        
        let searchTextField = searchController.searchBar.searchTextField
        
        searchTextField.backgroundColor = UIColor(hex: "#272729")
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#717190")
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        
        
        if let leftIconView = searchTextField.leftView as? UIImageView {
            leftIconView.image = leftIconView.image?.withRenderingMode(.alwaysTemplate)
            leftIconView.tintColor = UIColor(hex: "#717190")
        }
        
        searchTextField.rightViewMode = .always
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupFooterView() {
        
        footerView.backgroundColor = UIColor(hex: "#272729")
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        footerView.subviews.forEach { $0.removeFromSuperview() }
        
        titleLabel.text = "\(presenter.tasks.count) задач"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let actionButton = UIButton(type: .system)
        actionButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        actionButton.tintColor = UIColor(hex: "#FED702")
        actionButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)
        
        footerView.addSubview(titleLabel)
        footerView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 83),
            
            titleLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -83),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
        setupFooterView()
    }
    
    @objc func addTaskTapped() {
        presenter.addTaskTapped()
    }
    func startLoading() {
        DispatchQueue.main.async {
            
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        
        let task = presenter.filteredTasks[indexPath.row]
        
        cell.configure(with: task, at: indexPath)
        cell.delegate = self
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            
            let task = presenter.filteredTasks[indexPath.row]
            
            guard let taskEntity = presenter.taskEntityes.first(where: {
                $0.title == task.title &&
                $0.taskDescription == task.description &&
                $0.taskDate == task.date
            }) else {
                print("Ошибка: задача не найдена в полном списке")
                return
            }
            
            presenter.openTaskDetails(taskEntity)
        } else {
            
            guard let taskEntity = presenter.getTaskEntity(at: indexPath.row) else {
                print("Ошибка: задача не найдена")
                return
            }
            presenter.openTaskDetails(taskEntity)
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteTask(at: indexPath.row)
        }
    }
}


// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        
        if query.isEmpty {
            presenter.resetSearch()
        } else {
            presenter.searchTask(with: query)
        }
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func reloadData() {
        tableView.reloadData()
        setupFooterView()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: false)
    }
}
extension MainViewController: TaskCellDelegate {
    func didUpdateTaskCompletion(at indexPath: IndexPath, completed: Bool) {
        presenter.toggleTaskCompletion(at: indexPath.row)
    }
    
}

