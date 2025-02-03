import Foundation


// MARK: - View -> Presenter
protocol NewTaskViewProtocol: AnyObject {
    func showError(_ message: String)
    func dismissView()
}

// MARK: - Presenter -> View
protocol NewTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(title: String, description: String)
}

// MARK: - Presenter -> Interactor
protocol NewTaskInteractorProtocol: AnyObject {
    func saveTask(title: String, description: String, date: String)
}

// MARK: - Interactor -> Presenter
protocol NewTaskInteractorOutputProtocol: AnyObject {
    func didSaveTask()
    func didFailWithError(_ error: String)
}

// MARK: - Router
protocol NewTaskRouterProtocol: AnyObject {
    func navigateBack()
}

