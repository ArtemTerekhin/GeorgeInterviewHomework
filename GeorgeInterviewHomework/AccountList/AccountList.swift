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
    @Reducer(state: .equatable)
    enum Destination {
        case accountDetail(AccountDetailReducer)
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?

        var accounts: [Account] = []
        var isLoading = false
        var page: Int = 0
        var hasMorePages = true
        var searchText = ""
    }

    enum Action {
        case fetch
        case loadNextPage
        case loadResponse(TaskResult<AccountResponse>)
        case searchTextChanged(String)
        case refresh
        case selectAccount(String)
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainQueue) var mainScheduler

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
                let filter = state.searchText

                return .run { send in
                    await send(.loadResponse(
                        TaskResult {
                            try await apiClient.getAccounts(page, 25, filter)
                        }
                    ))
                }

            case let .searchTextChanged(text):
                state.searchText = text
                state.page = 0
                state.accounts = []
                state.hasMorePages = true
                state.isLoading = false

                return .run { send in
                    await send(.loadNextPage)
                }
                .debounce(id: AccountsDebounceId(), for: 0.3, scheduler: mainScheduler)
                .cancellable(id: AccountsId(), cancelInFlight: true)

            case .loadNextPage:
                guard !state.isLoading, state.hasMorePages else { return .none }
                state.isLoading = true

                let page = state.page
                let filter = state.searchText

                return .run { send in
                    await send(.loadResponse(
                        TaskResult {
                            try await apiClient.getAccounts(page, 25, filter)
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

            case .refresh:
                state.page = 0
                state.accounts = []
                state.hasMorePages = true

                return .send(.loadNextPage)

            case let .selectAccount(id):
                state.destination = .accountDetail(.init(id: id))

                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
