import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        let start = hexString.hasPrefix("#") ? hexString.index(hexString.startIndex, offsetBy: 1) : hexString.startIndex
        let hexColor = String(hexString[start...])
        
        var color: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&color)
        
        let r, g, b: CGFloat
        if hexColor.count == 6 {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            b = CGFloat(color & 0x0000FF) / 255.0
        } else {
            r = 1.0
            g = 1.0
            b = 1.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

