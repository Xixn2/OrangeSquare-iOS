import UIKit
import Combine
import SnapKit

final class HelloExchangeViewController: UIViewController {

    private let searchField = UITextField()
    private let tableView = UITableView()
    private let service = CurrencyService()
    private var cancellables = Set<AnyCancellable>()

    private var currencies: [Currency] = []
    private var filteredCurrencies: [Currency] = []
    private var krwRates: [String: Double] = [:]
    private var favoriteCurrencies: [Currency] = []
    private var searchText: String = "" { didSet { filterCurrencies() } }

    private var displayItems: [DisplayItem] = []

    enum DisplayItem { case favorites, currency(Currency), coupon }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchField()
        setupTableView()
        fetchData()
    }

    private func setupSearchField() {
        view.addSubview(searchField)
        searchField.placeholder = "검색하고 싶은 화폐의 코드 또는 이름을 입력해주세요."
        searchField.borderStyle = .roundedRect
        searchField.addTarget(self, action: #selector(searchFieldChanged), for: .editingChanged)
        searchField.snp.makeConstraints { $0.top.equalTo(view.safeAreaLayoutGuide).offset(8); $0.horizontalEdges.equalToSuperview().inset(25); $0.height.equalTo(40) }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.top.equalTo(searchField.snp.bottom).offset(8); $0.leading.trailing.bottom.equalToSuperview() }
        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: "ExchangeRateCell")
        tableView.register(CouponCell.self, forCellReuseIdentifier: "CouponCell")
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    private func fetchData() {
        Publishers.Zip(service.fetchAllCurrencies(), service.fetchKRWRates())
            .receive(on: DispatchQueue.main)
            .sink { if case let .failure(error) = $0 { print("Error: \(error)") } }
            receiveValue: { [weak self] currencies, rates in
                self?.currencies = currencies
                self?.krwRates = rates
                self?.filteredCurrencies = currencies
                self?.updateDisplayItems()
            }
            .store(in: &cancellables)
    }

    private func filterCurrencies() {
        filteredCurrencies = searchText.isEmpty
            ? currencies
            : currencies.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.code.lowercased().contains(searchText.lowercased()) }
        updateDisplayItems()
    }

    private func updateDisplayItems() {
        var items: [DisplayItem] = []
        if !favoriteCurrencies.isEmpty { items.append(.favorites) }
        for (index, currency) in filteredCurrencies.enumerated() {
            items.append(.currency(currency))
            if (index + 1) % 10 == 0 { items.append(.coupon) }
        }
        displayItems = items
        tableView.reloadData()
    }

    @objc private func searchFieldChanged() { searchText = searchField.text ?? "" }

    private func highlight(_ text: String, searchText: String, defaultColor: UIColor, defaultFont: UIFont) -> NSAttributedString {
        let base = NSMutableAttributedString(string: text, attributes: [.font: defaultFont, .foregroundColor: defaultColor])
        guard !searchText.isEmpty else { return base }
        let range = (text.lowercased() as NSString).range(of: searchText.lowercased())
        if range.location != NSNotFound { base.addAttribute(.foregroundColor, value: UIColor.palette.yellow, range: range) }
        return base
    }
}

extension HelloExchangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { displayItems.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch displayItems[indexPath.row] {
        case .favorites:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "FavoritesCell",
                for: indexPath
            ) as? FavoritesCell else {
                return UITableViewCell()
            }

            cell.favorites = favoriteCurrencies

            cell.onRemoveFavorite = { [weak self] currency in
                guard let self = self else { return }
                if let idx = self.currencies.firstIndex(where: { $0.code == currency.code }) {
                    self.currencies[idx].isFavorite = false
                }

                if let filteredIdx = self.filteredCurrencies.firstIndex(where: { $0.code == currency.code }) {
                    self.filteredCurrencies[filteredIdx].isFavorite = false
                }

                self.favoriteCurrencies.removeAll { $0.code == currency.code }
                self.updateDisplayItems()
            }

            return cell


        case .currency(let currency):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRateCell", for: indexPath) as? ExchangeRateCell else { return UITableViewCell() }
            let rate = krwRates[currency.code.lowercased()] ?? 0
            cell.configure(
                fullName: highlight(currency.name, searchText: searchText, defaultColor: UIColor.palette.blue ?? .blue, defaultFont: cell.fullNameLabel.font),
                code: highlight(currency.code, searchText: searchText, defaultColor: UIColor.palette.grey ?? .gray, defaultFont: cell.codeLabel.font),
                value: rate,
                tag: currency.isCrypto ? "CRYPTO" : "FIAT",
                tagColor: currency.isCrypto ? (UIColor.palette.yellowBg ?? .yellow) : (UIColor.palette.greenBG ?? UIColor.palette.green ?? .green),
                isFavorite: currency.isFavorite
            )
            cell.favoriteTapped = { [weak self] in
                guard let self = self else { return }
                if let idx = self.currencies.firstIndex(where: { $0.code == currency.code }) {
                    self.currencies[idx].isFavorite.toggle()

                    if self.currencies[idx].isFavorite {
                        if let rate = self.krwRates[currency.code.lowercased()] {
                            self.currencies[idx].krwRate = rate
                        }
                        self.favoriteCurrencies.append(self.currencies[idx])
                    } else {
                        self.favoriteCurrencies.removeAll { $0.code == currency.code }
                    }
                }

                if let filteredIdx = self.filteredCurrencies.firstIndex(where: { $0.code == currency.code }) {
                    self.filteredCurrencies[filteredIdx].isFavorite.toggle()
                }

                self.updateDisplayItems()
            }


            return cell

        case .coupon:
            return tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) ?? UITableViewCell()
        }
    }
}
