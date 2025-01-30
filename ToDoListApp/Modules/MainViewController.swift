import UIKit
import CoreData

protocol NewTaskViewControllerDelegate: AnyObject {
    func reloadData()
}
class MainViewController: UITableViewController, UISearchResultsUpdating {
    
    private var tasks: [Task] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var tasksCount = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
        setupSearchBar()
        setupFooterView()
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
       // loadTasks()
        fetchData()
          }

          // MARK: - Загрузка задач из JSON
          private func loadTasks() {
              JsonManager.shared.fetchTodos { [weak self] fetchedTasks in
                  self?.tasks = fetchedTasks
                  self?.tableView.reloadData()
                  self?.tasksCount = self?.tasks.count ?? 0
                  self?.setupFooterView()
                  
              }
          }
  
    func updateSearchResults(for searchController: UISearchController) {
            let searchText = searchController.searchBar.text ?? ""
            print("Ищем: \(searchText)")
        }
    private func setupFooterView() {
           let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
           footerView.backgroundColor = UIColor(hex: "#272729")
        
           let titleLabel = UILabel()
           titleLabel.text = "\(tasksCount) задач"
           titleLabel.textColor = .white
           titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
           titleLabel.textAlignment = .center

           let actionButton = UIButton(type: .system)
           
        actionButton.setImage(UIImage(systemName:"square.and.pencil"), for: .normal)
           actionButton.setTitleColor(.white, for: .normal)
        actionButton.tintColor = .darkYellow
           actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           actionButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)

           footerView.addSubview(titleLabel)
           footerView.addSubview(actionButton)

           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           actionButton.translatesAutoresizingMaskIntoConstraints = false

         
           NSLayoutConstraint.activate([
              
               titleLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
               titleLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

               
               actionButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
               actionButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
           ])

           tableView.tableFooterView = footerView
       }

       @objc private func addTaskTapped() {
           print("Кнопка 'Добавить' нажата ✅")
           
           let vc = NewTaskViewController()
           vc.delegate = self
           navigationController?.pushViewController(vc, animated: true)
       }
    private func fetchData() {
        let storageManager = StorageManager.shared
        let context = storageManager.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let fetchedTasks = try context.fetch(fetchRequest)
        
            tasks = fetchedTasks.map { taskEntity in
                Task(
                    title: taskEntity.title ?? "Без названия",
                    description: taskEntity.taskDescription ?? "Нет описания",
                    date: taskEntity.taskDate ?? "Нет даты",
                    completed: false
                )
            }

            tasksCount = tasks.count

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Ошибка загрузки данных: \(error.localizedDescription)")
        }
        setupFooterView()
        tableView.reloadData()
    }
    private func fetchTaskEntity(by title: String) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            let tasks = try StorageManager.shared.context.fetch(fetchRequest)
            return tasks.first
        } catch {
            print("Ошибка при поиске задачи: \(error.localizedDescription)")
            return nil
        }
    }

    
}
// MARK: - Setup UI
private extension MainViewController {
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
        backButton.tintColor = .darkYellow
           navigationItem.backBarButtonItem = backButton

    }
    func setupSearchBar() {
          searchController.searchResultsUpdater = self
          searchController.obscuresBackgroundDuringPresentation = false
          searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white

          let searchTextField = searchController.searchBar.searchTextField
          searchTextField.textColor = UIColor.white
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

             
               let microphoneButton = UIButton(type: .custom)
               let micIcon = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
               microphoneButton.setImage(micIcon, for: .normal)
               microphoneButton.tintColor = UIColor(hex: "#F4F4F4")
               microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)

             
               let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
               containerView.addSubview(microphoneButton)
               microphoneButton.center = containerView.center

             
               searchTextField.rightView = containerView
               searchTextField.rightViewMode = .always

               navigationItem.searchController = searchController
               navigationItem.hidesSearchBarWhenScrolling = false
           }


      @objc func microphoneTapped() {
          print("Microphone Tapped 🎤")
         
      }
  }
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
               cell.configure(title: task.title, description: task.description, date: task.date)
               cell.backgroundColor = .clear
               return cell
       }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OpenTaskViewController()
        vc.titleLabel.text = tasks[indexPath.row].title
        vc.descriptionLabel.text = tasks[indexPath.row].description
        vc.dateLabel.text = tasks[indexPath.row].date
        
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            
         
            let storageManager = StorageManager.shared
            if let taskEntity = fetchTaskEntity(by: taskToDelete.title) {
                storageManager.deleteTask(taskEntity)
            }

            tasks.remove(at: indexPath.row)
            tasksCount = tasks.count
            setupFooterView()

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    
}
extension MainViewController: NewTaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
     
    }
}

  




