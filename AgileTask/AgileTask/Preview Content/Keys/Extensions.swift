//
//  Extensions.swift
//  AgileTask
//
//  Created by Евгений on 30.05.2025.
//

import Foundation

extension String {
    func stringToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.date(from: self)
    }
}
extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}

extension String {
    func makeLocalDate() -> String? {
        let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          inputFormatter.locale = Locale(identifier: "ru_RU")
          
        guard let date = inputFormatter.date(from: self) else {
              return nil
          }
          
          let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = "d MMMM HH:mm"
          outputFormatter.locale = Locale(identifier: "ru_RU")
          
          return outputFormatter.string(from: date)
    }
}
