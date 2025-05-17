//
//  AccountDetailReducer.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AccountDetailReducer: Reducer {
    @ObservableState
    struct State: Equatable {
        var id: String
        var detail: AccountDetail?
        var isLoading: Bool = false
        var transactions: [Transaction] = []
        var isLoadingTransactions: Bool = false
    }

    enum Action: Equatable {
        case onAppear
        case response(TaskResult<AccountDetail>)
        case transactionsResponse(TaskResult<TransactionResponse>)
    }

    @Dependency(\.apiClient) var apiClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.isLoadingTransactions = true

            let id = state.id
            let now = Date()
            let calendar = Calendar.current
            let fromDate = calendar.date(byAdding: .day, value: -1, to: now)!
            let toDate = now

            return .merge(
                .run { send in
                    await send(
                        .response(TaskResult {
                            try await apiClient.getAccountDetail(id)
                        })
                    )
                },
                .run { send in
                    await send(
                        .transactionsResponse(TaskResult {
                            try await apiClient.getTransactions(id, 0, fromDate, toDate, nil)
                        })
                    )
                }
            )

        case let .response(.success(detail)):
            state.detail = detail
            state.isLoading = false

            return .none

        case .response(.failure):
            state.isLoading = false

            return .none

        case let .transactionsResponse(.success(response)):
            state.transactions = response.transactions
            state.isLoadingTransactions = false

            return .none

        case let .transactionsResponse(.failure(error)):
            print("Failure \(error)")
            state.isLoadingTransactions = false

            return .none
        }
    }
}
