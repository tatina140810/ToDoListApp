import Foundation

// Модель задачи (ToDoTask)
struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct ToDoTasks: Codable {
    let todos: [ToDo]
}

class JsonManager {
    static let shared = JsonManager()
    private init() {}

    // MARK: - Загрузка задач из JSON по URL
    func fetchTodos(completion: @escaping ([Task]) -> Void) {
        let urlString = "https://drive.google.com/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка загрузки: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Нет данных")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ToDoTasks.self, from: data)
                
                let tasks = decodedData.todos.map { todo in
                    Task(title: "Task \(todo.id)", description: todo.todo, date: "No date", completed: false)
                }
                
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }
        task.resume()
    }

    // MARK: - Загрузка JSON из локального файла
    func loadLocalTasks(completion: @escaping ([Task]) -> Void) {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json") else { return }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(ToDoTasks.self, from: data)

            let tasks = decodedData.todos.map { todo in
                Task(title: "Task \(todo.id)", description: todo.todo, date: "No date", completed: false)
            }

            DispatchQueue.main.async {
                completion(tasks)
            }
        } catch {
            print("Ошибка загрузки локального JSON: \(error)")
        }
    }
}
