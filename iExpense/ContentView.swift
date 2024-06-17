//
//  ContentView.swift
//  iExpense
//
//  Created by Mehmet Alp Sönmez on 30/05/2024.
//

import SwiftData
import SwiftUI



struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingAddExpense = false
    @State private var showingOnlyPersonal = false
    
    @State private var sortOrder = [
        SortDescriptor(\Expenses.amount),
        SortDescriptor(\Expenses.name)
      ]
    
    var body: some View {
        NavigationStack {
            ExpenseView(showingOnlyPersonal: showingOnlyPersonal, sortOrder: sortOrder)
                .navigationTitle("iExpense")
                .scrollContentBackground(.hidden)
                .background(RadialGradient(colors: [.green, .red], center: .center, startRadius: 10, endRadius: 500))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddExpense = true }) {
                            Image(systemName: "plus")
                        }
                        .foregroundStyle(.primary)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Ascending")
                                .tag([
                                    SortDescriptor(\Expenses.amount),
                                    SortDescriptor(\Expenses.name)
                                ])
                            Text("Descending")
                                .tag([
                                    SortDescriptor(\Expenses.amount, order: .reverse),
                                    SortDescriptor(\Expenses.name)
                                ])
                        }
                        
                    }
                }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(showingOnlyPersonal ? "Show All" : "Show Only Personal" ) {
                            showingOnlyPersonal.toggle()
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: Expenses(name: "", type: "", amount: 0))
                }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
