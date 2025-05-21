import Foundation
@testable import ToDoListApp

final class MockMainPresenter: MainPresenterProtocol {
    
    var tasks: [Task] = []
    var taskEntityes: [TaskEntity] = []
    var filteredTasks: [Task] = []
    
    var viewDidLoadCalled = false
    var addTaskTappedCalled = false
    var searchTaskCalledWith: String?
    var deleteTaskCalledAt: Int?
    var toggleTaskCompletionCalledAt: Int?
    var resetSearchCalled = false
    var getTaskEntityCalledAt: Int?
    var deleteTaskIndex: Int? 
    var openTaskDetailsCalledWith: TaskEntity?
    var setTasksCalledWith: [Task]?
    var setTaskEntitiesCalledWith: [TaskEntity]?
    var searchTaskQuery: String?
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func addTaskTapped() {
        addTaskTappedCalled = true
    }
    
    func searchTask(with query: String) {
        searchTaskCalledWith = query
        searchTaskQuery = query
    }
    
    func deleteTask(at index: Int) {
        deleteTaskCalledAt = index
    }
    
    func toggleTaskCompletion(at index: Int) {
        toggleTaskCompletionCalledAt = index
    }
    
    func resetSearch() {
        resetSearchCalled = true
    }
    
    func getTaskEntity(at index: Int) -> TaskEntity? {
        getTaskEntityCalledAt = index
        return taskEntityes[safe: index]
    }
    
    func openTaskDetails(_ task: TaskEntity) {
        openTaskDetailsCalledWith = task
    }
    
    func setTasks(_ tasks: [Task]) {
        setTasksCalledWith = tasks
        self.tasks = tasks
    }
    
    func setTaskEntities(_ taskEntityes: [TaskEntity]) {
        setTaskEntitiesCalledWith = taskEntityes
        self.taskEntityes = taskEntityes
    }
    
}

// Optional extension for safe index access
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
