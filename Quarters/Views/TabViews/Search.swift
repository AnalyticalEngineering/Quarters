//
//  Search.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI
import Combine

struct Search: View {
    /// View Properties
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedTransactionType: TransactionType? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    //Filter Transaction View
                    FilterTransactionsView(transactionType: selectedTransactionType, searchText: filterText) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                // Transaction View
                                TransactionView(editTransaction: transaction)
                            } label: {
                                //Transaction Card View
                                TransactionCardView(transaction: transaction, showsTransactionType: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .overlay(content: {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1 : 0)
            })
            .onChange(of: searchText, { oldValue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublisher.send(newValue)
            })
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolBarContent()
                }
            }
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu {
            Button {
                selectedTransactionType = nil
            } label: {
                HStack {
                    Text("Both")
                    
                    if selectedTransactionType == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(TransactionType.allCases, id: \.rawValue) { transactionType in
                Button {
                    selectedTransactionType = transactionType
                } label: {
                    HStack {
                        Text(transactionType.rawValue)
                        
                        if selectedTransactionType == transactionType {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
}

#Preview {
    Search()
}
