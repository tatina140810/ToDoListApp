import CoreData
@testable import ToDoListApp

final class MockStorageManager: StorageManagerProtocol {
    var tasks: [TaskEntity] = []
    var deleteCalled = false
    var updateCalled = false
    var saveCalled = false
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, _ in }
        return container.viewContext
    }()
    
    func fetchTasks() -> [TaskEntity] {
        return tasks
    }
    
    func deleteTask(_ task: TaskEntity) {
        deleteCalled = true
        tasks.removeAll { $0 == task }
    }
    
    func saveContext() {
        saveCalled = true
    }
    
    func createTask(title: String, taskDescription: String, taskDate: String, completed: Bool) {
        let task = TaskEntity(context: context)
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskEntity, title: String, taskDescription: String, taskDate: String, completed: Bool) {
        updateCalled = true
        task.title = title
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.completed = completed
    }
    
    func fetchTaskEntity(by title: String) -> TaskEntity? {
        return tasks.first { $0.title == title }
    }
    
    func resetPersistentStore() {
        tasks.removeAll()
    }
}
