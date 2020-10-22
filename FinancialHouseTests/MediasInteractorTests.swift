//
//  MediasInteractorTests.swift
//  FinancialHouse
//
//  Created by Olgu on 21.10.2020.
//

@testable import FinancialHouse
import XCTest

class MediasInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MediasInteractor!
    var mockedItems: [ItunesItem]!
    var mockedItem: ItunesItem!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        mockedItems = configureMockItems(T: MediasInteractorTests.self)!.results!
        mockedItem = configureMockItems(T: MediasInteractorTests.self)!.results!.first
    
        setupMediasInteractor()
    }
    
    override func tearDown() {
        mockedItems = nil
        mockedItem = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupMediasInteractor() {
        sut = MediasInteractor()
    }
    
    // MARK: Test doubles
    
    class MediasPresentationLogicSpy: MediasPresentationLogic {
        var presentMediaCalled = false
        var configurePlaceholderCalled = false
        var deleteMediaCalled = false
        var updateMediaCalled = false

        func presentMedia(response: Medias.FetchMedias.Response) {
            presentMediaCalled = true
        }
        
        func configurePlaceholder(dependsOnThe type: Medias.FetchMedias.MediaType) {
            configurePlaceholderCalled = true
        }
        
        func deleteMedia(response: Medias.DeleteMedia.Response) {
            deleteMediaCalled = true
        }
        
        func updateMedia(response: Medias.UpdateMedia.Response) {
            updateMediaCalled = true
        }

    }
    
    class MediasWorkerSpy: MediasWorker {
        
        var fetchMediasCalled = false
        var deleteMediaCalled = false
        
        override func fetchMedias(request: Medias.FetchMedias.Request,
                         completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
            super.fetchMedias(request: request, completionHandler: completionHandler)
            fetchMediasCalled = true
        }
        
        override func deleteMedia(request: Medias.DeleteMedia.Request,
                         completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
            super.deleteMedia(request: request, completionHandler: completionHandler)
            deleteMediaCalled = true
        }
    }
    
    class RepositorySpy: MediasStoreProtocol {
        
        var fetchMediasCalled = false
        var deleteMediaCalled = false

        func fetchMedias(request: Medias.FetchMedias.Request, completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
            
            let items = configureMockItems(T: MediasInteractorTests.self)!.results!
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchMediasCalled = true
                completionHandler(items, nil)
            }
        }
        
        func deleteMedia(request: Medias.DeleteMedia.Request, completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
            
            let items = configureMockItems(T: MediasInteractorTests.self)!.results!
            let item = items.first!
            let indexPath = IndexPath(item: 0, section: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.deleteMediaCalled = true
                completionHandler(item, indexPath, items, nil)
            }
        }
    }
    
    // MARK: Tests
    
    func testPresentMedia() {
        
        // Given
        let presentationLogicSpy = MediasPresentationLogicSpy()
        sut.presenter = presentationLogicSpy
        let worker = MediasWorkerSpy(ordersStore: RepositorySpy())
        sut.worker = worker
        
        let expect = expectation(description: "Wait for expectation for fetch medias")
        
        // When
        let request = Medias.FetchMedias.Request(term: "Swift")
        sut.fetchMedias(request: request)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssert(worker.fetchMediasCalled, "FetchMedia() should ask worker to fetch medias")
        XCTAssert(presentationLogicSpy.presentMediaCalled, "FetchMedia() should ask presenter to connection with UI")
    }
    
    func testDeleteMedia() {
        // Given
        let presentationLogicSpy = MediasPresentationLogicSpy()
        sut.presenter = presentationLogicSpy
        let worker = MediasWorkerSpy(ordersStore: RepositorySpy())
        sut.worker = worker
        
        let expect = expectation(description: "Wait for expectation for deleteItem")
        
        // When
        let request = Medias.DeleteMedia.Request(item: mockedItem)
        sut.deleteItem(request: request)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssert(worker.deleteMediaCalled, "FetchOrders() should ask OrdersWorker to fetch orders")
        XCTAssert(presentationLogicSpy.deleteMediaCalled, "DeleteMedia should ask presenter to connection with UI")
    }
    
    func testUpdateMedia() {
    
        // Given
        let presentationLogicSpy = MediasPresentationLogicSpy()
        sut.presenter = presentationLogicSpy
        let worker = MediasWorkerSpy(ordersStore: RepositorySpy())
        sut.worker = worker
        
        let expect = expectation(description: "Wait for expectation for Fetch first and select Item for trigger to update")
        
        // When
        let request = Medias.FetchMedias.Request(term: "Swift")
        sut.fetchMedias(request: request)
        
        // After When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.selectedItem(with: IndexPath(item: 0, section: 0))
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssert(presentationLogicSpy.updateMediaCalled, "Update media should ask presenter to connection with UI")
    }
}
