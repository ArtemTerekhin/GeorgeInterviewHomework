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
    }

    enum Action: Equatable {
        case onAppear
        case response(TaskResult<AccountDetail>)
    }

    @Dependency(\.apiClient) var apiClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true

            let id = state.id

            return .merge(
                .run { send in
                    await send(
                        .response(TaskResult {
                            try await apiClient.getAccountDetail(id)
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
        }
    }
}
