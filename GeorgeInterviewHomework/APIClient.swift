//
//  APIClient.swift
//  GeorgeInterviewHomework
//
//  Created by Artem Terekhin on 17.05.2025.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    var getAccounts: (_ page: Int, _ size: Int, _ filter: String?) async throws -> AccountResponse
    var getAccountDetail: (_ id: String) async throws -> AccountDetail
    var getTransactions: (
        _ accountId: String,
        _ page: Int,
        _ from: Date,
        _ to: Date,
        _ filter: String?
    ) async throws -> TransactionResponse
}

extension APIClient: DependencyKey {
    enum Constants {
        static let baseURL = "https://webapi.developers.erstegroup.com/api/csas/public/sandbox/v3"
        static let userAgent = "iOS-App"
        static let apiKey = "49c7a72e-b244-4e8d-9bb2-d73c576cba0d"
        static let apiEnv = "env.csas.sandbox"
        static let acceptEncoding = "gzip"
        static let acceptType = "application/json"

        static let defaultAccountPageSize = 25
        static let defaultTransactionPageSize = 25
        static let defaultSortField = "processingDate"
        static let defaultSortOrder = "desc"
    }

    private static func makeRequest(
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(string: "\(Constants.baseURL)\(path)") else {
            throw URLError(.badURL)
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(Constants.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue(Constants.apiKey, forHTTPHeaderField: "WEB-API-key")
        request.setValue(Constants.apiEnv, forHTTPHeaderField: "WEB-API-env")
        request.setValue(Constants.acceptType, forHTTPHeaderField: "Accept")
        request.setValue(Constants.acceptEncoding, forHTTPHeaderField: "Accept-Encoding")

        return request
    }

    private static func fetch<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            debugPrint("❌ HTTP Error: \(httpResponse.statusCode)")
            debugPrint(String(data: data, encoding: .utf8) ?? "No response body")
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    static let liveValue = APIClient(
        getAccounts: { page, size, filter in
            let queryItems: [URLQueryItem] = [
                .init(name: "page", value: "\(page)"),
                .init(name: "size", value: "\(size)")
            ] + (filter?.isEmpty == false ? [.init(name: "filter", value: filter)] : [])

            let request = try makeRequest(path: "/transparentAccounts", queryItems: queryItems)
            return try await fetch(request)
        },

        getAccountDetail: { id in
            let request = try makeRequest(path: "/transparentAccounts/\(id)")
            return try await fetch(request)
        },

        getTransactions: { accountId, page, from, to, filter in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]

            var queryItems: [URLQueryItem] = [
                .init(name: "page", value: "\(page)"),
                .init(name: "size", value: "\(Constants.defaultTransactionPageSize)"),
                .init(name: "sort", value: Constants.defaultSortField),
                .init(name: "order", value: Constants.defaultSortOrder),
                .init(name: "dateFrom", value: formatter.string(from: from)),
                .init(name: "dateTo", value: formatter.string(from: to))
            ]

            if let filter = filter, !filter.isEmpty {
                queryItems.append(.init(name: "filter", value: filter))
            }

            let path = "/transparentAccounts/\(accountId)/transactions/"
            let request = try makeRequest(path: path, queryItems: queryItems)
            return try await fetch(request)
        }
    )
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
