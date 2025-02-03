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
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            print("✅ Загружено задач: \(tasks.count)")
            return tasks
        } catch {
            print("⚠️ Ошибка загрузки задач: \(error.localizedDescription)")
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
    
    // MARK: - Получение задачи по заголовку
    func fetchTaskEntity(by title: String) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Ошибка при поиске задачи: \(error.localizedDescription)")
            return nil
        }
    }
    // MARK: - Очистить persistentContainer
    func resetPersistentStore() {
        let storeURL = persistentContainer.persistentStoreDescriptions.first?.url
        if let storeURL = storeURL {
            do {
                try FileManager.default.removeItem(at: storeURL)
                print("✅ Старая база данных удалена")
            } catch {
                print("⚠️ Ошибка удаления базы данных: \(error)")
            }
        }
    }
    
}
