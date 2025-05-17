//
//  TransactionResponse.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation

struct TransactionResponse: Decodable, Equatable {
    let pageNumber: Int
    let pageSize: Int
    let pageCount: Int
    let nextPage: Int?
    let recordCount: Int
    let transactions: [Transaction]
}
