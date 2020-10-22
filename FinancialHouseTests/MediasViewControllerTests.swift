//
//  MediasViewControllerTests.swift
//  FinancialHouse
//
//  Created by Olgu on 21.10.2020.

@testable import FinancialHouse
import XCTest

class MediasViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: MediasViewController!
    var window: UIWindow!
    var mockedItems: [ItunesItem]!
    var mockedItem: ItunesItem!
        
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupMediasViewController()
        loadView()
        mockedItems = configureMockItems(T: MediasInteractorTests.self)!.results!
        mockedItem = configureMockItems(T: MediasInteractorTests.self)!.results!.first
    }
    
    override func tearDown() {
        window = nil
        mockedItems = nil
        mockedItem = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupMediasViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(ofType: MediasViewController.self)
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class MediasBusinessLogicSpy: MediasBusinessLogic {
        
        var fetchMediasIsCalled = false
        var fetchMediasWithThrottle = false
        var selectedItemIsCalled = false
        var deleteItemIsCalled = false
        
        func fetchMedias(request: Medias.FetchMedias.Request) {
            fetchMediasIsCalled = true
        }
        
        func fetchMediasWithThrottle(request: Medias.FetchMedias.Request) {
            fetchMediasWithThrottle = true
        }
        
        func showMediaTypePopUp( typeSelectionHandler: @escaping (_ selectType: Medias.FetchMedias.MediaType) -> Void ) -> UIAlertController {
            let alertController = UIAlertController()
            return alertController
        }
        
        var latestSelectedType: Medias.FetchMedias.MediaType? {
            return .all
        }
        
        func selectedItem(with indexPath: IndexPath) {
            selectedItemIsCalled = true
        }
        
        func deleteItem(request: Medias.DeleteMedia.Request) {
            deleteItemIsCalled = true
        }
        
    }
    
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
    
    class CollectionViewSpy: UICollectionView {
        // MARK: Method call expectations
        
        var collectionViewReloaded = false
        
        // MARK: Spied methods
        
        override func reloadData() {
            collectionViewReloaded = true
        }
        
        override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
            //super.performBatchUpdates(updates, completion: completion)
            collectionViewReloaded = true
        }
        
    }
    
    // MARK: Tests
    
    func testFetchedMediasDisplay() {
        
        // Given
        let collectionViewSpy = CollectionViewSpy(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView = collectionViewSpy
        let spy = MediasBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        let expect = expectation(description: "Wait for expectation for fetch medias")
        spy.fetchMedias(request: Medias.FetchMedias.Request(term: "Swift"))
        let displayedMedias = [Medias.FetchMedias.ViewModel.DisplayedMedia(id: "1", mediaArtworkUrl: "", mediaName: "Paul Heagarty", isSelected: true)]

        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.displayItems(viewModel: Medias.FetchMedias.ViewModel(displayedMedias: displayedMedias))
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertTrue(collectionViewSpy.collectionViewReloaded, "collectionView should be triggered by interactor")
    }
    
    func testDeleteMediasDisplay() {
        
        // Given
        let collectionViewSpy = CollectionViewSpy(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView = collectionViewSpy
        let spy = MediasBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        let expect = expectation(description: "Wait for expectation for fetch medias")
        let viewModel = Medias.DeleteMedia.ViewModel(result: .success(mockedItem),
                                                     itemsAfterDeleted: mockedItems,
                                                     deletedIndexPath: IndexPath(item: 0, section: 0))

        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.deleteMedia(viewModel: viewModel)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertTrue(collectionViewSpy.collectionViewReloaded, "collectionView should be triggered by interactor")
    }
    
    func testUpdateeMediasDisplay() {
        
        // Given
        let collectionViewSpy = CollectionViewSpy(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut.collectionView = collectionViewSpy
        let spy = MediasBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        let expect = expectation(description: "Wait for expectation for fetch medias")
        spy.fetchMedias(request: Medias.FetchMedias.Request(term: "Swift"))
        let displayedMedias = [Medias.FetchMedias.ViewModel.DisplayedMedia(id: "1", mediaArtworkUrl: "", mediaName: "Paul Heagarty", isSelected: true)]
        let viewModel = Medias.UpdateMedia.ViewModel(updatedIndexPath: IndexPath(item: 0, section: 0))
        self.sut.displayItems(viewModel: Medias.FetchMedias.ViewModel(displayedMedias: displayedMedias))
        
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sut.updateMedia(viewModel: viewModel)
            expect.fulfill()
        }

        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertTrue(collectionViewSpy.collectionViewReloaded, "collectionView should be triggered by interactor")
    }
}
