//
//  ChartModel.swift
//  Quarters
//
//  Created by J. DeWeese on 1/11/24.
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var transactionTypes: [ChartTransactionType]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartTransactionType: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var transactionType: TransactionType
}
