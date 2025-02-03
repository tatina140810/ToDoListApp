import Foundation

@testable import ToDoListApp

final class MockMainPresenter: MainPresenterProtocol, MainInteractorOutputProtocol {
    var taskEntityes: [ToDoListApp.TaskEntity] = []
    
    
    var reloadDataCalled = false
    var didFetchTasksCalled = false
    var didDeleteTaskCalled = false
    
    var tasks: [ToDoListApp.Task] = []
    var filteredTasks: [ToDoListApp.Task] = []
    
    
    func didFetchTasks(_ tasks: [ToDoListApp.TaskEntity]) {
        print("didFetchTasks was called")
        didFetchTasksCalled = true
        setTaskEntities(tasks)
    }
    func didDeleteTask() {
        didDeleteTaskCalled = true
    }
    
    
    func didFailFetchingTasks(with error: String) {
        
    }
    
    func setTasks(_ tasks: [ToDoListApp.Task]) {
        self.tasks = tasks
        filteredTasks = tasks
    }
    
    func setTaskEntities(_ taskEntityes: [ToDoListApp.TaskEntity]) {
        self.tasks = taskEntityes.map { Task(
            title: $0.title ?? "Без названия",
            description: $0.taskDescription ?? "Нет описания",
            date: $0.taskDate ?? "Нет даты",
            completed: $0.completed
        )}
        filteredTasks = self.tasks
    }
    
    func viewDidLoad() {}
    
    func addTaskTapped() {}
    
    func searchTask(with query: String) {
        filteredTasks = tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
        reloadData()
    }
    
    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        tasks.remove(at: index)
        reloadData()
    }
    
    func toggleTaskCompletion(at index: Int) {
        guard index < tasks.count else { return }
        tasks[index].completed.toggle()
        reloadData()
    }
    
    func resetSearch() {
        filteredTasks = tasks
        reloadData()
    }
    
    func getTaskEntity(at index: Int) -> ToDoListApp.TaskEntity? {
        return nil
    }
    
    func openTaskDetails(_ task: ToDoListApp.TaskEntity) {}
    
    func reloadData() {
        reloadDataCalled = true
    }
}

