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
    var cacheStore: MediasCacheStore?
    
    init() {
        networkManager = ItunesNetworkManager()
        cacheStore = MediasCacheStore()
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
            
            // check the deleted medias inside the items and remove them
            let copiedItems = self?.checkCachedRemovedAndSelectedItems(items: items) ?? []
            
            // Update the memory store, when the items fetched from network
            self?.updateItems(items: copiedItems)
            completionHandler(copiedItems, nil)
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
    
    private func checkCachedRemovedAndSelectedItems(items: [ItunesItem]) -> [ItunesItem] {
        
        var copiedItems = items
        
        for item in items {
            if let cacheStore = self.cacheStore {
                
                if let deletedBefore = cacheStore.loadMedia(check: item, with: .deletion) {
                    // find that deletedBeforeItem and remove it from items
                    if let deletedBeforeIndex = copiedItems.firstIndex(of: deletedBefore) {
                        copiedItems.remove(at: deletedBeforeIndex)
                    }
                } else if let selectedBefore = cacheStore.loadMedia(check: item, with: .selection) {
                    // check that item is selected before
                    if let selectedBeforeIndex = copiedItems.firstIndex(of: selectedBefore) {
                        copiedItems[selectedBeforeIndex].isSelected = true
                    }
                }
            }
        }
        
        return copiedItems
    }
}
