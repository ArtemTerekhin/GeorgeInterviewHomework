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
        HStack {
            Circle()
                .padding(.top, 6)
                .frame(width: 16, height: 16)
                .foregroundStyle(amount >= 0 ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {
                Text(typeDescription)
                    .font(.headline)
                Text("\(amount, specifier: "%.2f") \(currency)")
                    .font(.subheadline)
                    .foregroundStyle(amount >= 0 ? .green : .red)
                Text("Date: \(processingDate)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
