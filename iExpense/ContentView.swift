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
    
    @Query(sort: [
        SortDescriptor(\Expenses.amount, order: .reverse),
        SortDescriptor(\Expenses.name)
    ]) var expenses: [Expenses]
    
    var body: some View {
        NavigationStack {
            List {
                let personalExpenses = expenses.filter {$0.type == "Personal"}
                let businessExpenses = expenses.filter {$0.type == "Business"}
                
                if personalExpenses.isEmpty == false {
                    Section("Personal Expenses") {
                        ForEach(personalExpenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.name)
                                        .font(.headline)
                                    Text(expense.type)
                                }
                                
                                Spacer()
                                
                                Text(expense.amount, format: .currency(code: "GBP"))
                                    .foregroundStyle(expense.amount < 10 ? .purple : expense.amount > 100 ? .red : .blue)
                            }
                        }
                        .onDelete { offsets in
                            removeItems(offsets, type: "Personal")
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                }
                if businessExpenses.isEmpty == false  {
                    Section("Business Expenses") {
                        ForEach(businessExpenses) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "GBP"))
                                    .foregroundStyle(item.amount < 10 ? .green : item.amount > 100 ? .red : .blue)
                            }
                        }
                        .onDelete { offsets in
                            removeItems(offsets, type: "Business")
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                }
            }
            .navigationTitle("iExpense")
            .scrollContentBackground(.hidden)
            .background(RadialGradient(colors: [.green, .red], center: .center, startRadius: 10, endRadius: 500))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: Expenses(name: "", type: "", amount: 0))
            }
        }
    }
    
    private func removeItems(_ offsets: IndexSet, type: String) {
        let filteredItems = expenses.filter { $0.type == type }
        for offset in offsets {
            if let index = expenses.firstIndex(where: { $0.id == filteredItems[offset].id }) {
                modelContext.delete(expenses[index])
            }
        }
    }
}

#Preview {
    ContentView()
}
