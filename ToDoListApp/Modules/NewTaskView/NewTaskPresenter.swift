import Foundation

final class NewTaskPresenter: NewTaskPresenterProtocol {

    weak var view: NewTaskViewProtocol?
    var interactor: NewTaskInteractorProtocol?
    var router: NewTaskRouterProtocol?

    func viewDidLoad() {}

    func saveTask(title: String, description: String) {
        if title.isEmpty {
            view?.showError("Название задачи не может быть пустым")
            return
        }
        let date = DateFormatterHelper.getCurrentDate()
        interactor?.saveTask(title: title, description: description, date: date)
    }
}

// MARK: - NewTaskInteractorOutputProtocol
extension NewTaskPresenter: NewTaskInteractorOutputProtocol {
    func didSaveTask() {
        view?.dismissView()
    }

    func didFailWithError(_ error: String) {
        view?.showError(error)
    }
}
