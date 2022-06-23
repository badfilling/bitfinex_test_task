//
//  TradingPairCell.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit

class TradingPairCell: UICollectionViewCell {
    
    lazy var coinIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .black)
        return lbl
    }()
    
    lazy var coinSymbolLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .bold)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    lazy var coinPriceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .black)
        return lbl
    }()
    
    lazy var coinPriceChangeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .bold)
        lbl.textColor = .systemGreen
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let shadowBounds = layer.shadowPath?.boundingBoxOfPath,
           shadowBounds.equalTo(bounds) { return }
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        setupShadowIfNeeded()
    }
    
    func setup(with model: TradingPairItemModel) {
        coinIcon.image = model.coinIcon
        fullNameLabel.text = model.coinFullName
        coinSymbolLabel.text = model.coinSymbol
        coinPriceLabel.text = model.coinPrice
        coinPriceChangeLabel.text = model.coinPriceChange
        coinPriceChangeLabel.textColor = model.priceIncreased ? .systemGreen : .systemRed
    }
}

private extension TradingPairCell {
    func setupViews() {
        setupCellStyles()
        
        [
            coinIcon,
            fullNameLabel,
            coinSymbolLabel,
            coinPriceLabel,
            coinPriceChangeLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let namesStack = UIStackView()
        namesStack.translatesAutoresizingMaskIntoConstraints = false
        namesStack.axis = .vertical
        namesStack.spacing = 8
        namesStack.alignment = .leading
        namesStack.addArrangedSubview(fullNameLabel)
        namesStack.addArrangedSubview(coinSymbolLabel)
        
        let pricesStack = UIStackView()
        pricesStack.translatesAutoresizingMaskIntoConstraints = false
        pricesStack.axis = .vertical
        pricesStack.spacing = 8
        pricesStack.alignment = .trailing
        pricesStack.addArrangedSubview(coinPriceLabel)
        pricesStack.addArrangedSubview(coinPriceChangeLabel)
        
        [
            coinIcon,
            namesStack,
            pricesStack
        ].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            coinIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coinIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinIcon.heightAnchor.constraint(equalToConstant: 48),
            coinIcon.widthAnchor.constraint(equalToConstant: 48),
            
            namesStack.leadingAnchor.constraint(equalTo: coinIcon.trailingAnchor, constant: 16),
            namesStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            namesStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            pricesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pricesStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pricesStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupCellStyles() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        contentView.layer.borderWidth = 2
        contentView.backgroundColor = .white
    }
    
    func setupShadowIfNeeded() {
        guard layer.shadowOpacity.isZero else { return }
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
}
