import Foundation

struct TaskModel {
    let title: String
    let description: String
    let date: String
    var completed: Bool
}


final class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainInteractorOutputProtocol?
    private var taskEntieties: [TaskEntity] = []
    
    func fetchTasks() {
        let tasks = StorageManager.shared.fetchTasks()
        presenter?.didFetchTasks(tasks)
    }
    
    func saveTask(_ task: TaskEntity) {
        StorageManager.shared.saveContext()
        fetchTasks()
    }
    
    func updateTask(_ task: TaskEntity, completed: Bool) {
        task.completed = completed
        StorageManager.shared.saveContext()
        fetchTasks()
    }
    
    func deleteTask(_ task: TaskEntity) {
        StorageManager.shared.deleteTask(task)
        fetchTasks()
        presenter?.didDeleteTask()
    }
    func loadTasks() {
        JsonManager.shared.fetchTodos { [weak self] fetchedTasks in
            guard let self = self else { return }
            
            let storageManager = StorageManager.shared
            let context = storageManager.context
            
            for task in fetchedTasks {
                if !self.isTaskExists(title: task.title) {
                    let newTask = TaskEntity(context: context)
                    newTask.title = task.title
                    newTask.taskDescription = task.description
                    newTask.taskDate = task.date
                    newTask.completed = false
                }
            }
            
            storageManager.saveContext()
            
            let taskEntities = storageManager.fetchTasks()
            _ = taskEntities.map { taskEntity in
                Task(
                    title: taskEntity.title ?? "Без названия",
                    description: taskEntity.taskDescription ?? "Нет описания",
                    date: taskEntity.taskDate ?? "Нет даты",
                    completed: taskEntity.completed
                )
            }
            
            
            DispatchQueue.main.async {
                self.presenter?.didFetchTasks(taskEntities) 
            }
        }
    }
    
    private func isTaskExists(title: String) -> Bool {
        let existingTasks = StorageManager.shared.fetchTasks()
        return existingTasks.contains { $0.title == title }
    }
    func setTaskEntities(_ tasks: [TaskEntity]) {
        self.taskEntieties = tasks
    }
}
