//
//  NewTaskViewController.swift
//  ToDoListApp
//
//  Created by Tatina Dzhakypbekova on 30/1/25.

import UIKit

struct DateFormatterHelper {
    
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date())
    }
}

final class NewTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
   
    weak var delegate: NewTaskViewControllerDelegate?
    
    private let titleText: UITextField = {
        let titleText = UITextField()
        titleText.textColor = .white
        titleText.font = UIFont.systemFont(ofSize: 34)
        titleText.layer.cornerRadius = 10
        titleText.becomeFirstResponder()
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
        navigationController?.navigationBar.tintColor = .darkYellow
        setupDismissKeyboardGesture()
        setupTextView()
        titleText.delegate = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
  
            backButtonTapped()
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
    
    // MARK: - UITextViewDelegate (Обновление высоты)
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textViewHeightConstraint.constant = max(50, min(estimatedSize.height, 200))
        view.layoutIfNeeded()
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        let formattedDate = formatter.string(from: Date())
        return formattedDate
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView.becomeFirstResponder()
        return true
    }
    @objc private func backButtonTapped() {
        print("Пользователь нажал кнопку 'Назад'")
        let storageManager = StorageManager.shared
        let task = TaskEntity(context: storageManager.persistentContainer.viewContext)
        task.title = titleText.text
        task.taskDescription = textView.text
        task.taskDate = dateLabel.text
        task.completed = false
        storageManager.saveContext()
        delegate?.reloadData()
        
    }
    
    
}

