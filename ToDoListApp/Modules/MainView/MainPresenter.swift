import Foundation

final class MainPresenter: MainPresenterProtocol {
    func setTaskEntities(_ taskEntities: [TaskEntity]) {
        self.taskEntities = taskEntities
    }
    
    private var searchQuery: String = ""
    
    var filteredTasks: [Task] {
        return searchQuery.isEmpty ? tasks : tasks.filter { $0.title.lowercased().contains(searchQuery) }
    }
    func openTaskDetails(_ task: TaskEntity) {
        router?.navigateToOpenTask(task: task)
    }
    
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    private var taskEntities: [TaskEntity] = [] {
        didSet {
            tasks = taskEntities.map { Task(
                title: $0.title ?? "Без названия",
                description: $0.taskDescription ?? "Нет описания",
                date: $0.taskDate ?? "Нет даты",
                completed: $0.completed
            )}
        }
    }
    
    private(set) var tasks: [Task] = []
    
    func viewDidLoad() {
        interactor?.fetchTasks()
        interactor?.loadTasks()
    }
    
    func didFetchTasks(_ tasks: [Task]) {
        self.tasks = tasks
        view?.reloadData()
    }
    
    
    func toggleTaskCompletion(at index: Int) {
        guard index < taskEntities.count else { return }
        
        let taskEntity = taskEntities[index]
        taskEntity.completed.toggle()
        
        interactor?.updateTask(taskEntity, completed: taskEntity.completed)
        view?.reloadData()
    }
    
    func deleteTask(at index: Int) {
        guard index < taskEntities.count else { return }
        
        let taskEntity = taskEntities[index]
        interactor?.deleteTask(taskEntity)
        
        taskEntities.remove(at: index)
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
        guard index < taskEntities.count else { return nil }
        return taskEntities[index]
    }
    func setTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
    func didDeleteTask() {
        tasks = taskEntities.map { Task(
                   title: $0.title ?? "Без названия",
                   description: $0.taskDescription ?? "Нет описания",
                   date: $0.taskDate ?? "Нет даты",
                   completed: $0.completed
               )}
               
               view?.reloadData() 
    }
    
    func didFetchTasks(_ tasks: [TaskEntity]) {
        self.taskEntities = tasks
        view?.reloadData()
    }
    
    func didFailFetchingTasks(with error: String) {
        view?.showError(error)
    }
}
