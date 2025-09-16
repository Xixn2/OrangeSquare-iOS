//
//  CurrencyService.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

// MARK: - Moya Target
enum CurrencyAPI {
    case allCurrencies
    case krwRates
}

extension CurrencyAPI: TargetType {
    var baseURL: URL { URL(string: "https://cdn.jsdelivr.net")! }

    var path: String {
        switch self {
        case .allCurrencies:
            return "/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"
        case .krwRates:
            return "/npm/@fawazahmed0/currency-api@latest/v1/currencies/krw.json"
        }
    }

    var method: Moya.Method { .get }
    var sampleData: Data { Data() }
    var task: Task { .requestPlain }
    var headers: [String : String]? { ["Content-Type": "application/json"] }
}

// MARK: - Service
final class CurrencyService {
    private let provider = MoyaProvider<CurrencyAPI>()

    // 전체 통화
    func fetchAllCurrencies() -> AnyPublisher<[Currency], Error> {
        provider.requestPublisher(.allCurrencies)
            .map(\.data)
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .map { dict in
                dict.compactMap { (code, name) -> Currency? in
                    guard !name.isEmpty else { return nil }
                    return Currency(code: code.uppercased(), name: name)
                }
                .sorted(by: { $0.code < $1.code })
            }
            .eraseToAnyPublisher()
    }

    // KRW 기준 환율
    func fetchKRWRates() -> AnyPublisher<[String: Double], Error> {
        provider.requestPublisher(.krwRates)
            .map(\.data)
            .decode(type: KRWRatesResponse.self, decoder: JSONDecoder())
            .map { $0.krw }
            .eraseToAnyPublisher()
    }
}
