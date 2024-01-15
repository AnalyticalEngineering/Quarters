//
//  Transaction.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    /// Properties
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var transactionType: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, transactionType: TransactionType, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.transactionType = transactionType.rawValue
        self.tintColor = tintColor.color
    }
    
    /// Extracting Color Value from tintColor String
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    
    @Transient
    var rawTransactionType: TransactionType? {
        return TransactionType.allCases.first(where: { transactionType == $0.rawValue })
    }
}
