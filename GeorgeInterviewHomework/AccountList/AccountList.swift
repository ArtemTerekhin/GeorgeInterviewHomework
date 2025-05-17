//
//  AccountList.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AccountList: Reducer {
    @ObservableState
    struct State: Equatable {
        var accounts: [Account] = []
        var isLoading = false
        var page: Int = 0
        var hasMorePages = true
    }

    enum Action {
        case fetch
        case loadNextPage
        case loadResponse(TaskResult<AccountResponse>)
    }

    @Dependency(\.apiClient) var apiClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            struct AccountsDebounceId: Hashable {}
            struct AccountsId: Hashable {}

            switch action {
            case .fetch:
                state.page = 0
                state.accounts = []
                state.hasMorePages = true
                state.isLoading = true

                let page = 0

                return .run { send in
                    await send(.loadResponse(
                        TaskResult {
                            try await apiClient.getAccounts(page, 25, "")
                        }
                    ))
                }

            case .loadNextPage:
                guard !state.isLoading, state.hasMorePages else { return .none }
                state.isLoading = true

                let page = state.page

                return .run { send in
                    await send(.loadResponse(
                        TaskResult {
                            try await apiClient.getAccounts(page, 25, "")
                        }
                    ))
                }

            case let .loadResponse(.success(response)):
                state.isLoading = false
                state.page += 1
                state.hasMorePages = state.page < response.pageCount
                state.accounts.append(contentsOf: response.accounts)

                return .none

            case .loadResponse(.failure):
                state.isLoading = false

                return .none
            }
        }
    }
}
