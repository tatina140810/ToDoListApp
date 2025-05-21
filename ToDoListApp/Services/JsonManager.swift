import Foundation

struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct ToDoTasks: Codable {
    let todos: [ToDo]
}
enum Constants {
    enum URLs {
        static let todosJSON = "https://drive.google.com/uc?export=download&id=1MXypRbK2CS9fqPhTtPonn580h1sHUs2W"
    }
}

class JsonManager {
    static let shared = JsonManager()
    private init() {}
    
    // MARK: - Загрузка задач из JSON по URL
    func fetchTodos(completion: @escaping ([Task]) -> Void) {
        let urlString = Constants.URLs.todosJSON
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

}
