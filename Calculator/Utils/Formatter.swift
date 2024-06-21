//
//  Formatter.swift
//  Calculator
//
//  Created by Wing Lam Cheng on 6/20/24.
//

import Foundation

func formatter() -> NumberFormatter {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  return formatter
}

func dateFormatter() -> DateFormatter {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .short
  return formatter
}

func formattedDate(from date: Date) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "MMM d, yyyy - HH:mm:ss"
  return dateFormatter.string(from: date)
}
