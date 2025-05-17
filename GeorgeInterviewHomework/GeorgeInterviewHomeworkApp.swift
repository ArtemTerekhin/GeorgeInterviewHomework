//
//  GeorgeInterviewHomeworkApp.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 16.05.2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct GeorgeInterviewHomeworkApp: App {
    var body: some Scene {
        WindowGroup {
            AccountListView(
                store: Store(
                    initialState: AccountList.State(),
                    reducer: { AccountList() }
                )
            )
        }
    }
}
