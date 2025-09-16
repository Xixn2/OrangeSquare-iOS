//
//  CouponCell.swift
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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupLayout()
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
            $0.edges.equalToSuperview().inset(16)
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

        if isAvailable {
            progressView.snp.makeConstraints {
                $0.top.equalTo(messageLabel.snp.bottom).offset(8)
                $0.leading.equalTo(messageLabel)
                $0.trailing.equalToSuperview().inset(12)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(4)
            }
        }
    }

    // MARK: - Configure
    func configure(remainingTime: TimeInterval = 60, isAvailable: Bool = true) {
        self.remainingTime = remainingTime
        self.isAvailable = isAvailable
        updateUI()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func updateUI() {
        if isAvailable {
            let text = "쿠폰이 없어지기까지 \(Int(remainingTime))초 남았어요.\n어서 쿠폰을 받아보세요!"
            let attributedText = NSMutableAttributedString(string: text)

            // 남은 초 숫자만 파란색 + 볼드
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

            // 시간 문자열만 파란색 + 볼드
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
    }

    private func tick() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateUI()
        } else {
            // 카운트가 끝나면 쿠폰 수령 가능 상태로 변경
            isAvailable = true
            remainingTime = 60
            updateUI()
        }
    }

    @objc private func receiveButtonTapped() {
        guard isAvailable else { return }
        // 쿠폰 수령 후 24시간 대기
        isAvailable = false
        remainingTime = 1 * 10 - 1 // 23시간 59분 59초
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
