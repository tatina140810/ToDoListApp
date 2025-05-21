import XCTest
import CoreData
@testable import ToDoListApp

final class MockMainInteractorTests: XCTestCase {
    
    var interactor: MockMainInteractor!
    var testTask: TaskEntity!
    
    override func setUp() {
        super.setUp()
        interactor = MockMainInteractor()
        
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { _, _ in }
        let context = container.viewContext
        
        testTask = TaskEntity(context: context)
        testTask.title = "Test"
    }
    
    override func tearDown() {
        interactor = nil
        testTask = nil
        super.tearDown()
    }
    
    func testFetchTasks_ShouldSetFlag() {
        interactor.fetchTasks()
        XCTAssertTrue(interactor.fetchTasksCalled)
    }
    
    func testSaveTask_ShouldSetFlag() {
        interactor.saveTask(testTask)
        XCTAssertTrue(interactor.saveTaskCalled)
    }
    
    func testDeleteTask_ShouldSetFlag() {
        interactor.deleteTask(testTask)
        XCTAssertTrue(interactor.deleteTaskCalled)
    }
    
    func testUpdateTask_ShouldSetFlag() {
        interactor.updateTask(testTask, completed: true)
        XCTAssertTrue(interactor.updateTaskCalled)
    }
    
    func testLoadTasks_ShouldSetFlag() {
        interactor.loadTasks()
        XCTAssertTrue(interactor.loadTasksCalled)
    }
}
