//
//  HelloExchangeViewController.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import UIKit

final class HelloExchangeViewController: UIViewController {

    private let tableView = UITableView()

    // ExchangeRateCell을 테스트하기 위한 더미 데이터입니다.
    private let exchangeRates: [(fullName: String, code: String, value: String, tag: String, tagColor: UIColor)] = [
        ("US Dollar", "USD", "1,234.56", "CRYPTO", .palette.yellowBg ?? .yellow),
        ("Euro", "EUR", "1,100.78", "CRYPTO", .palette.yellowBg ?? .yellow),
        ("Japanese Yen", "JPY", "0.89", "CRYPTO", .palette.yellowBg ?? .red)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "ExchangeRateCell")
        tableView.dataSource = self

        tableView.separatorStyle = .none 
    }
}

// MARK: - UITableViewDataSource
extension HelloExchangeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateCell", for: indexPath) as? ExchangeRateCell else {
            return UITableViewCell()
        }

        let rate = exchangeRates[indexPath.row]
        cell.configure(
            fullName: rate.fullName,
            code: rate.code,
            value: rate.value,
            tag: rate.tag,
            tagColor: rate.tagColor
        )

        return cell
    }
}

