//
//  AccountView.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import SwiftUI

struct AccountView: View {
    let id: String
    let name: String
    let description: String?
    let accountNumber: String
    let bankCode: String
    let balance: Double
    let currency: String?

    init(account: Account) {
        self.id = account.id
        self.name = account.name
        self.description = account.description
        self.accountNumber = account.accountNumber
        self.bankCode = account.bankCode
        self.balance = account.balance
        self.currency = account.currency
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)

                if let description = description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Text("\(accountNumber)/\(bankCode)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f %@", balance, currency ?? "CZK"))
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .contentShape(Rectangle())
    }
}
