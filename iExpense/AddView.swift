//
//  AddView.swift
//  iExpense
//
//  Created by Mehmet Alp Sönmez on 31/05/2024.
//
import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    TextField("Name", text: $name)
                        .listRowBackground(Color.white.opacity(0.3))
                        .foregroundColor(.black)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.3))
                    
                    TextField("Amount", value: $amount, format:.currency(code: "GBP"))
                        .keyboardType(.decimalPad)
                        .listRowBackground(Color.white.opacity(0.3))
                }

                
            }
            .scrollContentBackground(.hidden)
            .background(RadialGradient(colors: [.green, .red], center: .center, startRadius: 10, endRadius: 500))
            .navigationTitle("Add New Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Expenses(name: name, type: type, amount: amount)
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Expenses.self, configurations: config)
            let example = Expenses(name: "test", type: "Personal", amount: 200)
            return AddView(expenses: example)
                .modelContainer(container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
}
