//
//  Currency.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import Foundation

struct Currency: Equatable {
    let code: String
    let name: String
}

extension Currency {
    var fiatCurrency: FiatCurrency? {
        FiatCurrency(rawValue: code.uppercased())
    }

    var isFiat: Bool {
        fiatCurrency != nil
    }

    var isCrypto: Bool {
        !isFiat
    }
}

extension Currency {
    var searchKeys: [String] {
        [code, name].map({ $0.lowercased() })
    }
}
