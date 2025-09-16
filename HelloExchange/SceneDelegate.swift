//
//  SceneDelegate.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    private let currencyService = CurrencyService()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = HelloExchangeViewController()
        self.window = window
        window.makeKeyAndVisible()

        // 👉 앱 시작 시 데이터 불러오기
        fetchCurrencies()
    }

    private func fetchCurrencies() {
        // 모든 통화 데이터를 먼저 가져오기
        currencyService.fetchAllCurrencies()
            .flatMap { currencies -> AnyPublisher<[Currency], Error> in
                // KRW 환율 데이터를 가져오기
                self.currencyService.fetchKRWRates()
                    .map { krwRates -> [Currency] in
                        currencies.map { currency in
                            var updated = currency
                            updated.krwRate = krwRates[currency.code.lowercased()]
                            return updated
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main) // UI 업데이트는 메인 스레드
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("✅ 통화 + KRW 환율 데이터 불러오기 완료")
                    case .failure(let error):
                        print("❌ 데이터 불러오기 실패: \(error)")
                    }
                },
                receiveValue: { currencies in
                    print("🌍 불러온 통화 개수: \(currencies.count)")

                    // 데이터 하나씩 출력
                    currencies.prefix(50).forEach { currency in
                        if let rate = currency.krwRate {
                            print("💰 코드: \(currency.code), 이름: \(currency.name), KRW: \(rate)")
                        } else {
                            print("💰 코드: \(currency.code), 이름: \(currency.name), KRW: 없음")
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }


}
