//
//  KRWRatesResponse.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import Foundation

struct KRWRatesResponse: Decodable {
    let date: String
    let krw: [String: Double]
}
