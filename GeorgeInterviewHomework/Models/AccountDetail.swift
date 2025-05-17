//
//  AccountDetail.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation

struct AccountDetail: Decodable, Equatable {
    let accountNumber: String
    let bankCode: String
    let transparencyFrom: String
    let transparencyTo: String
    let publicationTo: String
    let actualizationDate: String
    let balance: Double
    let currency: String
    let name: String
    let description: String?
    let note: String?
    let iban: String
    let statements: [String]?
}
