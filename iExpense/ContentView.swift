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
                                        .foregroundStyle(item.amount < 10 ? .green : item.amount > 100 ? .red : .blue)
                                }
                            }
                            .onDelete { offsets in
                                removeItems(offsets, type:"Personal")
                            }
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
                            .onDelete { offsets in
                                removeItems(offsets, type:"Business")
                            }
                        }
                    }
                }
                .navigationTitle("iExpense")
                .toolbar {
                    NavigationLink(destination: AddView(expenses: expenses)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .background(LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .scrollContentBackground(.hidden)
//        .sheet(isPresented: $showindAddExpense) {
//            AddView(expenses: expenses)
//        }
    }
    
    func removeItems(_ offsets: IndexSet, type: String) {
            let filteredItems = expenses.items.filter { $0.type == type }
            for offset in offsets {
                if let index = expenses.items.firstIndex(where: { $0.id == filteredItems[offset].id }) {
                    expenses.items.remove(at: index)
                }
            }
        }
}


#Preview {
    ContentView()
}
