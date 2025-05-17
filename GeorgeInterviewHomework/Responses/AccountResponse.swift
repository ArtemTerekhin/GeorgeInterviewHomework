//
//  AccountResponse.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation

struct AccountResponse: Decodable, Equatable {
    let pageNumber: Int
    let pageCount: Int
    let pageSize: Int
    let recordCount: Int
    let nextPage: Int?
    let accounts: [Account]
}
