//
//  String+Extension.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/6/24.
//

import Foundation

extension String {
    
    func daysAgo() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // Match the format of the input string
        
        guard let date = formatter.date(from: self) else {
            return nil
        }
        
        // Use RelativeDateTimeFormatter to get a human-readable relative date
        if #available(iOS 13.0, *) {
            let relativeFormatter = RelativeDateTimeFormatter()
            relativeFormatter.unitsStyle = .full  // You can change the units style (short, full, or abbreviated)
            
            return relativeFormatter.localizedString(for: date, relativeTo: Date())
        } else {
            // Calculate the difference between the current date and the parsed date
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .month, .day], from: date, to: currentDate)
            
            if let years = components.year, years > 0 {
                return "\(years) year(s) ago"
            } else if let months = components.month, months > 0 {
                return "\(months) month(s) ago"
            } else if let days = components.day, days > 0 {
                return "\(days) days(s) ago"
            }
            
            return nil
        }
    }
}
