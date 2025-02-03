import Foundation

// MARK: - View -> Presenter
protocol MainViewProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func startLoading() 
    func stopLoading()
}

// MARK: - Presenter -> View

protocol MainPresenterProtocol: AnyObject {
    var tasks: [Task] { get }
    var taskEntityes: [TaskEntity] { get }
    var filteredTasks: [Task] { get }
    func viewDidLoad()
    func addTaskTapped()
    func searchTask(with query: String)
    func deleteTask(at index: Int)
    func toggleTaskCompletion(at index: Int)
    func resetSearch()
    func getTaskEntity(at index: Int) -> TaskEntity?
    func openTaskDetails(_ task: TaskEntity)
    func setTasks(_ tasks: [Task])
    func setTaskEntities(_ taskEntityes: [TaskEntity])
  
}


// MARK: - Presenter -> Interactor
protocol MainInteractorProtocol: AnyObject {
    func fetchTasks()
    func saveTask(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
    func updateTask(_ task: TaskEntity, completed: Bool)
    func loadTasks()
    func setTaskEntities(_ tasks:[TaskEntity])
}

// MARK: - Interactor -> Presenter
protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskEntity])
    func didFailFetchingTasks(with error: String)
    func didDeleteTask()
}

// MARK: - Router
protocol MainRouterProtocol: AnyObject {
    func navigateToOpenTask(task: TaskEntity)
    func navigateToNewTask()
}
