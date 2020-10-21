//
//  MediasMemStore.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import Foundation

final class MediasMemStore: MediasStoreProtocol {
    
    fileprivate let items: [ItunesItem]
    
    init(items: [ItunesItem]) {
        self.items = items
    }
    
    func fetchMedias(request: Medias.FetchMedias.Request,
                     completionHandler: @escaping ([ItunesItem]?, ItunesNetworkError?) -> Void) {
        completionHandler(items, nil)
    }
    
    func deleteMedia(request: Medias.DeleteMedia.Request,
                     completionHandler: @escaping (ItunesItem?, IndexPath?, [ItunesItem]?, ItunesNetworkError?) -> Void) {
        
        guard let id = request.item.collectionId else {
            completionHandler(nil, nil, self.items ,ItunesNetworkError.cannotDeleteId)
            return
        }
        
        if let index = indexOfOrderWithID(id: id) {
            var items = self.items
            let indexPath = IndexPath(item: index, section: 0)
            let item = items.remove(at: index)
            completionHandler(item, indexPath, items, nil)
            return
        }
        completionHandler(nil, nil, items, ItunesNetworkError.cannotDelete)
    }
    
    // MARK: - Convenience methods
    
    private func indexOfOrderWithID(id: Int?) -> Int? {
        let deletedItemIndex = self.items.firstIndex(where: { $0.collectionId == id })
        return deletedItemIndex
    }
}

// MARK: - Orders store CRUD operation errors

enum MediaStoreError: Equatable, Error {
    case cannotFetch(String)
    case cannotDelete(String)
}

func ==(lhs: MediaStoreError, rhs: MediaStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    case (.cannotDelete(let a), .cannotDelete(let b)) where a == b: return true
    default: return false
    }
}
