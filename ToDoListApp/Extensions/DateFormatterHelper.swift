import Foundation

final class DateFormatterHelper {
    
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date())
    }
}
