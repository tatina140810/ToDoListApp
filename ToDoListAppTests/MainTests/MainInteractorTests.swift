import XCTest

@testable import ToDoListApp

final class MainInteractorTests: XCTestCase {
    var interactor: MainInteractor!
    var mockPresenter: MockMainPresenter!
    
    override func setUp() {
        super.setUp()
        interactor  = MainInteractor()
        mockPresenter = MockMainPresenter()
        interactor.presenter = mockPresenter
    }
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        super.tearDown()
    }
    func testFetchTasks_ShouldReturnTasks() {
        interactor.fetchTasks()
        XCTAssertTrue(mockPresenter.didFetchTasksCalled, "didFetchTasks() не был вызван")
    }
    func testDeleteTask_shouldDeleteTask() {
        let context = StorageManager.shared.context
        let task = TaskEntity(context: context)
        task.title = "Удаляемая задача"

        interactor.setTaskEntities([task])

        let expectation = self.expectation(description: "Ожидание удаления задачи")

        DispatchQueue.global().async {
            self.interactor.deleteTask(task)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        XCTAssertTrue(mockPresenter.didDeleteTaskCalled, "didDeleteTask() не был вызван")
    }

}
