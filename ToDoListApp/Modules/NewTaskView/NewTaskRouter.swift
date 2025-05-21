import UIKit

final class NewTaskRouter: NewTaskRouterProtocol {

    weak var viewController: UIViewController?
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
