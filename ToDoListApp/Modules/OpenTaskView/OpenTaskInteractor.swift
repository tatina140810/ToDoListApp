import Foundation
import CoreData

final class OpenTaskInteractor: OpenTaskInteractorProtocol {

    weak var presenter: OpenTaskInteractorOutputProtocol?
    private let storageManager = StorageManager.shared
     var task: TaskEntity?

    func fetchTask() {
        guard let title = task?.title else { return }
        guard let taskEntity = fetchTaskEntity(by: title) else {
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
        
        storageManager.context.delete(task)
        storageManager.saveContext()

        presenter?.didDeleteTask()
    }


    private func fetchTaskEntity(by title: String) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            return try storageManager.context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при поиске задачи: \(error.localizedDescription)")
            return nil
        }
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
