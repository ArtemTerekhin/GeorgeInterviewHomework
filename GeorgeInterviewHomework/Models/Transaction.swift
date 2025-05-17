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

extension Transaction {
    var formattedProcessingDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")

        guard let date = inputFormatter.date(from: processingDate) else {
            return processingDate
        }

        return outputFormatter.string(from: date)
    }
}

