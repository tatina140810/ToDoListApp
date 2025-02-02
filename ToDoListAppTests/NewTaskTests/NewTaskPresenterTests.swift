import XCTest
@testable import ToDoListApp

final class NewTaskPresenterTests: XCTestCase {
    var presenter: NewTaskPresenter!
    var mockView: MockNewTaskView!
    var mockInteractor: MockNewTaskInteractor!

    override func setUp() {
        super.setUp()
        presenter = NewTaskPresenter()
        mockView = MockNewTaskView()
        mockInteractor = MockNewTaskInteractor()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testSaveTask_ShouldCallInteractor_WhenTitleIsValid() {
        let title = "Новая задача"
        let description = "Описание задачи"

        presenter.saveTask(title: title, description: description)

        XCTAssertTrue(mockInteractor.saveTaskCalled, "saveTask() не был вызван в interactor")
        XCTAssertEqual(mockInteractor.savedTaskTitle, title, "Название задачи передано неправильно")
        XCTAssertEqual(mockInteractor.savedTaskDescription, description, "Описание задачи передано неправильно")
        XCTAssertNotNil(mockInteractor.savedTaskDate, "Дата задачи не была установлена")
    }

  
    func testSaveTask_ShouldShowError_WhenTitleIsEmpty() {
        presenter.saveTask(title: "", description: "Описание задачи")

        XCTAssertTrue(mockView.showErrorCalled, "showError() не был вызван")
        XCTAssertEqual(mockView.errorMessage, "Название задачи не может быть пустым", "Неверное сообщение об ошибке")
    }

 
    func testDidSaveTask_ShouldDismissView() {
        presenter.didSaveTask()

        XCTAssertTrue(mockView.dismissViewCalled, "dismissView() не был вызван")
    }

    func testDidFailWithError_ShouldShowError() {
        let errorMessage = "Ошибка при сохранении"
        
        presenter.didFailWithError(errorMessage)

        XCTAssertTrue(mockView.showErrorCalled, "showError() не был вызван")
        XCTAssertEqual(mockView.errorMessage, errorMessage, "Передано неверное сообщение об ошибке")
    }
}
