//
//  TransactionView.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import SwiftUI

struct TransactionView: View {
    let typeDescription: String
    let amount: Double
    let currency: String
    let processingDate: String

    init(transaction: Transaction) {
        self.typeDescription = transaction.typeDescription
        self.amount = transaction.amount.value
        self.currency = transaction.amount.currency
        self.processingDate = transaction.processingDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(typeDescription)
                .font(.headline)
            Text("\(amount, specifier: "%.2f") \(currency)")
                .font(.subheadline)
            Text("Date: \(processingDate)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
