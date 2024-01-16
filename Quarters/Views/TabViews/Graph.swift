//
//  Graph.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI
import Charts
import SwiftData

struct Graphs: View {
    /// View Properties
    @State private var chartGroups: [ChartGroup] = []
    @State private var isLoading: Bool = false
    @State private var isSaved: Bool = false
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .opacity(chartGroups.isEmpty ? 0 : 1)
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            
                            NavigationLink {
                                ListOfExpenses(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Tracking Metrics")
            .background(.gray.opacity(0.15))
            .overlay {
                if chartGroups.isEmpty && !isLoading {
                    ContentUnavailableView("No Transactions Found", systemImage: "xmark.seal")
                }
                
                if isLoading && chartGroups.isEmpty {
                    ProgressView()
                }
            }
            .onAppear {
                /// Intial Chart Group Creation
                if chartGroups.isEmpty {
                    isSaved = true
                }
                createChartGroup()
            }
        }
        /// Only Refreshes Graph Content if there is any change in data
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { _ in
            isSaved = true
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        /// Chart View
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.transactionTypes) { chart  in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.transactionType.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.transactionType.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.transactionType.rawValue))
                }
            }
        }
        /// Making Chart Scrollable
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
            }
        }
        /// Foreground Colors
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroup() {
        guard isSaved && !isLoading else { return }
        isLoading = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            let descriptor = FetchDescriptor<Transaction>()
            guard let transactions = try? context.fetch(descriptor) else { return }
            let calendar = Calendar.current
            
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                
                return components
            }
            
            /// Sorting Groups By Date
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.transactionType == TransactionType.income.rawValue })
                let expense = dict.value.filter({ $0.transactionType == TransactionType.expense.rawValue })
                
                let incomeTotalValue = total(income, transactionType: .income)
                let expenseTotalValue = total(expense, transactionType: .expense)
                
                return .init(
                    date: date,
                    transactionTypes: [
                        .init(totalValue: incomeTotalValue, transactionType: .income),
                        .init(totalValue: expenseTotalValue, transactionType: .expense)
                    ],
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue
                )
            }
            
            /// UI Must be updated on Main Thread
            DispatchQueue.main.async {
                self.chartGroups = chartGroups
                isLoading = false
                isSaved = false
            }
        }
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}

/// List Of Transactions for the Selected Month
struct ListOfExpenses: View {
    let month: Date
    /// View Properties
    @State private var selectedTransaction: Transaction?
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, transactionType: .income) { transactions in
                        ForEach(transactions) { transaction in
                            TransactionCardView(transaction: transaction)
                                .onTapGesture {
                                    selectedTransaction = transaction
                                }
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
                
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, transactionType: .expense) { transactions in
                        ForEach(transactions) { transaction in
                            TransactionCardView(transaction: transaction)
                                .onTapGesture {
                                    selectedTransaction = transaction
                                }
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
            }
            .padding(15)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
        .navigationDestination(item: $selectedTransaction) { transaction in
            TransactionView(editTransaction: transaction)
        }
    }
}
#Preview {
    Graphs()
}
