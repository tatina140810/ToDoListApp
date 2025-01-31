import UIKit

struct Task {
    let title: String
    let description: String
    let date: String
    var completed: Bool
    
    mutating func toggleCompletion() {
          completed.toggle()
      }
}
protocol TaskCellDelegate: AnyObject {
    func didUpdateTaskCompletion(at indexPath: IndexPath, completed: Bool)
}

class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    weak var delegate: TaskCellDelegate?
    private var indexPath: IndexPath?
    
    private let checkBoxButton: CheckboxButton = {
          let button = CheckboxButton()
        button.tintColor = .darkYellow
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()
      
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var task: Task?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = .clear
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            checkBoxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            checkBoxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
                        checkBoxButton.widthAnchor.constraint(equalToConstant: 40),
                        checkBoxButton.heightAnchor.constraint(equalToConstant: 40),
        
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        checkBoxButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)

    }

    func configure(with task: Task, at indexPath: IndexPath) {
           self.indexPath = indexPath
           titleLabel.text = task.title
           descriptionLabel.text = task.description
           dateLabel.text = task.date
           checkBoxButton.isChecked = task.completed

           updateTitleAppearance(task.completed)
       }

       private func updateTitleAppearance(_ completed: Bool) {
           let attributeString = NSMutableAttributedString(string: titleLabel.text ?? "")
           if completed {
               attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
               titleLabel.textColor = .gray
           } else {
               attributeString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
               titleLabel.textColor = .red
           }
           titleLabel.attributedText = attributeString
       }

       @objc private func checkBoxTapped() {
           guard let indexPath = indexPath else { return }
           checkBoxButton.isChecked.toggle()
           updateTitleAppearance(checkBoxButton.isChecked)
           
           delegate?.didUpdateTaskCompletion(at: indexPath, completed: checkBoxButton.isChecked)
       }
   }
