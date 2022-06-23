//
//  TradingPairsView.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit

class TradingPairsView: UIView {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: TradingPairsViewLayout.generate()
        )
        
        cv.register(TradingPairCell.self, forCellWithReuseIdentifier: TradingPairCell.cellIdentifier)
        return cv
    }()
    
    private lazy var dataSource = makeDataSource()
    
    private var itemsStore: [String: TradingPairItemModel] = [:]
    
    func load(items: [TradingPairItemModel]) {
        updateStore(with: items)
        
        var snapshot = TradingPairsView.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map { $0.id }, toSection: 0)
        
        dataSource.apply(snapshot)
    }
    
    func update(with items: [TradingPairItemModel]) {
        updateStore(with: items)
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(items.map { $0.id })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension TradingPairsView {
    private func updateStore(with items: [TradingPairItemModel]) {
        itemsStore = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
    }
    
    private func setupViews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = dataSource
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] cv, indexPath, itemId -> UICollectionViewCell? in
            
            guard let self = self else { return nil }
            
            if let cell = cv.dequeueReusableCell(
                withReuseIdentifier: TradingPairCell.cellIdentifier,
                for: indexPath
            ) as? TradingPairCell,
               let model = self.itemsStore[itemId] {
                cell.setup(with: model)
                return cell
            }
            
            return nil
        }
    }
}
