import Foundation

final class NewTaskInteractor: NewTaskInteractorProtocol {

    weak var presenter: NewTaskInteractorOutputProtocol?
    private let storageManager = StorageManager.shared

    func saveTask(title: String, description: String, date: String) {
        let newTask = TaskEntity(context: storageManager.context)
        newTask.title = title
        newTask.taskDescription = description
        newTask.taskDate = date
        newTask.completed = false

        storageManager.saveContext()
        presenter?.didSaveTask()
    }
}
