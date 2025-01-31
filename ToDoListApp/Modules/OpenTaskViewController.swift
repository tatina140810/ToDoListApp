//
//  OpenTaskViewController.swift
//  ToDoListApp
//
//  Created by Tatina Dzhakypbekova on 30/1/25.
//

import UIKit
import CoreData


final class OpenTaskViewController: UIViewController {
    
    weak var delegate: OpenTaskViewControllerDelegate?
   
    var taskTitle: String?
    var taskDescription: String?
    var taskDate: String?
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        
        return textField
    }()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(hex: "#272729")
        textView.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        textView.textColor = .white
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 12)
        return textView
    }()
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .grayForButton
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.alignment = .leading
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
        config.imagePadding = 130
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
        config.imagePadding = 155
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
        config.title = "Улалить"
        config.image = UIImage(resource: .trash)
        config.imagePlacement = .trailing
        config.imagePadding = 183
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        
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
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
  
            backButtonTapped()
        }
    }
    private func updateUI() {
        titleTextField.text = taskTitle ?? "Без названия"
        descriptionTextView.text = taskDescription ?? "Нет описания"
        dateTextField.text = taskDate ?? "Нет даты"
    }
    
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
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 53),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -53),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 132),
            
            editButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            shareButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    @objc func editButtonTapped() {
        print("Edit Button Tapped")
        titleTextField.isUserInteractionEnabled = true
        descriptionTextView.isUserInteractionEnabled = true
        dateTextField.isUserInteractionEnabled = true
        titleTextField.becomeFirstResponder()
        
    }
    @objc func shareButtonTapped() {
        print("Share Button Tapped")
    }
    @objc func deleteButtonTapped() {
        print("Delete Button Tapped")

        guard let task = fetchTaskEntity(by: taskTitle ?? "") else {
            print("Ошибка: задача не найдена в базе данных")
            return
        }

        let storageManager = StorageManager.shared
        storageManager.deleteTask(task)

        delegate?.reloadData()
        navigationController?.popViewController(animated: true)
    }

    @objc private func backButtonTapped() {
        print("Пользователь нажал кнопку 'Назад'")

        guard let task = fetchTaskEntity(by: taskTitle ?? "") else {
            print("Ошибка: задача не найдена в базе данных")
            return
        }

        let storageManager = StorageManager.shared

        storageManager.updateTask(task,
            title: titleTextField.text ?? "Без названия",
            taskDescription: descriptionTextView.text ?? "Нет описания",
            taskDate: dateTextField.text ?? "Нет даты",
            completed: task.completed
        )

        delegate?.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchTaskEntity(by title: String) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            return try StorageManager.shared.context.fetch(fetchRequest).first
        } catch {
            print("Ошибка при поиске задачи: \(error.localizedDescription)")
            return nil
        }
    }

    
}

