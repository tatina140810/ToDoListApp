//
//  OpenTaskViewController.swift
//  ToDoListApp
//
//  Created by Tatina Dzhakypbekova on 30/1/25.
//

import UIKit

final class OpenTaskViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(hex: "#272729")
        label.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(hex: "#272729")
        label.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(hex: "#272729")
        label.text = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private let taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stackView.distribution = .fillEqually
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
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

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
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(taskStackView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(editButton)
        buttonsStackView.addArrangedSubview(shareButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        taskStackView.addArrangedSubview(titleLabel)
        taskStackView.addArrangedSubview(descriptionLabel)
        taskStackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            taskStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
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
    }
    @objc func shareButtonTapped() {
        print("Share Button Tapped")
    }
    @objc func deleteButtonTapped() {
        print("Delete Button Tapped")
    }
}

