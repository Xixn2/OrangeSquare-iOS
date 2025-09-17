//
//  HelloExchangeViewController.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import UIKit
import Combine

final class HelloExchangeViewController: UIViewController {

    private let searchField = UITextField()
    private let tableView = UITableView()
    private let service = CurrencyService()
    private var cancellables = Set<AnyCancellable>()

    private var currencies: [Currency] = []
    private var filteredCurrencies: [Currency] = []
    private var krwRates: [String: Double] = [:]

    private var searchText: String = "" {
        didSet { filterCurrencies() }
    }

    private var displayItems: [DisplayItem] = []

    enum DisplayItem {
        case currency(Currency)
        case coupon
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchField()
        setupTableView()
        fetchData()
    }

    // MARK: - UI
    private func setupSearchField() {
        view.addSubview(searchField)
        searchField.placeholder = "검색하고 싶은 화폐의 코드 또는 이름을 입력해주세요."
        searchField.addTarget(self, action: #selector(searchFieldChanged), for: .editingChanged)

        searchField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(40)
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "ExchangeRateCell")
        tableView.register(CouponCell.self, forCellReuseIdentifier: "CouponCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    // MARK: - Data
    private func fetchData() {
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
                self?.filteredCurrencies = currencies
                self?.updateDisplayItems()
            }
            .store(in: &cancellables)
    }

    private func filterCurrencies() {
        guard !searchText.isEmpty else {
            filteredCurrencies = currencies
            updateDisplayItems()
            return
        }

        filteredCurrencies = currencies.filter { currency in
            currency.name.lowercased().contains(searchText.lowercased()) ||
            currency.code.lowercased().contains(searchText.lowercased())
        }

        updateDisplayItems()
    }

    private func updateDisplayItems() {
        displayItems = []

        for (index, currency) in filteredCurrencies.enumerated() {
            displayItems.append(.currency(currency))
            if (index + 1) % 10 == 0 {
                displayItems.append(.coupon) // 10번째마다 쿠폰 삽입
            }
        }

        tableView.reloadData()
    }

    // MARK: - Action
    @objc private func searchFieldChanged() {
        searchText = searchField.text ?? ""
    }

    // MARK: - Highlight
    private func highlight(_ text: String, searchText: String, defaultColor: UIColor, defaultFont: UIFont) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: defaultFont,
            .foregroundColor: defaultColor
        ]
        let attributed = NSMutableAttributedString(string: text, attributes: attributes)

        guard !searchText.isEmpty else {
            return attributed
        }

        let range = (text.lowercased() as NSString).range(of: searchText.lowercased())
        if range.location != NSNotFound {
            attributed.addAttribute(.foregroundColor, value: UIColor.palette.yellow, range: range)
        }
        return attributed
    }
}

// MARK: - UITableViewDataSource
extension HelloExchangeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = displayItems[indexPath.row]

        switch item {
        case .currency(let currency):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ExchangeRateCell",
                for: indexPath
            ) as? ExchangeRateCell else { return UITableViewCell() }

            let rate = krwRates[currency.code.lowercased()] ?? 0
            cell.configure(
                fullName: highlight(currency.name, searchText: searchText, defaultColor: UIColor.palette.blue ?? .blue, defaultFont: cell.fullNameLabel.font ?? .systemFont(ofSize: 14)),
                code: highlight(currency.code, searchText: searchText, defaultColor: UIColor.palette.grey ?? .gray, defaultFont: cell.codeLabel.font ?? .systemFont(ofSize: 14)),
                value: "\(rate)",
                tag: currency.isCrypto ? "CRYPTO" : "FIAT",
                tagColor: currency.isCrypto ? (UIColor.palette.yellowBg ?? .yellow) : (UIColor.palette.blue ?? .blue)
            )
            return cell

        case .coupon:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as? CouponCell else {
                return UITableViewCell()
            }
            cell.configure()
            return cell
        }
    }
}
