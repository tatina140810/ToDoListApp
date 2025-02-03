import UIKit

final class OpenTaskViewController: UIViewController {
    
    var presenter: OpenTaskPresenterProtocol!
    
    var taskTitle: String?
    var taskDescription: String?
    var taskDate: String?
    
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = ""
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        
        return textField
    }()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(hex: "#272729")
        textView.text = ""
        textView.textColor = .white
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.text = ""
        textField.textColor = .gray
        textField.font = UIFont.systemFont(ofSize: 12)
        return textField
    }()
    private let taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = UIColor(hex: "#272729")
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.isUserInteractionEnabled = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor(hex: "#EDEDED")
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.alignment = .leading
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var editButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.title = "Редактировать"
        config.image = UIImage(resource: .edit)
        config.imagePlacement = .trailing
        config.titleAlignment = .leading
        config.imagePadding = 90
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.title = "Поделиться"
        config.image = UIImage(resource: .export)
        config.imagePlacement = .trailing
        config.imagePadding = 115
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .red
        config.title = "Удалить"
        config.image = UIImage(resource: .trash)
        config.imagePlacement = .trailing
        config.imagePadding = 140
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        
        let button = UIButton(configuration: config)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
        longPressGesture()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            updateTask()
        }
    }
    
    private func updateTask() {
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateTextField.text ?? ""
        
        if !title.isEmpty || !description.isEmpty {
            presenter.updateTask(title: title, description: description, date: date)
            
        }
    }
    private func updateUI() {
        titleTextField.text = taskTitle ?? "Без названия"
        descriptionTextView.text = taskDescription ?? "Нет описания"
        dateTextField.text = taskDate ?? "Нет даты"
    }
    // MARK: - Setup UI
    
    private func setupUI(){
        view.addSubview(taskStackView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(editButton)
        buttonsStackView.addArrangedSubview(shareButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        taskStackView.addArrangedSubview(titleTextField)
        taskStackView.addArrangedSubview(descriptionTextView)
        taskStackView.addArrangedSubview(dateTextField)
        
        
        NSLayoutConstraint.activate([
            taskStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 500),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            dateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsStackView.topAnchor.constraint(equalTo: taskStackView.bottomAnchor, constant: 16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStackView.widthAnchor.constraint(equalToConstant: 254),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 132),
            
            editButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            shareButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    private func longPressGesture(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        taskStackView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Button Actions
    @objc private func editButtonTapped() {
        titleTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
    }
    @objc private func shareButtonTapped() {
        print("Share button Tapped")
    }
    
    @objc private func deleteButtonTapped() {
        presenter.deleteTask()
    }
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            buttonsStackView.isHidden = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonsStackView.isHidden = true
    }
}

// MARK: - OpenTaskViewProtocol
extension OpenTaskViewController: OpenTaskViewProtocol {
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayTask(title: String, description: String, date: String) {
        titleTextField.text = title
        descriptionTextView.text = description
        dateTextField.text = date
    }
}
