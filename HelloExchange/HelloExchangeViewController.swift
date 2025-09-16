//
//  HelloExchangeViewController.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import UIKit
import Combine

// MARK: - ViewController
final class HelloExchangeViewController: UIViewController {

    private let tableView = UITableView()
    private let service = CurrencyService()
    private var cancellables = Set<AnyCancellable>()

    private var currencies: [Currency] = []
    private var krwRates: [String: Double] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        fetchData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "ExchangeRateCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    private func fetchData() {
        // 모든 통화 + KRW 환율 동시에 가져오기
        let allCurrenciesPublisher = service.fetchAllCurrencies()
        let krwRatesPublisher = service.fetchKRWRates()

        Publishers.Zip(allCurrenciesPublisher, krwRatesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] currencies, rates in
                self?.currencies = currencies
                self?.krwRates = rates
                self?.tableView.reloadData()
                self?.printCurrencies()
            }
            .store(in: &cancellables)
    }

    private func printCurrencies() {
        for currency in currencies {
            let rate = krwRates[currency.code.lowercased()] ?? 0
            print("\(currency.code) - \(currency.name) : \(rate) KRW")
        }
    }
}

// MARK: - UITableViewDataSource
extension HelloExchangeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateCell", for: indexPath) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let currency = currencies[indexPath.row]
        let rate = krwRates[currency.code.lowercased()] ?? 0

        cell.configure(
            fullName: currency.name,
            code: currency.code,
            value: "\(rate)",
            tag: currency.isCrypto ? "CRYPTO" : "FIAT",
            tagColor: currency.isCrypto ? (UIColor.palette.yellowBg ?? .yellow) : (UIColor.palette.blue ?? .blue)
        )

        return cell
    }
}
