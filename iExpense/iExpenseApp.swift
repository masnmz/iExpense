//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Mehmet Alp Sönmez on 30/05/2024.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expenses.self)
    }
}
