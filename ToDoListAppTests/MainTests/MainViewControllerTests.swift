//
//  MainViewControllerTests.swift
//  ToDoListAppTests
//
//  Created by Tatina Dzhakypbekova on 2/2/25.
//

import XCTest

@testable import ToDoListApp

final class MainViewControllerTests: XCTestCase {
    var viewController: MainViewController?
    var mockPresenter: MockMainPresenter?
    override func setUp() {
        super.setUp()
        viewController = MainViewController()
        mockPresenter = MockMainPresenter()
        viewController?.presenter = mockPresenter
    }
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    func testReloadData_ShouldReloadTableView(){
        guard let viewController = viewController else {
            XCTFail("ViewController не инициализирован")
            return
        }
        viewController.reloadData()
        XCTAssertTrue(((mockPresenter?.reloadDataCalled) != nil), "reloadData() не был вызван")
    }
    func testShowError_ShouldPresentAlert(){
        viewController?.showError("Ошибка теста")
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        XCTAssertNotNil(viewController?.presentedViewController is UIAlertController, "UIAlertController не был показан")
    }
    
}
