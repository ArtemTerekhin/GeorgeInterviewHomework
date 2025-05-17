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
    @Dependency(\.calendar) var calendar
    @Dependency(\.date) var date

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.isLoadingTransactions = true

            let id = state.id

            return .merge(
                .run { send in
                    await send(
                        .response(TaskResult {
                            try await apiClient.getAccountDetail(id)
                        })
                    )
                },
                .run { [id = state.id, toDate = date()] send in
                    guard let fromDate = calendar.date(byAdding: .day, value: -1, to: toDate) else {
                        return
                    }

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
