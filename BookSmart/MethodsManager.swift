
import UIKit

final public class MethodsManager {
    
    static let shared = MethodsManager()
    
    func timeAgoString(from date: Date) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: currentDate)
        
        if let years = components.year, years > 0 {
            return "\(years)y"
        } else if let months = components.month, months > 0 {
            return "\(months)m"
        } else if let days = components.day, days > 0 {
            return "\(days)d"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Now"
        }
    }
    
    func fadeAnimation(duration: TimeInterval = 0.1, alpha: CGFloat = 0.2, elements: UIView..., completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            for element in elements {
                element.alpha = alpha
            }
        }) { _ in
            UIView.animate(withDuration: duration) {
                for element in elements {
                    element.alpha = 1
                }
            }
            completion?()
        }
    }
}
