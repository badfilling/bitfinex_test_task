//
//  TradingPairsViewModelTests.swift
//  sbTests
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import XCTest
import Combine
@testable import sb

class TradingPairsViewModelTests: XCTestCase {

    var dataStore: TradingPairsDataStoreMock!
    var service: TradingPairsServiceMock!
    var refreshController: TradingPairsRefreshControllerMock!
    var sut: TradingPairsViewModelImpl!
    var bin = Set<AnyCancellable>()
    override func setUpWithError() throws {
        
        bin = Set<AnyCancellable>()
        dataStore = TradingPairsDataStoreMock()
        service = TradingPairsServiceMock()
        refreshController = TradingPairsRefreshControllerMock()
        
        sut = TradingPairsViewModelImpl(
            dataStore: dataStore,
            service: service,
            refreshController: refreshController
        )
    }

    func testExample() throws {
    }
    
    func testItLoadsPairsOnViewDidLoad() {
        let exp = expectation(description: "items loaded from service")
        
        service.onLoadTradingPairs = { exp.fulfill() }
        
        sut.input.send(.viewDidLoad)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItUpdatesDataStoreOnItemsLoad() {
        let exp = expectation(description: "data store updated")
        let itemsToProvide = createDefaultItems()
        service.loadResult = .success(itemsToProvide)
        dataStore.onUpdate = { exp.fulfill() }
        
        sut.input.send(.viewDidLoad)
        
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(itemsToProvide, dataStore.itemsReceivedOnUpdate)
    }
    
    func testItOutputsItemsOnViewDidLoad() {
        let exp = expectation(description: "output received items")
        let itemsToProvide = createDefaultItems()
        dataStore.itemsToReturnOnUpdate = itemsToProvide
        sut.output.sink { output in
            switch output {
            case let .updated(items):
                XCTAssertEqual(items, itemsToProvide)
                exp.fulfill()
            default:
                XCTFail()
            }
        }.store(in: &bin)
        
        sut.input.send(.viewDidLoad)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItAppliesFilterQueryWhenReceived() {
        let query = "BNB"
        let expectedItems = createDefaultItems()
        let exp = expectation(description: "filtered items received")
        dataStore.itemsToReturnOnFilter = expectedItems
        sut.output.sink { output in
            switch output {
            case let .filtered(items):
                XCTAssertEqual(expectedItems, items)
                exp.fulfill()
            default:
                XCTFail()
            }
        }.store(in: &bin)
        
        sut.input.send(.search(text: query))

        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(dataStore.usedQuery, query)
    }
    
    func testItReloadsDataOnRefreshAlertConfirm() {
        let exp = expectation(description: "data is reloaded")
        service.onLoadTradingPairs = {
            exp.fulfill()
        }
        
        sut.input.send(.alertConfirmed)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItReloadsDataOnPullToRefresh() {
        let exp = expectation(description: "data is reloaded")
        service.onLoadTradingPairs = {
            exp.fulfill()
        }
        
        sut.input.send(.pulledToRefresh)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItShowsAlertOnIndicatorTap() {
        let exp = expectation(description: "alert is displayed")
        sut.output.sink { output in
            switch output {
            case .showConnectionIssueAlert:
                exp.fulfill()
            default:
                XCTFail()
            }
        }.store(in: &bin)
        
        sut.input.send(.connectionIndicatorTapped)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItBindsToRefresherWhenCreated() {
        let exp = expectation(description: "refresher is binded")
        refreshController.onCreateRefresher = { exp.fulfill() }
        
        sut = TradingPairsViewModelImpl(
            dataStore: dataStore,
            service: service,
            refreshController: refreshController
        )
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItLoadsItemsThreeTimesWhenRefresherTriggersThreeTimes() {
        let exp = expectation(description: "asbc")
        exp.expectedFulfillmentCount = 3
        exp.assertForOverFulfill = true
        service.onLoadTradingPairs = { exp.fulfill() }
        
        let refresherPublisher: AnyPublisher<Void, Never> = Deferred {
            Publishers.Sequence(sequence: [(), (), ()])
        }.eraseToAnyPublisher()
        refreshController.publisherToReturn = refresherPublisher
        
        sut = TradingPairsViewModelImpl(
            dataStore: dataStore,
            service: service,
            refreshController: refreshController
        )
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testItShowsIssueIndicatorOnLoadFailure() {
        let exp = expectation(description: "issue indicator shown")
        service.loadResult = .failure(NetworkError.unknownError)
        
        sut.output.sink { output in
            switch output {
            case .showConnectionIssueIndicator:
                exp.fulfill()
            default:
                XCTFail()
            }
        }.store(in: &bin)
        
        sut.input.send(.viewDidLoad)
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func createDefaultItems() -> [TradingPairItemModel] {
        return [
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Binance Coin",
                coinSymbol: "BNB",
                coinPrice: "$ 416.2002",
                coinPriceChange: "-2.01%",
                priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Ethereum Coin",
                coinSymbol: "ETH",
                coinPrice: "$ 4.2002",
                coinPriceChange: "+24.01%",
                priceIncreased: true
            )
        ]
    }
}
