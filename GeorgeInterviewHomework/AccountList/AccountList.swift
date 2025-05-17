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
    }

    enum Action {
        case fetch
        case loadResponse(TaskResult<AccountResponse>)
    }

    @Dependency(\.apiClient) var apiClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            struct AccountsDebounceId: Hashable {}
            struct AccountsId: Hashable {}

            switch action {
            case .fetch:
                state.accounts = []
                state.isLoading = true

                return .run { send in
                    await send(.loadResponse(
                        TaskResult {
                            try await apiClient.getAccounts(0, 25, nil)
                        }
                    ))
                }

            case let .loadResponse(.success(response)):
                state.isLoading = false
                state.accounts.append(contentsOf: response.accounts)

                return .none

            case .loadResponse(.failure):
                state.isLoading = false

                return .none
            }
        }
    }
}
