//
//  AmountFormatter.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation

func formattedAmount(_ amount: Double, currencyCode: String) -> String {
    let hasFraction = amount.truncatingRemainder(dividingBy: 1) != 0
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    formatter.minimumFractionDigits = hasFraction ? 2 : 0
    formatter.maximumFractionDigits = 2
    
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
}
