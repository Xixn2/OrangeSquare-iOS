//
//  ExchangeRateCell.swift
//  HelloExchange
//
//  Created by 서지완 on 9/16/25.
//

import UIKit
import Then
import SnapKit

final class ExchangeRateCell: UITableViewCell {

    private let backgroundCardView = UIView().then {
        $0.backgroundColor = UIColor.systemGray6
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    private let favoriteButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "heart"), for: .normal)
        $0.tintColor = .lightGray
    }

    public let fullNameLabel = TypographyLabel(
        text: " ",
        typography: .subheadBold,
        color: .palette.blue
    )

    public let codeLabel = TypographyLabel(
        text: " ",
        typography: .subhead,
        color: .palette.grey
    )

    private let separatorBar = UIView().then {
        $0.backgroundColor = .palette.greyLight
    }

    private let tagLabel = TypographyLabel(
        text: " ",
        typography: .caption,
        color: .palette.yellow
    ) .then {
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    private let valueLabel = TypographyLabel(
        text: " ",
        typography: .subheadBold,
        color: .palette.greyDarkest
    )

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addViews()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Add Subviews
    private func addViews() {
        contentView.addSubview(backgroundCardView)
        [favoriteButton, fullNameLabel, separatorBar, codeLabel, tagLabel, valueLabel].forEach {
            backgroundCardView.addSubview($0)
        }
    }

    // MARK: - Layout
    private func setLayout() {
        backgroundCardView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.greaterThanOrEqualTo(70)
        }

        favoriteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(27)
            $0.width.equalTo(30)
        }

        fullNameLabel.snp.makeConstraints {
            $0.leading.equalTo(favoriteButton.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(12)
        }

        separatorBar.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(15)
            $0.leading.equalTo(fullNameLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(fullNameLabel).offset(1)
        }

        codeLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorBar.snp.trailing).offset(5)
            $0.centerY.equalTo(fullNameLabel)
        }

        tagLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalTo(fullNameLabel)
            $0.height.equalTo(20)
        }

        valueLabel.snp.makeConstraints {
            $0.trailing.equalTo(tagLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    // MARK: - Configure (NSAttributedString 지원)
    func configure(
        fullName: NSAttributedString,
        code: NSAttributedString,
        value: String,
        tag: String,
        tagColor: UIColor
    ) {
        fullNameLabel.attributedText = fullName
        codeLabel.attributedText = code
        valueLabel.text = value
        tagLabel.text = tag
        tagLabel.backgroundColor = tagColor
    }

    // 오버로드: 기존 String 버전과의 호환성을 위해 추가
    func configure(
        fullName: String,
        code: String,
        value: String,
        tag: String,
        tagColor: UIColor
    ) {
        configure(
            fullName: NSAttributedString(string: fullName),
            code: NSAttributedString(string: code),
            value: value,
            tag: tag,
            tagColor: tagColor
        )
    }
}
