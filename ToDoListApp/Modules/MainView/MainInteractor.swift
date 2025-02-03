import Foundation

final class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainInteractorOutputProtocol?
    var taskEntityes: [TaskEntity] = []
    private let storageManager = StorageManager.shared
    
    // MARK: - Fetch Tasks
    func fetchTasks() {
        DispatchQueue.global(qos: .background).async {
            let tasks = self.storageManager.fetchTasks()
            DispatchQueue.main.async {
                self.presenter?.didFetchTasks(tasks)
            }
        }
    }
    
    // MARK: - Save Task
    func saveTask(_ task: TaskEntity) {
        DispatchQueue.global(qos: .background).async {
            self.storageManager.saveContext()
            self.fetchTasks()
        }
    }
    
    // MARK: - Update Task
    func updateTask(_ task: TaskEntity, completed: Bool) {
        DispatchQueue.global(qos: .background).async {
            task.completed = completed
            self.storageManager.saveContext()
            self.fetchTasks()
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(_ task: TaskEntity) {
        DispatchQueue.global(qos: .background).async {
            self.storageManager.deleteTask(task)
            self.fetchTasks()
            DispatchQueue.main.async {
                self.presenter?.didDeleteTask()
            }
        }
    }
    
    // MARK: - Load Tasks from JSON
    func loadTasks() {
        DispatchQueue.global(qos: .background).async {
            JsonManager.shared.fetchTodos { [weak self] fetchedTasks in
                guard let self = self else { return }
                
                let context = self.storageManager.context
                
                for task in fetchedTasks {
                    if !self.isTaskExists(title: task.title) {
                        let newTask = TaskEntity(context: context)
                        newTask.title = task.title
                        newTask.taskDescription = task.description
                        newTask.taskDate = task.date
                        newTask.completed = false
                    }
                }
                
                self.storageManager.saveContext()
                
                let taskEntityes = self.storageManager.fetchTasks()
                
                DispatchQueue.main.async {
                    self.presenter?.didFetchTasks(taskEntityes)
                }
            }
        }
    }
    
    // MARK: - Check if Task Exists
    private func isTaskExists(title: String) -> Bool {
        let existingTasks = storageManager.fetchTasks()
        return existingTasks.contains { $0.title == title }
    }
    
    // MARK: - Set Task Entities
    func setTaskEntities(_ tasks: [TaskEntity]) {
        DispatchQueue.global(qos: .background).async {
            self.taskEntityes = tasks
        }
    }
}
