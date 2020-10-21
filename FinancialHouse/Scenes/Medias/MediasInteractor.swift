//
//  MediasInteractor.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

protocol MediasBusinessLogic {
    
    func fetchMedias(request: Medias.FetchMedias.Request)
    
    /// Improve the performance and searching user experience, search process handled with throttle reactive wrapper
    func fetchMediasWithThrottle(request: Medias.FetchMedias.Request)
    
    /// Helper method to selection for media type
    func showMediaTypePopUp( typeSelectionHandler: @escaping (_ selectType: Medias.FetchMedias.MediaType) -> Void ) -> UIAlertController
    
    /// Internal storeage for cached the selected mediaType
    var latestSelectedType: Medias.FetchMedias.MediaType? { get }
    
    /// Update the DataStore for selected Item
    func selectedItem(with indexPath: IndexPath)
    
    /// DeletedItem interactor and also update the cache
    func deleteItem(request: Medias.DeleteMedia.Request)
}

protocol MediasDataStore {
    var items: [ItunesItem]? { get }
    var selectedItem: ItunesItem? { get set }
}

final class MediasInteractor: MediasBusinessLogic, MediasDataStore {
    var presenter: MediasPresentationLogic?
    var worker: MediasWorker?
    var items: [ItunesItem]?
    var selectedItem: ItunesItem?
   
    fileprivate var repository = MediasRepository()
    
    var latestSelectedType: Medias.FetchMedias.MediaType? {
        didSet {
            guard let latestSelectedType = latestSelectedType else {
                presenter?.configurePlaceholder(dependsOnThe: .all)
                return
            }
            presenter?.configurePlaceholder(dependsOnThe: latestSelectedType)
        }
    }
    
    private let validator = ThrottledTextValidator()
    
    // MARK: MediasBusinessLogic
    
    func fetchMedias(request: Medias.FetchMedias.Request) {
        worker = MediasWorker(ordersStore: repository)
        self.startFetching(with: request)
    }
    
    func fetchMediasWithThrottle(request: Medias.FetchMedias.Request) {
        worker = MediasWorker(ordersStore: repository)
        
        validator.validate(query: request.term) { [weak self] query in
            guard let query = query, !query.isEmpty else { return }
            self?.startFetching(with: request)
        }
    }
    
    private func startFetching(with request: Medias.FetchMedias.Request) {
        worker?.fetchMedias(request: request, completionHandler: { [weak self] (workerItems, error) in
            if let items = workerItems {
                self?.handleResponse(items: items)
            }
        })
    }
    
    private func handleResponse(items: [ItunesItem]) {
        self.items = items
        let response = Medias.FetchMedias.Response(items: items)
        self.presenter?.presentMedia(response: response)
    }
    
    func showMediaTypePopUp( typeSelectionHandler: @escaping (_ selectType: Medias.FetchMedias.MediaType) -> Void ) -> UIAlertController {
        let controller = UIAlertController(title: "Select Type", message: "Please select a media type to filter your medias", preferredStyle: .alert)
        
        let podcastAction = UIAlertAction(title: "Podcast", style: .default) { _ in
            self.latestSelectedType = .podcast
            typeSelectionHandler(.podcast)
        }
        
        let musicAction = UIAlertAction(title: "Music", style: .default) { _ in
            self.latestSelectedType = .music
            typeSelectionHandler(.music)
        }
        
        let movieAction = UIAlertAction(title: "Movie", style: .default) { _ in
            self.latestSelectedType = .movie
            typeSelectionHandler(.movie)
        }
        
        let allAction = UIAlertAction(title: "All", style: .default) { _ in
            self.latestSelectedType = .all
            typeSelectionHandler(.all)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        controller.addAction(podcastAction)
        controller.addAction(musicAction)
        controller.addAction(movieAction)
        controller.addAction(allAction)
        controller.addAction(cancelAction)
        return controller
    }
    
    func selectedItem(with indexPath: IndexPath) {
        // Update the model inline model and memoryStore
        items?[indexPath.item].isSelected = true
        
        let selectedItem = items?[indexPath.item]
        self.selectedItem = selectedItem
        
        if let items = items {
            self.repository.updateItems(items: items)
            let updateMediaResponse = Medias.UpdateMedia.Response(updatedIndexPath: indexPath)
            self.presenter?.updateMedia(response: updateMediaResponse)
            let response = Medias.FetchMedias.Response(items: items)
            self.presenter?.presentMedia(response: response)
        }
        
        // cache that selected item
        if let selectedItem = selectedItem {
            repository.cacheStore?.saveMedia(item: selectedItem, with: .selection)
        }
    }
    
    func deleteItem(request: Medias.DeleteMedia.Request) {
        
        worker = MediasWorker(ordersStore: repository)
        worker?.deleteMedia(request: request, completionHandler: { (deletedItem, deletedIndexPath, items, error) in
            
            if let error = error {
                let response = Medias.DeleteMedia.Response(result: .failure(error), itemsAfterDeleted: items, deletedIndexPath: nil)
                self.presenter?.deleteMedia(response: response)
                return
            }

            if let deletedIndexPath = deletedIndexPath {
                // FIXME: actually this case is not error, It should be include empty success case, with empty object or sth
                let response = Medias.DeleteMedia.Response(result: .failure(ItunesNetworkError.unknown), itemsAfterDeleted: items, deletedIndexPath: deletedIndexPath)
                self.presenter?.deleteMedia(response: response)
            }
            
            if let deletedItem = deletedItem {
                let response = Medias.DeleteMedia.Response(result: .success(deletedItem), itemsAfterDeleted: items, deletedIndexPath: nil)
                self.presenter?.deleteMedia(response: response)
                
                // Save the deleted Item
                self.repository.cacheStore?.saveMedia(item: deletedItem, with: .deletion)
            }
            
            // Update medias after cache process ended
            self.items = items
            let response = Medias.FetchMedias.Response(items: items)
            self.presenter?.presentMedia(response: response)
        })
    }

}
