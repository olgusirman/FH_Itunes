//
//  MediasPresenterTests.swift
//  FinancialHouse
//
//  Created by Olgu on 21.10.2020.
//

@testable import FinancialHouse
import XCTest

class MediasPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MediasPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMediasPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupMediasPresenter() {
        sut = MediasPresenter()
    }
    
    // MARK: Test doubles
    
    class MediasDisplayLogicSpy: MediasDisplayLogic {
        var displayItemsCalled = false
        var configureSearchBarPlaceholderCalled = false
        var deleteMediaCalled = false
        var updateMediaCalled = false

        func displayItems(viewModel: Medias.FetchMedias.ViewModel) {
            displayItemsCalled = true
        }
        
        func configureSearchBarPlaceholder(placeholder: String) {
            configureSearchBarPlaceholderCalled = true
        }
        
        func deleteMedia(viewModel: Medias.DeleteMedia.ViewModel) {
            deleteMediaCalled = true
        }
        
        func updateMedia(viewModel: Medias.UpdateMedia.ViewModel) {
            updateMediaCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentMedia() {
        // Given
        let spy = MediasDisplayLogicSpy()
        sut.viewController = spy
        let response = Medias.FetchMedias.Response(items: [])
        
        // When
        sut.presentMedia(response: response)
        
        // Then
        XCTAssertTrue(spy.displayItemsCalled, "presentMedia should ask the view controller to display the result")
    }
    
    func testConfigureSearchBarPlaceholder() {
        // Given
        let spy = MediasDisplayLogicSpy()
        sut.viewController = spy
        
        // When
        sut.configurePlaceholder(dependsOnThe: .all)
        
        // Then
        XCTAssertTrue(spy.configureSearchBarPlaceholderCalled, "configurePlaceholder should ask the view controller to display the result")
    }
    
    func testDeleteMedia() {
        // Given
        let spy = MediasDisplayLogicSpy()
        sut.viewController = spy
        let response = Medias.DeleteMedia.Response(result: .success(configureMockItems(T: MediasPresenterTests.self)!.results!.first!), itemsAfterDeleted: [], deletedIndexPath: IndexPath(item: 0, section: 0))
        
        // When
        sut.deleteMedia(response: response)
        
        // Then
        XCTAssertTrue(spy.deleteMediaCalled, "deleteMediaCalled should ask the view controller to display the result")
    }
    
    func testUpdateMedia() {
        // Given
        let spy = MediasDisplayLogicSpy()
        sut.viewController = spy
        let response = Medias.UpdateMedia.Response(updatedIndexPath: IndexPath(item: 0, section: 0))
        
        // When
        sut.updateMedia(response: response)
        
        // Then
        XCTAssertTrue(spy.updateMediaCalled, "updateMediaCalled should ask the view controller to display the result")
    }
    
}
