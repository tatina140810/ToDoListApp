import XCTest
import CoreData
@testable import ToDoListApp

final class MainPresenterTests: XCTestCase {
    
    var presenter: MainPresenter!
    var mockView: MockMainView!
    var mockInteractor: MockMainInteractor!
    var mockRouter: MockMainRouter!
    
    override func setUp() {
        super.setUp()
        presenter = MainPresenter()
        mockView = MockMainView()
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    func testViewDidLoad_ShouldCallInteractor() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "fetchTasks должен быть вызван")
    }
    
    func testAddTaskTapped_ShouldNavigateToNewTask() {
        presenter.addTaskTapped()
        XCTAssertTrue(mockRouter.navigateToNewTaskCalled)
    }
    
    func testSearchTask_ShouldUpdateFilteredTasksAndReload() {
        let task = Task(title: "Test", description: "Description", date: "Today", completed: false)
        presenter.setTasks([task])
        presenter.searchTask(with: "test")
        
        XCTAssertTrue(presenter.filteredTasks.count == 1)
        XCTAssertTrue(mockView.reloadDataCalled)
    }
    
    func testToggleTaskCompletion_ShouldCallInteractorUpdate() {
        let coreDataStack = CoreDataTestStack()
        let context = coreDataStack.context
        
        let taskEntity = TaskEntity(context: context)
        taskEntity.title = "Test"
        taskEntity.taskDescription = "Description"
        taskEntity.taskDate = "Today"
        taskEntity.completed = false
        
        presenter.setTaskEntities([taskEntity])
        presenter.toggleTaskCompletion(at: 0)
        
        XCTAssertTrue(mockInteractor.updateTaskCalled)
        XCTAssertTrue(mockView.reloadDataCalled)
    }
    
    
    func testDeleteTask_ShouldCallInteractorDelete() {
        let coreDataStack = CoreDataTestStack()
        let context = coreDataStack.context
        let taskEntity = TaskEntity(context: context)
        taskEntity.title = "Delete me"
        presenter.setTaskEntities([taskEntity])
        
        presenter.deleteTask(at: 0)
        
        XCTAssertTrue(mockInteractor.deleteTaskCalled)
        XCTAssertTrue(mockView.reloadDataCalled)
        XCTAssertEqual(presenter.taskEntityes.count, 0)
    }
    
    func testOpenTaskDetails_ShouldCallRouter() {
        let taskEntity = TaskEntity()
        presenter.openTaskDetails(taskEntity)
        
        XCTAssertTrue(mockRouter.navigateToOpenTaskCalled)
        XCTAssertEqual(mockRouter.openedTask, taskEntity)
    }
    
    func testResetSearch_ShouldClearQueryAndReload() {
        presenter.searchTask(with: "test")
        presenter.resetSearch()
        
        XCTAssertEqual(presenter.filteredTasks.count, 0)
        XCTAssertTrue(mockView.reloadDataCalled)
    }
}
