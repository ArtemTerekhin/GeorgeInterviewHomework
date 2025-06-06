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
                        AccountView(account: account)
                            .onTapGesture {
                                viewStore.send(.selectAccount(account.id))
                            }
                            .onAppear {
                                if viewStore.accounts.last?.id == account.id {
                                    viewStore.send(.loadNextPage)
                                }
                            }
                    }
                }
                .navigationTitle("Transparent Accounts")
                .onAppear {
                    if viewStore.accounts.isEmpty {
                        viewStore.send(.fetch)
                    }
                }
                .searchable(
                    text: viewStore.binding(
                        get: \.searchText,
                        send: AccountList.Action.searchTextChanged
                    )
                )
                .refreshable {
                    viewStore.send(.refresh)
                }
                .navigationDestination(
                    item: $store.scope(
                        state: \.destination?.accountDetail,
                        action: \.destination.accountDetail
                    ),
                    destination: AccountDetailView.init
                )
                .overlay {
                    if viewStore.isLoading {
                        ProgressView("Loading...")
                    }
                }
            }
        }
    }
}
