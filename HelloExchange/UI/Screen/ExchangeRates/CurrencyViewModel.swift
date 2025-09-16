//
//  CurrencyViewModel.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import UIKit
import Combine

final class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    private var cancellables = Set<AnyCancellable>()

    func loadCurrencies() {
        let allCurrenciesPublisher = CurrencyService().fetchAllCurrencies()
        let krwRatesPublisher = CurrencyService().fetchKRWRates()

        Publishers.Zip(allCurrenciesPublisher, krwRatesPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error fetching currencies: \(error)")
                    }
                },
                receiveValue: { [weak self] currencies, krwRates in
                    // currencies 배열에 KRW 기준 환율 적용
                    let updatedCurrencies = currencies.map { currency -> Currency in
                        var updated = currency
                        updated.krwRate = krwRates[currency.code.lowercased()]
                        return updated
                    }
                    self?.currencies = updatedCurrencies
                }
            )
            .store(in: &cancellables)
    }

}
