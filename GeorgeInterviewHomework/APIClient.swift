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
    static let baseURL = "https://webapi.developers.erstegroup.com/api/csas/public/sandbox/v3"

    private static func makeRequest(
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(string: "\(baseURL)\(path)") else {
            throw URLError(.badURL)
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("iOS-App", forHTTPHeaderField: "User-Agent")
        request.setValue("49c7a72e-b244-4e8d-9bb2-d73c576cba0d", forHTTPHeaderField: "WEB-API-key")
        request.setValue("env.csas.sandbox", forHTTPHeaderField: "WEB-API-env")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")

        return request
    }

    private static func fetch<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("❌ HTTP Error: \(httpResponse.statusCode)")
            print(String(data: data, encoding: .utf8) ?? "No response body")
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
            let path = "/transparentAccounts/\(id)"
            let request = try makeRequest(path: path)
            return try await fetch(request)
        },

        getTransactions: { accountId, page, from, to, filter in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]

            var queryItems: [URLQueryItem] = [
                .init(name: "page", value: "\(page)"),
                .init(name: "size", value: "25"),
                .init(name: "sort", value: "processingDate"),
                .init(name: "order", value: "desc"),
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
