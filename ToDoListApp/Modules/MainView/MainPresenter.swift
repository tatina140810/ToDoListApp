import Foundation

final class MainPresenter: MainPresenterProtocol {
    
    func setTaskEntities(_ taskEntityes: [TaskEntity]) {
        self.taskEntityes = taskEntityes
    }
    
    private var searchQuery: String = ""
    private var isFirstLaunch = true
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var filteredTasks: [Task] {
        return searchQuery.isEmpty ? tasks : tasks.filter {
            $0.title.lowercased().contains(searchQuery) ||
            $0.description.lowercased().contains(searchQuery) 
        }
    }
    
    func openTaskDetails(_ task: TaskEntity) {
        router?.navigateToOpenTask(task: task)
    }
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    var taskEntityes: [TaskEntity] = [] {
        didSet {
            tasks = taskEntityes.map { Task(
                title: $0.title ?? "Без названия",
                description: $0.taskDescription ?? "Нет описания",
                date: $0.taskDate ?? "Нет даты",
                completed: $0.completed
            )}
        }
    }
    
    private(set) var tasks: [Task] = []
    
    func viewDidLoad() {
        if isFirstLaunch {
            interactor?.loadTasks() 
            isFirstLaunch = false   
        }
        interactor?.fetchTasks()
        
    }
    
    func toggleTaskCompletion(at index: Int) {
        guard index < taskEntityes.count else { return }
        
        let taskEntity = taskEntityes[index]
        taskEntity.completed.toggle()
        
        interactor?.updateTask(taskEntity, completed: taskEntity.completed)
        view?.reloadData()
    }
    
    func deleteTask(at index: Int) {
        guard index < taskEntityes.count else { return }
        
        let taskEntity = taskEntityes[index]
        interactor?.deleteTask(taskEntity)
        
        taskEntityes.remove(at: index)
        view?.reloadData()
    }
    
    func addTaskTapped() {
        router?.navigateToNewTask()
    }
    
    func searchTask(with query: String) {
        searchQuery = query.lowercased()
        view?.reloadData()
    }
    
    func resetSearch() {
        searchQuery = ""
        view?.reloadData()
    }
    
    func getTaskEntity(at index: Int) -> TaskEntity? {
        guard index < taskEntityes.count else { return nil }
        return taskEntityes[index]
    }
    func setTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
    func didDeleteTask() {
        tasks = taskEntityes.map { Task(
            title: $0.title ?? "Без названия",
            description: $0.taskDescription ?? "Нет описания",
            date: $0.taskDate ?? "Нет даты",
            completed: $0.completed
        )}
        
        view?.reloadData() 
    }
    
    func didFetchTasks(_ tasks: [TaskEntity]) {
        self.taskEntityes = tasks
        view?.stopLoading()
        view?.reloadData()
    }
    
    func didFailFetchingTasks(with error: String) {
        view?.showError(error)
    }
}
