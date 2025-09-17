import UIKit
import SnapKit

final class FavoritesCell: UITableViewCell, UICollectionViewDelegate {

    private let collectionView: UICollectionView

    var favorites: [Currency] = [] { didSet { collectionView.reloadData() } }
    var onRemoveFavorite: ((Currency) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 185, height: 110)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10); $0.height.equalTo(120) }

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteItemCell.self, forCellWithReuseIdentifier: "FavoriteItemCell")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FavoritesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { favorites.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteItemCell", for: indexPath) as? FavoriteItemCell else {
            return UICollectionViewCell()
        }
        let currency = favorites[indexPath.item]
        cell.configure(currency: currency, rate: currency.krwRate)
        cell.removeTapped = { [weak self] in self?.onRemoveFavorite?(currency) }
        return cell
    }
}
