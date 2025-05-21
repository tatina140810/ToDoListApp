import UIKit

final class MainRouter: MainRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToOpenTask(task: TaskEntity) {
        let openTaskVC = OpenTaskBuilder.build(with: task)
        viewController?.navigationController?.pushViewController(openTaskVC, animated: true)
    }
    
    
    func navigateToNewTask() {
        let newTaskVC = NewTaskBuilder.build()
        viewController?.navigationController?.pushViewController(newTaskVC, animated: true)
    }
}
