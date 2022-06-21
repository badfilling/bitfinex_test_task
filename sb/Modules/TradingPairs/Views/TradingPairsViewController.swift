//
//  TradingPairsViewController.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit
import Combine

class TradingPairsViewController: UIViewController {
    
    private let viewModel: TradingPairsViewModel
    private var bin = Set<AnyCancellable>()
    
    var mainView: TradingPairsView {
        return self.view as! TradingPairsView
    }
    
    init(viewModel: TradingPairsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = TradingPairsView(frame: .zero)
        mainView.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.send(.viewDidLoad)
    }
}

private extension TradingPairsViewController {
    func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .loaded(items):
                    self?.load(items: items)
                }
        }.store(in: &bin)
    }
    
    func load(items: [TradingPairCellViewModel]) {
        var snapshot = TradingPairsView.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        
        mainView.dataSource.apply(snapshot)
    }
}
