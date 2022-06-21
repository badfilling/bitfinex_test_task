//
//  TradingPairsView.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit

class TradingPairsView: UIView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TradingPairCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TradingPairCellViewModel>
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        
        cv.register(TradingPairCell.self, forCellWithReuseIdentifier: TradingPairCell.cellIdentifier)
        return cv
    }()
    
    lazy var dataSource = makeDataSource()
    
    func setupViews() {
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
}

private extension TradingPairsView {
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        return .init(section: section)
    }
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self] cv, indexPath, item -> UICollectionViewCell? in
            
            guard let self = self else { return nil }
            
            if let cell = cv.dequeueReusableCell(
                withReuseIdentifier: TradingPairCell.cellIdentifier,
                for: indexPath
            ) as? TradingPairCell {
                cell.setup(with: item)
                return cell
            }
            
            return nil
        }
    }
}
