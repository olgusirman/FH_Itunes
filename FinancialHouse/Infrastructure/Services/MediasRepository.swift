//
//  MediasRepository.swift
//  FinancialHouse
//
//  Created by Olgu on 19.10.2020.
//

import Foundation

final class MediasRepository: MediasStoreProtocol {
    
    var memoryStore: MediasMemStore?
    var networkManager: ItunesNetworkManager?
    // TODO: There should be also cached manager
    
    init() {
        networkManager = ItunesNetworkManager()
        
    }
    
    func updateItems(items: [ItunesItem]) {
        self.memoryStore = MediasMemStore(items: items)
    }
    
    func fetchMedias(request: Medias.FetchMedias.Request,
                     completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
        
        // first fetch from network
        // after that update memory cache
        // update the hard cache
        networkManager?.fetchMedias(request: request, completionHandler: { [weak self] (items, error) in
            
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let items = items else {
                completionHandler(nil, ItunesNetworkError.noData)
                return
            }
            
            // Update the memory store, when the items fetched from network
            self?.updateItems(items: items)
            completionHandler(items, nil)
        })
        
    }

    func deleteMedia(request: Medias.DeleteMedia.Request,
                     completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
               
        // first fetch from network (for this there is no network so only memory)
        // after that update memory cache
        // update the hard cache
        self.memoryStore?.deleteMedia(request: request, completionHandler: { [weak self] (deletedItem, deletedIndexPath, items, error) in
            
            if let error = error {
                completionHandler(nil, nil, items ,error)
                return
            }
            
            guard let items = items else {
                completionHandler(nil, deletedIndexPath, nil, ItunesNetworkError.noData)
                return
            }
            
            self?.updateItems(items: items)
            completionHandler(deletedItem, deletedIndexPath, items, nil)
        })
    }
}
