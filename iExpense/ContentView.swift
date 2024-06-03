//
//  ContentView.swift
//  iExpense
//
//  Created by Mehmet Alp Sönmez on 30/05/2024.
//


import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}
struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showindAddExpense = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if !expenses.items.filter({$0.type == "Personal"}).isEmpty {
                        Section("Personal Expenses"){
                            ForEach(expenses.items.filter {$0.type == "Personal"}) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.amount, format: .currency(code: "GBP"))
                                        .foregroundStyle(item.amount < 10 ? .green : item.amount > 100 ? .indigo : .red)
                                }
                            }
                            .onDelete(perform: removeItems)
                        }
                    }
                    if !expenses.items.filter({$0.type == "Business"}).isEmpty {
                        Section("Business Expenses"){
                            ForEach(expenses.items.filter {$0.type == "Business"}) { item in
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
                            .onDelete(perform: removeItems)
                        }
                    }
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showindAddExpense = true
                    }
                }
            }
            .background(LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $showindAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
