import UIKit

final class OpenTaskRouter: OpenTaskRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(with task: TaskEntity) -> OpenTaskViewController {
        let view = OpenTaskViewController()
        let presenter = OpenTaskPresenter()
        let interactor = OpenTaskInteractor()
        let router = OpenTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        interactor.task = task

        return view
    }

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
