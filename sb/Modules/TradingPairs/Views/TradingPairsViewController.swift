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
        mainView.refreshPublisher.sink { [weak self] _ in
            self?.viewModel.input.send(.pulledToRefresh)
        }.store(in: &bin)
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
                case let .filtered(items):
                    self?.load(with: items)
                    self?.onSuccessLoad()
                case let .updated(items):
                    self?.update(with: items)
                    self?.onSuccessLoad()
                case .showConnectionIssueIndicator:
                    self?.onFailToLoad()
                case .showConnectionIssueAlert:
                    self?.showConnectionIssueAlert()
                }
        }.store(in: &bin)
    }
    
    func showConnectionIssueAlert() {
        let alert = UIAlertController(
            title: "Connection issues",
            message: "It looks like you've got some connection issues. Some data might be outdated or missing.", preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Refresh",
                style: .default, handler: { [weak self] _ in
                    self?.viewModel.input.send(.alertConfirmed)
                }
            )
        )
        
        present(alert, animated: true)
    }
    
    func showIndicator() {
        let indicator = ConnectionIssueButton(onTap: { [weak self] in
            self?.viewModel.input.send(.connectionIndicatorTapped)
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
    }
    
    func onFailToLoad() {
        mainView.endRefresh()
        showIndicator()
    }
    
    func onSuccessLoad() {
        mainView.endRefresh()
        hideIndicator()
    }
    
    func hideIndicator() {
        navigationItem.rightBarButtonItem = nil
    }
    
    func load(with items: [TradingPairItemModel]) {
        mainView.reload(with: items)
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
