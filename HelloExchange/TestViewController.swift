//
//  TestViewController.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import UIKit

final class TestViewController: UIViewController {

    private let tableView = UITableView()

    private let coupons: [(time: TimeInterval, available: Bool)] = [
        (60, true)
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

        tableView.register(CouponCell.self, forCellReuseIdentifier: "CouponCell")
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource
extension TestViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as? CouponCell else {
            return UITableViewCell()
        }

        let coupon = coupons[indexPath.row]
        cell.configure(remainingTime: coupon.time, isAvailable: coupon.available)

        return cell
    }
}
