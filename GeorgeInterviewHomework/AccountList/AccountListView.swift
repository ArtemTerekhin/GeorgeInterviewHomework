//
//  AccountListView.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import ComposableArchitecture
import SwiftUI

struct AccountListView: View {
    @Bindable private(set) var store: StoreOf<AccountList>

    init(store: StoreOf<AccountList>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    ForEach(viewStore.accounts, id: \.id) { account in
                        HStack {
                            Text(account.name)
                            Text(String(format: "%.2f %@", account.balance, account.currency ?? "CZK"))
                        }
                    }

                    if viewStore.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Transparent Accounts")
            }
        }
    }
}
