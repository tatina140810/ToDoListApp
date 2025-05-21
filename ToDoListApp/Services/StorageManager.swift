import CoreData

protocol StorageManagerProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
    func createTask(title: String, taskDescription: String, taskDate: String, completed: Bool)
    func fetchTasks() -> [TaskEntity]
    func updateTask(_ task: TaskEntity, title: String, taskDescription: String, taskDate: String, completed: Bool)
    func deleteTask(_ task: TaskEntity)
    func fetchTaskEntity(by title: String) -> TaskEntity?
    func resetPersistentStore()
}

final class StorageManager: StorageManagerProtocol {

    private let container: NSPersistentContainer

    init(modelName: String = "ToDoListApp") {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("❌ Ошибка загрузки хранилища Core Data: \(error), \(error.userInfo)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Ошибка при сохранении: \(error.localizedDescription)")
            }
        }
    }

    func createTask(title: String, taskDescription: String, taskDate: String, completed: Bool) {
        let task = TaskEntity(context: context)
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
        saveContext()
    }

    func fetchTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "taskDate", ascending: true)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ Ошибка получения задач: \(error.localizedDescription)")
            return []
        }
    }

    func updateTask(_ task: TaskEntity, title: String, taskDescription: String, taskDate: String, completed: Bool) {
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
        saveContext()
    }

    func deleteTask(_ task: TaskEntity) {
        context.delete(task)
        saveContext()
    }

    func fetchTaskEntity(by title: String) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("❌ Ошибка поиска задачи: \(error.localizedDescription)")
            return nil
        }
    }

    func resetPersistentStore() {
        guard let storeURL = container.persistentStoreDescriptions.first?.url else { return }

        do {
            try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            try FileManager.default.removeItem(at: storeURL)
            container.loadPersistentStores(completionHandler: { _, error in
                if let error = error {
                    print("❌ Ошибка повторной загрузки хранилища: \(error)")
                }
            })
        } catch {
            print("❌ Ошибка сброса базы данных: \(error)")
        }
    }
}
