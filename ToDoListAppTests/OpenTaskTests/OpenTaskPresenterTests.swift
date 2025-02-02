import XCTest
@testable import ToDoListApp

final class OpenTaskPresenterTests: XCTestCase {
    var presenter: OpenTaskPresenter!
    var mockView: MockOpenTaskView!
    var mockInteractor: MockOpenTaskInteractor!
    var mockRouter: MockOpenTaskRouter!

    override func setUp() {
        super.setUp()
        presenter = OpenTaskPresenter()
        mockView = MockOpenTaskView()
        mockInteractor = MockOpenTaskInteractor()
        mockRouter = MockOpenTaskRouter()

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

    
    func testViewDidLoad_ShouldFetchTask() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.fetchTaskCalled, "fetchTask() не был вызван")
    }

  
    func testEditTask_ShouldCallInteractorUpdateTask() {
        let title = "Обновлённая задача"
        let description = "Новое описание"

        presenter.editTask(title: title, description: description)

        XCTAssertTrue(mockInteractor.updateTaskCalled, "updateTask() не был вызван")
        XCTAssertEqual(mockInteractor.updatedTitle, title, "Название задачи передано неправильно")
        XCTAssertEqual(mockInteractor.updatedDescription, description, "Описание задачи передано неправильно")
        XCTAssertNotNil(mockInteractor.updatedDate, "Дата задачи не была установлена")
    }

 
    func testDeleteTask_ShouldCallInteractorDeleteTask() {
        presenter.deleteTask()
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "deleteTask() не был вызван")
    }


    func testUpdateTask_ShouldShowError_WhenTitleIsEmpty() {
        presenter.updateTask(title: "", description: "Описание", date: "01/02/2025")

        XCTAssertTrue(mockView.showErrorCalled, "showError() не был вызван")
        XCTAssertEqual(mockView.errorMessage, "Название задачи не может быть пустым", "Неверное сообщение об ошибке")
        XCTAssertFalse(mockInteractor.updateTaskCalled, "updateTask() не должен был быть вызван")
    }
 
    func testDidFetchTask_ShouldUpdateView() {
        let title = "Моя задача"
        let description = "Описание задачи"
        let date = "01/02/2025"

        presenter.didFetchTask(title: title, description: description, date: date)

        XCTAssertTrue(mockView.displayTaskCalled, "displayTask() не был вызван")
        XCTAssertEqual(mockView.displayedTitle, title, "Передан неверный заголовок")
        XCTAssertEqual(mockView.displayedDescription, description, "Передано неверное описание")
        XCTAssertEqual(mockView.displayedDate, date, "Передана неверная дата")
    }

  
    func testDidFailWithError_ShouldPrintError() {
        let errorMessage = "Ошибка загрузки задачи"
        presenter.didFailWithError(errorMessage)
        XCTAssertNotNil(errorMessage, "Сообщение об ошибке должно быть передано")
    }

   
    func testDidDeleteTask_ShouldNavigateBack() {
        presenter.didDeleteTask()
        XCTAssertTrue(mockRouter.navigateBackCalled, "navigateBack() не был вызван")
    }
}
