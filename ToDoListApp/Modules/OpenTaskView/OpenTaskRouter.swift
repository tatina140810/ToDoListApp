import UIKit

final class OpenTaskRouter: OpenTaskRouterProtocol {

    weak var viewController: UIViewController?

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
