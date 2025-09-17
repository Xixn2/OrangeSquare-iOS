//
//  ExchangeRateCell.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import UIKit
import SnapKit

final class CouponCell: UITableViewCell {

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.palette.blueLight?.cgColor
        $0.backgroundColor = .white
    }

    private let messageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }

    private let progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = .palette.blueLight
        $0.trackTintColor = .white
    }

    private let receiveButton = UIButton(type: .system).then {
        $0.setTitle("받기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .palette.blue
    }

    private var timer: Timer?
    private var remainingTime: TimeInterval = 60
    private var isAvailable: Bool = true

    private let storageKey = "couponCellState" // UserDefaults key

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupLayout()
        loadState() // 앱 재실행 시 상태 불러오기
        configureTimer()
        receiveButton.addTarget(self, action: #selector(receiveButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        [messageLabel, progressView, receiveButton].forEach { containerView.addSubview($0) }
    }

    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.verticalEdges.equalToSuperview().inset(8)
            //$0.edges.equalToSuperview().inset(10)
            $0.height.equalTo(70)

        }

        receiveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(32)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(receiveButton.snp.leading).offset(-8)
        }

        progressView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(8)
            $0.leading.equalTo(messageLabel)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
    }

    // MARK: - Persistent State
    private func saveState() {
        let dict: [String: Any] = [
            "isAvailable": isAvailable,
            "remainingTime": remainingTime,
            "timestamp": Date().timeIntervalSince1970
        ]
        UserDefaults.standard.set(dict, forKey: storageKey)
    }

    private func loadState() {
        guard let dict = UserDefaults.standard.dictionary(forKey: storageKey) else { return }
        let savedIsAvailable = dict["isAvailable"] as? Bool ?? true
        var savedRemainingTime = dict["remainingTime"] as? TimeInterval ?? 60
        let savedTimestamp = dict["timestamp"] as? TimeInterval ?? Date().timeIntervalSince1970

        // 앱 종료 후 시간 계산
        let elapsed = Date().timeIntervalSince1970 - savedTimestamp
        if !savedIsAvailable {
            savedRemainingTime -= elapsed
            if savedRemainingTime <= 0 {
                isAvailable = true
                remainingTime = 60
            } else {
                isAvailable = false
                remainingTime = savedRemainingTime
            }
        } else {
            isAvailable = true
            remainingTime = savedRemainingTime
        }
    }

    private func configureTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        updateUI()
    }

    // MARK: - Configure
    func configure() {
        updateUI()
    }

    private func updateUI() {
        if isAvailable {
            let text = "쿠폰이 없어지기까지 \(Int(remainingTime))초 남았어요.\n어서 쿠폰을 받아보세요!"
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: "\(Int(remainingTime))") {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.foregroundColor, value: UIColor.palette.blueDark, range: nsRange)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            }
            messageLabel.attributedText = attributedText
            messageLabel.textAlignment = .center
            receiveButton.isEnabled = true
            receiveButton.backgroundColor = .palette.blueLight
            progressView.isHidden = false
            progressView.progress = Float(remainingTime / 60)
        } else {
            let timeString = formatTime(remainingTime)
            let text = "다음 쿠폰은 \(timeString) 후에 받을 수 있어요"
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: timeString) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.foregroundColor, value: UIColor.palette.blueDark, range: nsRange)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            }
            messageLabel.attributedText = attributedText
            messageLabel.textAlignment = .center
            receiveButton.isEnabled = false
            receiveButton.backgroundColor = .systemGray3
            progressView.isHidden = true
        }
        saveState()
    }

    private func tick() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            if isAvailable {
                isAvailable = false
                remainingTime = 24 * 3600 - 1
            } else {
                isAvailable = true
                remainingTime = 60
            }
        }
        updateUI()
    }

    @objc private func receiveButtonTapped() {
        guard isAvailable else { return }
        isAvailable = false
        remainingTime = 60
        updateUI()
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let hrs = Int(interval) / 3600
        let mins = (Int(interval) % 3600) / 60
        let secs = Int(interval) % 60
        return "\(hrs)시간 \(mins)분 \(secs)초"
    }

    deinit {
        timer?.invalidate()
    }
}
