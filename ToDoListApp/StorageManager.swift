import CoreData

class StorageManager {

    static let shared = StorageManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Ошибка загрузки хранилища Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Сохранение контекста
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка при сохранении Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Создание новой задачи
    func createTask(title: String, taskDescription: String, taskDate: String, completed: Bool) {
        let task = TaskEntity(context: context)
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
        
        saveContext()
    }
    
    // MARK: - Получение всех задач (с сортировкой)
    func fetchTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: true) // Сортировка по дате
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки задач: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Обновление задачи
    func updateTask(_ task: TaskEntity, title: String, taskDescription: String, taskDate: String, completed: Bool) {
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
        
        saveContext()
    }
    
    // MARK: - Удаление задачи
    func deleteTask(_ task: TaskEntity) {
        context.delete(task)
        saveContext()
    }
}
