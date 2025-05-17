//
//  Transaction.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation

struct Transaction: Decodable, Equatable, Identifiable {
    struct Amount: Decodable, Equatable {
        let value: Double
        let precision: Int
        let currency: String
    }

    struct User: Decodable, Equatable {
        let accountNumber: String
        let bankCode: String
        let iban: String?
        let specificSymbol: String?
        let specificSymbolParty: String?
        let variableSymbol: String?
        let constantSymbol: String?
        let name: String?
        let description: String?
    }

    var id: UUID { UUID() }
    let amount: Amount
    let type: String
    let dueDate: String
    let processingDate: String
    let sender: User
    let receiver: User
    let typeDescription: String
}
