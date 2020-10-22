//
//  MediasWorkerTests.swift
//  FinancialHouse
//
//  Created by Olgu on 21.10.2020.
//

@testable import FinancialHouse
import XCTest

class MediasWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MediasWorker!
    var mockedItems: [ItunesItem]!
    var mockedItem: ItunesItem!
    var repositorySpy: RepositorySpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        mockedItems = configureMockItems(T: MediasInteractorTests.self)!.results!
        mockedItem = configureMockItems(T: MediasInteractorTests.self)!.results!.first
        repositorySpy = RepositorySpy()
        setupMediasWorker()
    }
    
    override func tearDown() {
        mockedItems = nil
        mockedItem = nil
        super.tearDown()
    }
    
    class RepositorySpy: MediasStoreProtocol {
        
        var fetchMediasCalled = false
        var deleteMediaCalled = false

        func fetchMedias(request: Medias.FetchMedias.Request, completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
            
            let items = configureMockItems(T: MediasInteractorTests.self)!.results!
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fetchMediasCalled = true
                completionHandler(items, nil)
            }
        }
        
        func deleteMedia(request: Medias.DeleteMedia.Request, completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
            
            let items = configureMockItems(T: MediasInteractorTests.self)!.results!
            let item = items.first!
            let indexPath = IndexPath(item: 0, section: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.deleteMediaCalled = true
                completionHandler(item, indexPath, items, nil)
            }
        }
    }
    
    // MARK: Test setup
    
    func setupMediasWorker() {
        sut = MediasWorker(ordersStore: repositorySpy)
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testFetchMediasWorker() {
        // Given
        let request = Medias.FetchMedias.Request(term: "Swift", media: .podcast)
        let expect = expectation(description: "Wait for fetchMedias() to return")
        
        var fetchedItems: [ItunesItem]?
        sut.fetchMedias(request: request) { (items, error) in
            // When
            fetchedItems = items
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3)

        // Then
        XCTAssert(repositorySpy.fetchMediasCalled, "Calling fetchMediasCalled should ask the data store")
        XCTAssertEqual(fetchedItems, mockedItems, "fetchedItems should be the same with mocks")
    }
    
    func testDeleteMediasWorker() {
        // Given
        let request = Medias.DeleteMedia.Request(item: mockedItem)
        let expect = expectation(description: "Wait for deleteMedias() to return")
        
        var deletedItem: ItunesItem?
        sut.deleteMedia(request: request) { (item, indexPath, items, error) in
            // When
            deletedItem = item
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3)

        // Then
        XCTAssert(repositorySpy.deleteMediaCalled, "Calling deleteMediaCalled should ask the data store")
        XCTAssertEqual(deletedItem, mockedItem, "deletedItem should be the same with mock")
    }
}
