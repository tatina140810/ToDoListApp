import UIKit

final class NewTaskRouter: NewTaskRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> NewTaskViewController {
        let view = NewTaskViewController()
        let presenter = NewTaskPresenter()
        let interactor = NewTaskInteractor()
        let router = NewTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
