//
//  MediasCacheStore.swift
//  FinancialHouse
//
//  Created by Olgu on 19.10.2020.
//

import Foundation

private extension FileManager {
    static var documentsDirectoryURL: URL {
        return `default`.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}

struct MediasCacheStore {
    fileprivate let fileManager = FileManager.default
    fileprivate let decoder = JSONDecoder()
    fileprivate let encoder = JSONEncoder()
    
    enum CachePurpose: String {
        case selection
        case deletion
    }
    
    func saveMedia(item: ItunesItem, with purpose: CachePurpose) {
        encoder.outputFormatting = .prettyPrinted
        
        guard let url = configurePathUrl(item: item, with: purpose) else { return }
        
        do {
            let itunesItemData = try encoder.encode(item)
            try itunesItemData.write(to: url, options: .atomicWrite)
        } catch {
            debugPrint(error)
        }
    }
    
    func loadMedia(check item: ItunesItem, with purpose: CachePurpose) -> ItunesItem? {
        
        guard let url = configurePathUrl(item: item, with: purpose), fileManager.fileExists(atPath: url.path) else { return nil }
        
        do {
            let itunesItemData = try Data(contentsOf: url)
            let itunesItem = try decoder.decode(ItunesItem.self, from: itunesItemData)
            return itunesItem
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    /// Use item collectionId for cache URL
    fileprivate func configurePathUrl(item: ItunesItem, with purpose: CachePurpose) -> URL? {
        
        guard let collectionId = item.collectionId else {
            return nil
        }
        let path = "\(purpose.rawValue)-\(collectionId)"
        let jsonUrl = URL(fileURLWithPath: path,
                          relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
        return jsonUrl
    }
}
