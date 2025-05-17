//
//  AccountDetailView.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import ComposableArchitecture
import SwiftUI

struct AccountDetailView: View {
    let store: StoreOf<AccountDetailReducer>

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            Group {
                if let detail = viewStore.detail {
                    List {
                        Section("Account Info") {
                            Text("Name: \(detail.name)")
                            Text("Account: \(detail.accountNumber)/\(detail.bankCode)")
                            Text("IBAN: \(detail.iban)")
                            Text("Balance: \(detail.balance, format: .currency(code: detail.currency))")
                        }

                        if let note = detail.note {
                            Section("Note") {
                                Text(note)
                            }
                        }

                        Section("Transactions") {
                            if viewStore.isLoadingTransactions {
                                ProgressView("Loading Transactions...")
                            } else if viewStore.transactions.isEmpty {
                                Text("No transactions")
                                    .foregroundStyle(.secondary)
                            } else {
                                ForEach(viewStore.transactions) { transaction in
                                    TransactionView(transaction: transaction)
                                }
                            }
                        }
                    }
                } else if viewStore.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("No data available")
                }
            }
            .navigationTitle("Account Detail")
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

