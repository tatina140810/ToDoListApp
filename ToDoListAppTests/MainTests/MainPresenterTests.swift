import XCTest

@testable import ToDoListApp

final class MainPresenterTests: XCTestCase{
    var presenter: MainPresenter!
    var mockView: MockMainView!
    var mockInteractor: MockMainInteractor!
    var mockRouter: MockMainRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockMainView()
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        
        presenter = MainPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    func testViewDidLoad_ShouldFetchTasks() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "Fetch Tasks() не был вызван")
    }
    func testSearchTask_ShouldFilterTasks() {
        let task1 = Task(title: "Задача 1", description: "Опмсание 1", date: "01/02.2025", completed: false)
        let task2 = Task(title: "Задача 2", description: "Опмсание 2", date: "01/02.2025", completed: false)
        presenter.setTasks ([task1,task2])
        presenter.searchTask(with: "2")
        
        XCTAssertEqual(presenter.filteredTasks.count, 1, "Не верное количество отфильтрованных задач")
        XCTAssertEqual(presenter.filteredTasks.first?.title, "Задача 2")
        
    }
    func testResetSearch_ShouldShowAllTasks(){
        presenter.resetSearch()
        XCTAssertEqual(presenter.filteredTasks.count, presenter.tasks.count)
    }
    func testDeleteTask_ShouldRemoveTask() {
        let context = StorageManager.shared.context
        let task1 = TaskEntity(context: context)
        task1.title = "Удаляемая задача"
        
        presenter.setTaskEntities([task1])
        presenter.deleteTask(at: 0)
        
        XCTAssertEqual(presenter.filteredTasks.count, 0)
        XCTAssertTrue(mockView.reloadDataCalled, "reloadData() не был вызван")
    }
}
