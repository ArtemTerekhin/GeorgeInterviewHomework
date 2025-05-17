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
                VStack {
                    Text("Account info")
                }
                .navigationTitle("Transparent Accounts")
            }
        }
    }
}
