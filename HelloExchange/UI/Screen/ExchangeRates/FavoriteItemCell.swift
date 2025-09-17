import UIKit
import SnapKit

final class FavoriteItemCell: UICollectionViewCell {

    private let flagImageView = UIImageView()
    private let codeLabel = TypographyLabel(text: " ", typography: .subheadBold, color: .palette.greyDarkest)
    private let nameLabel = TypographyLabel(text: " ", typography: .subhead, color: .palette.greyDark)
    private let rateLabel = TypographyLabel(text: " ", typography: .subheadBold, color: .palette.greyDarkest)
    private let removeButton = UIButton(type: .system)

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 12
        f.usesGroupingSeparator = false
        return f
    }()

    var removeTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        flagImageView.contentMode = .scaleAspectFill
        flagImageView.clipsToBounds = true
        flagImageView.snp.makeConstraints { $0.size.equalTo(32) }
        flagImageView.layer.cornerRadius = 16
        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor

        removeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        removeButton.tintColor = .gray
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)

        nameLabel.lineBreakMode = .byTruncatingTail
        codeLabel.lineBreakMode = .byTruncatingTail

        let textStack = UIStackView(arrangedSubviews: [codeLabel, nameLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .leading

        let topStack = UIStackView(arrangedSubviews: [flagImageView, textStack, removeButton])
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center

        contentView.addSubview(topStack)
        contentView.addSubview(rateLabel)

        topStack.snp.makeConstraints { $0.top.equalToSuperview().inset(10); $0.leading.trailing.equalToSuperview().inset(12) }
        removeButton.snp.makeConstraints { $0.size.equalTo(20) }
        rateLabel.snp.makeConstraints { $0.leading.equalToSuperview().inset(20); $0.trailing.equalToSuperview().inset(12); $0.bottom.equalToSuperview().inset(10) }
    }

    func configure(currency: Currency, rate: Double?) {
        codeLabel.text = currency.code
        nameLabel.text = currency.name
        rateLabel.text = rate != nil ? Self.formatter.string(from: NSNumber(value: rate!)) : "-"

        if let fiat = FiatCurrency(rawValue: currency.code.uppercased()), let url = fiat.country.thumbnailUrl {
            loadImage(from: url)
            flagImageView.isHidden = false
        } else {
            flagImageView.isHidden = true
        }
    }

    @objc private func removeButtonTapped() { removeTapped?() }

    private func loadImage(from url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { self.flagImageView.image = image }
        }.resume()
    }
}
