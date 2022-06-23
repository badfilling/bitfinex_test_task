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
    
    private var mainView: TradingPairsView {
        return self.view as! TradingPairsView
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: TradingPairsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
        setupSearchController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.title = "Pairs prices"
        self.view = TradingPairsView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.send(.viewDidLoad)
    }
}

private extension TradingPairsViewController {
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter coin code"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .loaded(items):
                    self?.load(items: items)
                case let .updated(items):
                    self?.update(with: items)
                }
        }.store(in: &bin)
    }
    
    func load(items: [TradingPairItemModel]) {
        mainView.load(items: items)
    }
    
    func update(with items: [TradingPairItemModel]) {
        mainView.update(with: items)
    }
}

extension TradingPairsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchInput = searchController.searchBar.text else { return }
        viewModel.input.send(.search(text: searchInput))
    }
}
