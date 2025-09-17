import UIKit
import Then
import SnapKit

final class ExchangeRateCell: UITableViewCell {

    private let backgroundCardView = UIView().then {
        $0.backgroundColor = UIColor.systemGray6
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }

    let favoriteButton = UIButton(type: .system).then {
        $0.configuration = nil
        $0.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .lightGray
        $0.adjustsImageWhenHighlighted = false
    }

    public let fullNameLabel = TypographyLabel(
        text: " ",
        typography: .subheadBold,
        color: .palette.blue
    ).then {
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }

    public let codeLabel = TypographyLabel(
        text: " ",
        typography: .subhead,
        color: .palette.grey
    ).then {
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }

    private let separatorBar = UIView().then {
        $0.backgroundColor = .palette.greyLight
    }

    private let tagLabel = UIButton(type: .system).then {
        $0.setTitle(" ", for: .normal)
        $0.setTitleColor(.palette.yellow, for: .normal)
        $0.titleLabel?.font = Typography.caption.font
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.isUserInteractionEnabled = false
    }

    private let valueLabel = TypographyLabel(
        text: " ",
        typography: .subheadBold,
        color: .palette.greyDarkest
    )

    var favoriteTapped: (() -> Void)?
    private var isFavoriteLocal = false

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 12
        f.usesGroupingSeparator = false
        return f
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addViews()
        setLayout()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func addViews() {
        contentView.addSubview(backgroundCardView)
        [favoriteButton, fullNameLabel, separatorBar, codeLabel, tagLabel, valueLabel].forEach {
            backgroundCardView.addSubview($0)
        }
    }

    private func setLayout() {
        backgroundCardView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.greaterThanOrEqualTo(70)
        }

        favoriteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 30, height: 27))
        }

        fullNameLabel.snp.makeConstraints {
            $0.leading.equalTo(favoriteButton.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(80) // tagLabel과 겹치지 않게
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
            $0.trailing.lessThanOrEqualTo(tagLabel.snp.leading).offset(-8)
        }

        tagLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalTo(fullNameLabel)
            $0.trailing.equalToSuperview().inset(15)
            $0.leading.greaterThanOrEqualTo(codeLabel.snp.trailing).offset(8)
        }

        valueLabel.snp.makeConstraints {
            $0.trailing.equalTo(tagLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    func configure(fullName: NSAttributedString,
                   code: NSAttributedString,
                   value: Double?,
                   tag: String,
                   tagColor: UIColor,
                   isFavorite: Bool) {
        fullNameLabel.attributedText = fullName
        codeLabel.attributedText = code
        valueLabel.text = value != nil ? Self.formatter.string(from: NSNumber(value: value!)) : "-"
        tagLabel.setTitle(tag, for: .normal)
        tagLabel.backgroundColor = tagColor
        isFavoriteLocal = isFavorite
        applyFavoriteUI(animated: false)
    }

    private func applyFavoriteUI(animated: Bool) {
        let imageName = isFavoriteLocal ? "heart.fill" : "heart"
        let img = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        let tint = isFavoriteLocal ? UIColor.systemPink : UIColor.lightGray
        let changes = { self.favoriteButton.setImage(img, for: .normal); self.favoriteButton.tintColor = tint }

        if animated {
            UIView.transition(with: favoriteButton, duration: 0.18, options: .transitionCrossDissolve, animations: changes)
        } else {
            changes()
        }
    }

    @objc private func favoriteButtonPressed() {
        isFavoriteLocal.toggle()
        applyFavoriteUI(animated: true)
        favoriteTapped?()
    }
}
