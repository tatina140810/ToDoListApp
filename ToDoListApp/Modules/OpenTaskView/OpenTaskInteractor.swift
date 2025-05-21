import Foundation
import CoreData

final class OpenTaskInteractor: OpenTaskInteractorProtocol {
    
    weak var presenter: OpenTaskInteractorOutputProtocol?
    private let storageManager: StorageManagerProtocol
    var task: TaskEntity?
    
    init(storageManager: StorageManagerProtocol) {
           self.storageManager = storageManager
       }
       
    
    func fetchTask() {
        guard let title = task?.title else { return }
        guard let taskEntity = storageManager.fetchTaskEntity(by: title) else {
            presenter?.didFailWithError("Задача не найдена")
            return
        }
        presenter?.didFetchTask(
            title: taskEntity.title ?? "Без названия",
            description: taskEntity.taskDescription ?? "Нет описания",
            date: taskEntity.taskDate ?? "Нет даты"
        )
    }
    
    func deleteTask() {
        guard let task = task else { return }
        storageManager.deleteTask(task)
        presenter?.didDeleteTask()
    }
    
    func updateTask(title: String, description: String, date: String) {
        guard let existingTask = task else {
            presenter?.didFailWithError("Задача не найдена")
            return
        }
        
        existingTask.title = title
        existingTask.taskDescription = description
        existingTask.taskDate = date
        
        storageManager.saveContext()
        presenter?.didSaveTask()
    }
    
}
