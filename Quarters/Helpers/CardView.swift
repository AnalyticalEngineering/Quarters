//
//  CardView.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.2))
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("\(currencyString(income - expense))")
                        .font(.title.bold())
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(TransactionType.allCases, id: \.rawValue) { transactionType in
                        let symbolImage = transactionType == .income ? "arrow.down" : "arrow.up"
                        let tint = transactionType == .income ? Color.green : Color.red
                        
                        HStack(spacing: 10) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(transactionType.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currencyString(transactionType == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                            }
                            
                            if transactionType == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4590, expense: 2389)
    }
}
