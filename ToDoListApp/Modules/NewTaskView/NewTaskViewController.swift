import UIKit

final class NewTaskViewController: UIViewController, UITextViewDelegate {

    var presenter: NewTaskPresenterProtocol!


    private let titleText: UITextField = {
        let titleText = UITextField()
        titleText.textColor = .white
        titleText.font = UIFont.systemFont(ofSize: 34)
        titleText.layer.cornerRadius = 10
        titleText.becomeFirstResponder()
        titleText.returnKeyType = .next
        titleText.translatesAutoresizingMaskIntoConstraints = false
        return titleText
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = DateFormatterHelper.getCurrentDate()
        label.textColor = .lightGray
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        return textView
    }()
    
    private var textViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = UIColor(hex: "#FED702")
        setupDismissKeyboardGesture()
        setupTextView()
        titleText.delegate = self
        textView.delegate = self
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            saveTask()
        }
    }

    private func saveTask() {
        let title = titleText.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !title.isEmpty || !description.isEmpty {
            presenter.saveTask(title: title, description: description)
   
        }
    }

    private func setupTextView() {
        view.addSubview(titleText)
        view.addSubview(dateLabel)
        view.addSubview(textView)

        textView.delegate = self
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 50)
        textViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleText.heightAnchor.constraint(equalToConstant: 50),

            dateLabel.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textViewHeightConstraint.constant = max(50, min(estimatedSize.height, 200))
        view.layoutIfNeeded()
    }

    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - NewTaskViewProtocol
extension NewTaskViewController: NewTaskViewProtocol {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}
extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleText {
            textView.becomeFirstResponder()
        }
        return true
    }
}
