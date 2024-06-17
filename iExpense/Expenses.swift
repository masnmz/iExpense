//
//  Expenses.swift
//  iExpense
//
//  Created by Mehmet Alp Sönmez on 15/06/2024.
//


import Foundation
import SwiftData

@Model
class Expenses {
    var name: String
    var type: String
    var amount: Double

    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
