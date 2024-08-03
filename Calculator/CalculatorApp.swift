//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Wing Lam Cheng on 11/25/23.
//

import SwiftUI

@main
struct CalculatorApp: App {
  @StateObject private var dataController = DataController()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
  }
}
